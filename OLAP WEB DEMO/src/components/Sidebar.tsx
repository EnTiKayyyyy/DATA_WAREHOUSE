import React from 'react';
import { NavLink } from 'react-router-dom';
import { Database, ShoppingCart, Users, Store, BarChart3, LayoutDashboard } from 'lucide-react';

const Sidebar: React.FC = () => {
  const menuItems = [
    { path: '/', name: 'Dashboard', icon: <LayoutDashboard className="w-5 h-5" /> },
    { path: '/inventory', name: 'Inventory Cube', icon: <Database className="w-5 h-5" /> },
    { path: '/orders', name: 'Order Cube', icon: <ShoppingCart className="w-5 h-5" /> },
    { path: '/order-details', name: 'Order Detail Cube', icon: <BarChart3 className="w-5 h-5" /> },
    // { path: '/customer-types', name: 'Customer Type Cube', icon: <Users className="w-5 h-5" /> },
    // { path: '/store-product-orders', name: 'Store Product Order Cube', icon: <Store className="w-5 h-5" /> },
  ];

  return (
    <aside className="w-64 bg-white dark:bg-gray-800 shadow-md hidden md:block transition-colors duration-200">
      <div className="p-4 border-b border-gray-200 dark:border-gray-700">
        <h1 className="text-xl font-bold text-blue-600 dark:text-blue-400">Data Warehouse</h1>
      </div>
      <nav className="p-2">
        <ul>
          {menuItems.map((item) => (
            <li key={item.path} className="mb-2">
              <NavLink
                to={item.path}
                className={({ isActive }) =>
                  isActive
                    ? 'flex items-center p-3 bg-blue-50 dark:bg-gray-700 text-blue-600 dark:text-blue-400 rounded-lg transition-colors duration-200'
                    : 'flex items-center p-3 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-lg transition-colors duration-200'
                }
              >
                <span className="mr-3">{item.icon}</span>
                <span className="font-medium">{item.name}</span>
              </NavLink>
            </li>
          ))}
        </ul>
      </nav>
    </aside>
  );
};

export default Sidebar;