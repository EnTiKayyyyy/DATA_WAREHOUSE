import React, { useState, useEffect } from 'react';
import DataTable from '../components/DataTable';
import TimeHierarchyFilter from '../components/TimeHierarchyFilter';
import StoreHierarchyFilter from '../components/StoreHierarchyFilter';
import DimensionFilter from '../components/DimensionFilter';
import PivotControl from '../components/PivotControl';
import { Database } from 'lucide-react';
import { api } from '../services/api';

type TimeLevel = 'year' | 'quarter' | 'month';
type StoreLevel = 'state' | 'city' | 'store';

const InventoryCube: React.FC = () => {
  // State for time hierarchy
  const [timeLevel, setTimeLevel] = useState<TimeLevel>('year');
  const [selectedYear, setSelectedYear] = useState<number | undefined>(2024);
  const [selectedQuarter, setSelectedQuarter] = useState<number | undefined>();
  const [selectedMonth, setSelectedMonth] = useState<number | undefined>();
  const [timeOperation, setTimeOperation] = useState<'drill-down' | 'roll-up'>('drill-down');

  // State for store hierarchy
  const [storeLevel, setStoreLevel] = useState<StoreLevel>('state');
  const [selectedState, setSelectedState] = useState<string>();
  const [selectedCity, setSelectedCity] = useState<string>();
  const [selectedStore, setSelectedStore] = useState<string>();
  const [storeOperation, setStoreOperation] = useState<'drill-down' | 'roll-up'>('drill-down');

  // State for dimensions (slice & dice)
  const [selectedDimensions, setSelectedDimensions] = useState<Record<string, string | null>>({});

  // State for pivot
  const [rowDimension, setRowDimension] = useState<string>('CityName');
  const [columnDimension, setColumnDimension] = useState<string>('ProductDescription');

  // State for data
  const [data, setData] = useState<any[]>([]);
  const [filteredData, setFilteredData] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  // Fetch data from API
  useEffect(() => {
    const fetchData = async () => {
      try {
        const response = await api.getInventoryCube();
        setData(response);
        setLoading(false);
      } catch (err) {
        setError('Failed to fetch inventory data');
        setLoading(false);
      }
    };

    fetchData();
  }, []);

  // Get unique values for store hierarchy
  const states = Array.from(new Set(data.map(item => item.State))).sort();
  const cities = Array.from(new Set(data
    .filter(item => !selectedState || item.State === selectedState)
    .map(item => item.CityName)
  )).sort();
  const stores = Array.from(new Set(data
    .filter(item => 
      (!selectedState || item.State === selectedState) &&
      (!selectedCity || item.CityName === selectedCity)
    )
    .map(item => item.StoreID)
  )).sort();

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

    // Filter by store hierarchy
    if (selectedState) {
      filtered = filtered.filter(item => item.State === selectedState);
      
      if (selectedCity) {
        filtered = filtered.filter(item => item.CityName === selectedCity);
        
        if (selectedStore) {
          filtered = filtered.filter(item => item.StoreID === selectedStore);
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
  }, [
    data,
    selectedYear,
    selectedQuarter,
    selectedMonth,
    selectedState,
    selectedCity,
    selectedStore,
    selectedDimensions
  ]);

  if (loading) {
    return <div className="flex items-center justify-center h-screen">Loading...</div>;
  }

  if (error) {
    return <div className="text-red-500 text-center p-4">{error}</div>;
  }

  // Handle time level changes
  const handleTimeLevelChange = (level: TimeLevel) => {
    setTimeLevel(level);
    
    if (timeOperation === 'drill-down') {
      if (level === 'year') {
        setSelectedQuarter(undefined);
        setSelectedMonth(undefined);
      } else if (level === 'quarter') {
        setSelectedMonth(undefined);
      }
    } else {
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

  // Handle store level changes
  const handleStoreLevelChange = (level: StoreLevel) => {
    setStoreLevel(level);
    
    if (storeOperation === 'drill-down') {
      if (level === 'state') {
        setSelectedCity(undefined);
        setSelectedStore(undefined);
      } else if (level === 'city') {
        setSelectedStore(undefined);
      }
    } else {
      if (level === 'state') {
        // Already at state level
      } else if (level === 'city') {
        if (!selectedCity && cities.length > 0) setSelectedCity(cities[0]);
      } else if (level === 'store') {
        if (!selectedCity && cities.length > 0) setSelectedCity(cities[0]);
        if (!selectedStore && stores.length > 0) setSelectedStore(stores[0]);
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
      name: 'CityName',
      values: getDimensionValues('CityName')
    },
    {
      name: 'ProductDescription',
      values: getDimensionValues('ProductDescription')
    }
  ];
  
  // Available years
  const years = Array.from(new Set(data.map(item => item.Year))).sort();

  // Generate columns based on time level and pivot selections
  const getColumns = () => {
    const baseColumns = [
      { key: rowDimension, label: rowDimension },
      { key: columnDimension, label: columnDimension },
      { key: 'TotalStock', label: 'Total Stock' }
    ];
    
    const timeColumns = [];
    if (timeLevel === 'year' || timeOperation === 'roll-up') {
      timeColumns.push({ key: 'Year', label: 'Year' });
    }
    
    if ((timeLevel === 'quarter' || timeLevel === 'month') && 
        (timeOperation === 'drill-down' || timeLevel !== 'year')) {
      timeColumns.push({ key: 'Quarter', label: 'Quarter' });
    }
    
    if (timeLevel === 'month' && 
        (timeOperation === 'drill-down' || timeLevel === 'month')) {
      timeColumns.push({ key: 'Month', label: 'Month' });
    }

    // Add store hierarchy columns
    const storeColumns = [];
    if (storeLevel === 'state' || storeOperation === 'roll-up') {
      storeColumns.push({ key: 'State', label: 'State' });
    }
    
    if ((storeLevel === 'city' || storeLevel === 'store') && 
        (storeOperation === 'drill-down' || storeLevel !== 'state')) {
      storeColumns.push({ key: 'CityName', label: 'City' });
    }
    
    if (storeLevel === 'store' && 
        (storeOperation === 'drill-down' || storeLevel === 'store')) {
      storeColumns.push({ key: 'StoreID', label: 'Store ID' });
    }
    
    return [...timeColumns, ...storeColumns, ...baseColumns];
  };

  return (
    <div>
      <div className="flex items-center mb-6">
        <div className="p-2 rounded-md bg-blue-100 dark:bg-blue-900 mr-3">
          <Database className="h-6 w-6 text-blue-600 dark:text-blue-400" />
        </div>
        <div>
          <h1 className="text-2xl font-bold text-gray-800 dark:text-gray-200">Inventory Cube</h1>
          <p className="text-gray-600 dark:text-gray-400">
            Analyze inventory data across locations, products, and time periods
          </p>
        </div>
      </div>

      {/* Time Hierarchy Filter */}
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
        operation={timeOperation}
        onOperationChange={setTimeOperation}
      />

      {/* Store Hierarchy Filter */}
      <StoreHierarchyFilter
        level={storeLevel}
        onLevelChange={handleStoreLevelChange}
        states={states}
        cities={cities}
        stores={stores}
        selectedState={selectedState}
        selectedCity={selectedCity}
        selectedStore={selectedStore}
        onStateChange={setSelectedState}
        onCityChange={setSelectedCity}
        onStoreChange={setSelectedStore}
        operation={storeOperation}
        onOperationChange={setStoreOperation}
      />

      {/* Dimension Filter (Slice & Dice) */}
      <DimensionFilter
        dimensions={dimensions}
        selectedDimensions={selectedDimensions}
        onDimensionChange={handleDimensionChange}
      />

      {/* Pivot Control */}
      <PivotControl
        dimensions={['State', 'CityName', 'StoreID', 'ProductDescription']}
        rows={rowDimension}
        columns={columnDimension}
        onRowsChange={setRowDimension}
        onColumnsChange={setColumnDimension}
      />

      {/* Data Table */}
      <DataTable
        columns={getColumns()}
        data={filteredData}
        title="Inventory Analysis"
      />
    </div>
  );
};

export default InventoryCube;