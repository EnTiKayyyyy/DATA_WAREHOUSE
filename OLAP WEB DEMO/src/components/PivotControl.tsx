import React from 'react';
import { RotateCcw } from 'lucide-react';

type PivotControlProps = {
  dimensions: string[];
  rows: string;
  columns: string;
  onRowsChange: (dimension: string) => void;
  onColumnsChange: (dimension: string) => void;
};

const PivotControl: React.FC<PivotControlProps> = ({
  dimensions,
  rows,
  columns,
  onRowsChange,
  onColumnsChange,
}) => {
  const handleSwap = () => {
    onRowsChange(columns);
    onColumnsChange(rows);
  };

  return (
    <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-4 mb-6 transition-colors duration-200">
      <div className="flex items-center mb-4">
        <RotateCcw className="w-5 h-5 text-purple-500 mr-2" />
        <h3 className="text-lg font-semibold text-gray-800 dark:text-gray-200">Pivot Table</h3>
      </div>
      
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4 items-center">
        <div>
          <label className="block text-sm text-gray-600 dark:text-gray-400 mb-1">
            Rows
          </label>
          <select
            value={rows}
            onChange={(e) => onRowsChange(e.target.value)}
            className="w-full bg-gray-50 dark:bg-gray-700 border border-gray-300 dark:border-gray-600 text-gray-800 dark:text-gray-200 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
          >
            {dimensions.map((dimension) => (
              <option key={dimension} value={dimension}>
                {dimension}
              </option>
            ))}
          </select>
        </div>
        
        <div className="flex justify-center">
          <button
            onClick={handleSwap}
            className="p-2 rounded-full bg-purple-100 dark:bg-purple-900 text-purple-600 dark:text-purple-300 hover:bg-purple-200 dark:hover:bg-purple-800 transition-colors duration-200"
            aria-label="Swap dimensions"
          >
            <RotateCcw className="w-5 h-5" />
          </button>
        </div>
        
        <div>
          <label className="block text-sm text-gray-600 dark:text-gray-400 mb-1">
            Columns
          </label>
          <select
            value={columns}
            onChange={(e) => onColumnsChange(e.target.value)}
            className="w-full bg-gray-50 dark:bg-gray-700 border border-gray-300 dark:border-gray-600 text-gray-800 dark:text-gray-200 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
          >
            {dimensions.map((dimension) => (
              <option key={dimension} value={dimension}>
                {dimension}
              </option>
            ))}
          </select>
        </div>
      </div>
    </div>
  );
};

export default PivotControl;