import React, { useState, useEffect } from 'react';
import DataTable from '../components/DataTable';
import TimeHierarchyFilter from '../components/TimeHierarchyFilter';
import DimensionFilter from '../components/DimensionFilter';
import PivotControl from '../components/PivotControl';
import { ShoppingCart } from 'lucide-react';
import { api } from '../services/api';

type TimeLevel = 'year' | 'quarter' | 'month';

const OrderCube: React.FC = () => {
  // State for time hierarchy
  const [timeLevel, setTimeLevel] = useState<TimeLevel>('year');
  const [selectedYear, setSelectedYear] = useState<number | undefined>(2024);
  const [selectedQuarter, setSelectedQuarter] = useState<number | undefined>();
  const [selectedMonth, setSelectedMonth] = useState<number | undefined>();
  const [operation, setOperation] = useState<'drill-down' | 'roll-up'>('drill-down');

  // State for dimensions (slice & dice)
  const [selectedDimensions, setSelectedDimensions] = useState<Record<string, string | null>>({});

  // State for pivot
  const [rowDimension, setRowDimension] = useState<string>('CustomerName');
  const [columnDimension, setColumnDimension] = useState<string>('CityName');

  // State for data
  const [data, setData] = useState<any[]>([]);
  const [filteredData, setFilteredData] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  // Fetch data from API
  useEffect(() => {
    const fetchData = async () => {
      try {
        const response = await api.getOrderCube();
        setData(response);
        setLoading(false);
      } catch (err) {
        setError('Failed to fetch order data');
        setLoading(false);
      }
    };

    fetchData();
  }, []);

  // Update filtered data based on selections
  useEffect(() => {
    if (!data.length) return;

    let filtered = [...data];
    
    // Filter by time
    if (selectedYear) {
      filtered = filtered.filter(item => item.Year === selectedYear);
      
      if (selectedQuarter) {
        filtered = filtered.filter(item => item.Quarter === selectedQuarter);
        
        if (selectedMonth) {
          filtered = filtered.filter(item => item.Month === selectedMonth);
        }
      }
    }
    
    // Apply dimension filters (slice & dice)
    Object.entries(selectedDimensions).forEach(([dimension, value]) => {
      if (value) {
        filtered = filtered.filter(item => item[dimension] === value);
      }
    });
    
    setFilteredData(filtered);
  }, [data, selectedYear, selectedQuarter, selectedMonth, selectedDimensions]);

  if (loading) {
    return <div className="flex items-center justify-center h-screen">Loading...</div>;
  }

  if (error) {
    return <div className="text-red-500 text-center p-4">{error}</div>;
  }

  // Handle time level changes for drill-down and roll-up
  const handleTimeLevelChange = (level: TimeLevel) => {
    setTimeLevel(level);
    
    if (operation === 'drill-down') {
      // For drill-down, reset lower levels when changing level
      if (level === 'year') {
        setSelectedQuarter(undefined);
        setSelectedMonth(undefined);
      } else if (level === 'quarter') {
        setSelectedMonth(undefined);
      }
    } else {
      // For roll-up, set all levels up to the selected one
      if (level === 'year') {
        // Already at year level
      } else if (level === 'quarter') {
        if (!selectedQuarter) setSelectedQuarter(1);
      } else if (level === 'month') {
        if (!selectedQuarter) setSelectedQuarter(1);
        if (!selectedMonth) setSelectedMonth(1);
      }
    }
  };

  // Handle dimension filter changes
  const handleDimensionChange = (dimension: string, value: string | null) => {
    setSelectedDimensions(prev => ({
      ...prev,
      [dimension]: value
    }));
  };

  // Get unique values for dimensions
  const getDimensionValues = (dimension: string) => {
    return Array.from(new Set(data.map(item => item[dimension]))).filter(Boolean);
  };

  // Sample dimensions for filtering
  const dimensions = [
    {
      name: 'CustomerName',
      values: getDimensionValues('CustomerName')
    },
    {
      name: 'CityName',
      values: getDimensionValues('CityName')
    }
  ];
  
  // Available years
  const years = Array.from(new Set(data.map(item => item.Year))).sort();

  // Generate columns based on time level and pivot selections
  const getColumns = () => {
    const baseColumns = [
      { key: rowDimension, label: rowDimension },
      { key: columnDimension, label: columnDimension },
      { key: 'TotalAmount', label: 'Total Amount' }
    ];
    
    const timeColumns = [];
    if (timeLevel === 'year' || operation === 'roll-up') {
      timeColumns.push({ key: 'Year', label: 'Year' });
    }
    
    if ((timeLevel === 'quarter' || timeLevel === 'month') && 
        (operation === 'drill-down' || timeLevel !== 'year')) {
      timeColumns.push({ key: 'Quarter', label: 'Quarter' });
    }
    
    if (timeLevel === 'month' && 
        (operation === 'drill-down' || timeLevel === 'month')) {
      timeColumns.push({ key: 'Month', label: 'Month' });
    }
    
    return [...timeColumns, ...baseColumns];
  };

  return (
    <div>
      <div className="flex items-center mb-6">
        <div className="p-2 rounded-md bg-green-100 dark:bg-green-900 mr-3">
          <ShoppingCart className="h-6 w-6 text-green-600 dark:text-green-400" />
        </div>
        <div>
          <h1 className="text-2xl font-bold text-gray-800 dark:text-gray-200">Order Cube</h1>
          <p className="text-gray-600 dark:text-gray-400">
            Analyze orders by customer, location, and time period
          </p>
        </div>
      </div>

      {/* Time Hierarchy Filter (Drill-down / Roll-up) */}
      <TimeHierarchyFilter
        level={timeLevel}
        onLevelChange={handleTimeLevelChange}
        selectedYear={selectedYear}
        selectedQuarter={selectedQuarter}
        selectedMonth={selectedMonth}
        onYearChange={setSelectedYear}
        onQuarterChange={setSelectedQuarter}
        onMonthChange={setSelectedMonth}
        years={years}
        operation={operation}
        onOperationChange={setOperation}
      />

      {/* Dimension Filter (Slice & Dice) */}
      <DimensionFilter
        dimensions={dimensions}
        selectedDimensions={selectedDimensions}
        onDimensionChange={handleDimensionChange}
      />

      {/* Pivot Control */}
      <PivotControl
        dimensions={['CustomerName', 'CityName']}
        rows={rowDimension}
        columns={columnDimension}
        onRowsChange={setRowDimension}
        onColumnsChange={setColumnDimension}
      />

      {/* Data Table */}
      <DataTable
        columns={getColumns()}
        data={filteredData}
        title="Order Analysis"
      />
    </div>
  );
};

export default OrderCube;