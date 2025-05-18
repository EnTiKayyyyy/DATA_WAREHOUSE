import React from 'react';
import { Filter } from 'lucide-react';

type DimensionFilterProps = {
  dimensions: {
    name: string;
    values: string[];
  }[];
  selectedDimensions: Record<string, string | null>;
  onDimensionChange: (dimension: string, value: string | null) => void;
  title?: string;
};

const DimensionFilter: React.FC<DimensionFilterProps> = ({
  dimensions,
  selectedDimensions,
  onDimensionChange,
  title = 'Slice & Dice',
}) => {
  return (
    <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-4 mb-6 transition-colors duration-200">
      <div className="flex items-center mb-4">
        <Filter className="w-5 h-5 text-blue-500 mr-2" />
        <h3 className="text-lg font-semibold text-gray-800 dark:text-gray-200">{title}</h3>
      </div>
      
      <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-4">
        {dimensions.map((dimension) => (
          <div key={dimension.name}>
            <label className="block text-sm text-gray-600 dark:text-gray-400 mb-1">
              {dimension.name}
            </label>
            <select
              value={selectedDimensions[dimension.name] || ''}
              onChange={(e) => 
                onDimensionChange(
                  dimension.name, 
                  e.target.value === '' ? null : e.target.value
                )
              }
              className="w-full bg-gray-50 dark:bg-gray-700 border border-gray-300 dark:border-gray-600 text-gray-800 dark:text-gray-200 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
            >
              <option value="">All {dimension.name}s</option>
              {dimension.values.map((value) => (
                <option key={value} value={value}>
                  {value}
                </option>
              ))}
            </select>
          </div>
        ))}
      </div>
    </div>
  );
};

export default DimensionFilter;