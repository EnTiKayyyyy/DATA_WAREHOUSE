import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Sidebar from './components/Sidebar';
import Dashboard from './pages/Dashboard';
import InventoryCube from './pages/InventoryCube';
import OrderCube from './pages/OrderCube';
import OrderDetailCube from './pages/OrderDetailCube';
import CustomerTypeCube from './pages/CustomerTypeCube';
import StoreProductOrderCube from './pages/StoreProductOrderCube';
import { ThemeProvider } from './context/ThemeContext';
import Header from './components/Header';

function App() {
  return (
    <ThemeProvider>
      <Router>
        <div className="flex h-screen bg-gray-100 dark:bg-gray-900 text-gray-800 dark:text-gray-200 transition-colors duration-200">
          <Sidebar />
          <div className="flex flex-col flex-1 overflow-hidden">
            <Header />
            <main className="flex-1 overflow-y-auto p-4 md:p-6">
              <Routes>
                <Route path="/" element={<Dashboard />} />
                <Route path="/inventory" element={<InventoryCube />} />
                <Route path="/orders" element={<OrderCube />} />
                <Route path="/order-details" element={<OrderDetailCube />} />
                <Route path="/customer-types" element={<CustomerTypeCube />} />
                <Route path="/store-product-orders" element={<StoreProductOrderCube />} />
              </Routes>
            </main>
          </div>
        </div>
      </Router>
    </ThemeProvider>
  );
}

export default App;