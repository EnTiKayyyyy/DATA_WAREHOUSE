import React from 'react';
import { ChevronRight } from 'lucide-react';

type TimeLevel = 'year' | 'quarter' | 'month';
type StoreLevel = 'state' | 'city' | 'store';

type TimeHierarchyFilterProps = {
  level: TimeLevel;
  onLevelChange: (level: TimeLevel) => void;
  selectedYear?: number;
  selectedQuarter?: number;
  selectedMonth?: number;
  onYearChange: (year: number) => void;
  onQuarterChange: (quarter: number) => void;
  onMonthChange: (month: number) => void;
  years: number[];
  operation: 'drill-down' | 'roll-up';
  onOperationChange: (operation: 'drill-down' | 'roll-up') => void;
  // New store hierarchy props
  storeLevel?: StoreLevel;
  onStoreLevelChange?: (level: StoreLevel) => void;
  states?: string[];
  cities?: string[];
  stores?: string[];
  selectedState?: string;
  selectedCity?: string;
  selectedStore?: string;
  onStateChange?: (state: string) => void;
  onCityChange?: (city: string) => void;
  onStoreChange?: (store: string) => void;
  showStoreHierarchy?: boolean;
};

const TimeHierarchyFilter: React.FC<TimeHierarchyFilterProps> = ({
  level,
  onLevelChange,
  selectedYear,
  selectedQuarter,
  selectedMonth,
  onYearChange,
  onQuarterChange,
  onMonthChange,
  years,
  operation,
  onOperationChange,
  // Store hierarchy props
  storeLevel,
  onStoreLevelChange,
  states = [],
  cities = [],
  stores = [],
  selectedState,
  selectedCity,
  selectedStore,
  onStateChange,
  onCityChange,
  onStoreChange,
  showStoreHierarchy = false,
}) => {
  // Get month name
  const getMonthName = (month: number) => {
    return new Date(2000, month - 1, 1).toLocaleString('default', { month: 'long' });
  };

  // Get quarter label
  const getQuarterLabel = (quarter: number) => {
    return `Q${quarter}`;
  };

  return (
    <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-4 mb-6 transition-colors duration-200">
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between mb-4">
        <h3 className="text-lg font-semibold text-gray-800 dark:text-gray-200 mb-2 sm:mb-0">Time Hierarchy</h3>
        
        <div className="flex space-x-4">
          <div className="flex items-center">
            <label className="mr-2 text-sm text-gray-600 dark:text-gray-400">Operation:</label>
            <select
              value={operation}
              onChange={(e) => onOperationChange(e.target.value as 'drill-down' | 'roll-up')}
              className="bg-gray-50 dark:bg-gray-700 border border-gray-300 dark:border-gray-600 text-gray-800 dark:text-gray-200 rounded-md px-3 py-1 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
            >
              <option value="drill-down">Drill Down</option>
              <option value="roll-up">Roll Up</option>
            </select>
          </div>
          
          <div className="flex items-center">
            <label className="mr-2 text-sm text-gray-600 dark:text-gray-400">Level:</label>
            <select
              value={level}
              onChange={(e) => onLevelChange(e.target.value as TimeLevel)}
              className="bg-gray-50 dark:bg-gray-700 border border-gray-300 dark:border-gray-600 text-gray-800 dark:text-gray-200 rounded-md px-3 py-1 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
            >
              <option value="year">Year</option>
              <option value="quarter">Quarter</option>
              <option value="month">Month</option>
            </select>
          </div>
        </div>
      </div>
      
      <div className="flex flex-wrap items-center gap-4">
        <div>
          <label className="block text-sm text-gray-600 dark:text-gray-400 mb-1">Year</label>
          <select
            value={selectedYear}
            onChange={(e) => onYearChange(Number(e.target.value))}
            className="bg-gray-50 dark:bg-gray-700 border border-gray-300 dark:border-gray-600 text-gray-800 dark:text-gray-200 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
          >
            <option value="">Select Year</option>
            {years.map((year) => (
              <option key={year} value={year}>
                {year}
              </option>
            ))}
          </select>
        </div>
        
        {level !== 'year' && selectedYear && (
          <>
            <ChevronRight className="w-5 h-5 text-gray-400" />
            <div>
              <label className="block text-sm text-gray-600 dark:text-gray-400 mb-1">Quarter</label>
              <select
                value={selectedQuarter || ''}
                onChange={(e) => onQuarterChange(Number(e.target.value))}
                className="bg-gray-50 dark:bg-gray-700 border border-gray-300 dark:border-gray-600 text-gray-800 dark:text-gray-200 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
              >
                <option value="">Select Quarter</option>
                {[1, 2, 3, 4].map((quarter) => (
                  <option key={quarter} value={quarter}>
                    {getQuarterLabel(quarter)}
                  </option>
                ))}
              </select>
            </div>
          </>
        )}
        
        {level === 'month' && selectedYear && selectedQuarter && (
          <>
            <ChevronRight className="w-5 h-5 text-gray-400" />
            <div>
              <label className="block text-sm text-gray-600 dark:text-gray-400 mb-1">Month</label>
              <select
                value={selectedMonth || ''}
                onChange={(e) => onMonthChange(Number(e.target.value))}
                className="bg-gray-50 dark:bg-gray-700 border border-gray-300 dark:border-gray-600 text-gray-800 dark:text-gray-200 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
              >
                <option value="">Select Month</option>
                {Array.from({ length: 12 }, (_, i) => i + 1)
                  .filter((month) => Math.ceil(month / 3) === selectedQuarter)
                  .map((month) => (
                    <option key={month} value={month}>
                      {getMonthName(month)}
                    </option>
                  ))}
              </select>
            </div>
          </>
        )}
      </div>

      {showStoreHierarchy && (
        <div className="mt-6">
          <h3 className="text-lg font-semibold text-gray-800 dark:text-gray-200 mb-4">Store Hierarchy</h3>
          <div className="flex flex-wrap items-center gap-4">
            <div>
              <label className="block text-sm text-gray-600 dark:text-gray-400 mb-1">State</label>
              <select
                value={selectedState || ''}
                onChange={(e) => onStateChange?.(e.target.value)}
                className="bg-gray-50 dark:bg-gray-700 border border-gray-300 dark:border-gray-600 text-gray-800 dark:text-gray-200 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
              >
                <option value="">Select State</option>
                {states.map((state) => (
                  <option key={state} value={state}>
                    {state}
                  </option>
                ))}
              </select>
            </div>

            {selectedState && (
              <>
                <ChevronRight className="w-5 h-5 text-gray-400" />
                <div>
                  <label className="block text-sm text-gray-600 dark:text-gray-400 mb-1">City</label>
                  <select
                    value={selectedCity || ''}
                    onChange={(e) => onCityChange?.(e.target.value)}
                    className="bg-gray-50 dark:bg-gray-700 border border-gray-300 dark:border-gray-600 text-gray-800 dark:text-gray-200 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
                  >
                    <option value="">Select City</option>
                    {cities.map((city) => (
                      <option key={city} value={city}>
                        {city}
                      </option>
                    ))}
                  </select>
                </div>
              </>
            )}

            {selectedCity && (
              <>
                <ChevronRight className="w-5 h-5 text-gray-400" />
                <div>
                  <label className="block text-sm text-gray-600 dark:text-gray-400 mb-1">Store</label>
                  <select
                    value={selectedStore || ''}
                    onChange={(e) => onStoreChange?.(e.target.value)}
                    className="bg-gray-50 dark:bg-gray-700 border border-gray-300 dark:border-gray-600 text-gray-800 dark:text-gray-200 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
                  >
                    <option value="">Select Store</option>
                    {stores.map((store) => (
                      <option key={store} value={store}>
                        Store {store}
                      </option>
                    ))}
                  </select>
                </div>
              </>
            )}
          </div>
        </div>
      )}
    </div>
  );
};

export default TimeHierarchyFilter;