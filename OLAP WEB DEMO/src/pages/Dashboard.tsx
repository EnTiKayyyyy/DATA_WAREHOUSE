import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { 
  Card,
  Title,
  Text,
  Tab,
  TabList,
  TabGroup,
  TabPanel,
  TabPanels,
  BarChart,
  DonutChart,
  LineChart
} from '@tremor/react';
import { Database, ShoppingCart, Users, Store, BarChart3, LayoutDashboard } from 'lucide-react';
import { api } from '../services/api';

const DashboardMetric: React.FC<{
  title: string;
  value: string;
  description: string;
  icon: React.ReactNode;
  color: string;
}> = ({ title, value, description, icon, color }) => (
  <Card className="relative overflow-hidden">
    <div className="flex items-center gap-4">
      <div className={`p-2 rounded-lg ${color}`}>
        {icon}
      </div>
      <div>
        <Text>{title}</Text>
        <Title className="text-2xl font-bold">{value}</Title>
        <Text className="text-gray-500">{description}</Text>
      </div>
    </div>
  </Card>
);

const Dashboard: React.FC = () => {
  const [inventoryData, setInventoryData] = useState<any[]>([]);
  const [orderData, setOrderData] = useState<any[]>([]);
  const [orderDetailData, setOrderDetailData] = useState<any[]>([]);
  const [customerData, setCustomerData] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const [inventory, orders, orderDetails] = await Promise.all([
          api.getInventoryCube(),
          api.getOrderCube(),
          api.getOrderDetailCube(),
        ]);

        setInventoryData(inventory);
        setOrderData(orders);
        setOrderDetailData(orderDetails);
        setLoading(false);
      } catch (err) {
        setError('Failed to fetch dashboard data');
        setLoading(false);
      }
    };

    fetchData();
  }, []);

  if (loading) {
    return <div className="flex items-center justify-center h-screen">Loading...</div>;
  }

  if (error) {
    return <div className="text-red-500 text-center p-4">{error}</div>;
  }

  // Calculate metrics from real data
  const totalInventory = inventoryData.reduce((sum, item) => sum + item.TotalStock, 0);
  const totalOrders = orderData.reduce((sum, item) => sum + (item.OrderCount || 1), 0);
  const totalRevenue = orderDetailData.reduce((sum, item) => sum + item.TotalRevenue, 0);
  const totalCustomers = customerData.reduce((sum, item) => sum + item.CustomerCount, 0);

  // Prepare chart data
  const inventoryByCity = inventoryData.reduce((acc, item) => {
    if (!acc[item.CityName]) acc[item.CityName] = 0;
    acc[item.CityName] += item.TotalStock;
    return acc;
  }, {} as Record<string, number>);

  const inventoryChartData = Object.entries(inventoryByCity).map(([city, stock]) => ({
    name: city,
    "Stock Level": stock
  }));

  const ordersByType = orderData.reduce((acc, item) => {
    const type = item.CustomerType || 'Unknown';
    if (!acc[type]) acc[type] = 0;
    acc[type] += item.OrderCount || 1;
    return acc;
  }, {} as Record<string, number>);

  const orderChartData = Object.entries(ordersByType).map(([type, count]) => ({
    name: type,
    value: count
  }));

  const revenueByMonth = orderDetailData.reduce((acc, item) => {
    const monthKey = `${item.Year}-${item.Month.toString().padStart(2, '0')}`;
    if (!acc[monthKey]) acc[monthKey] = 0;
    acc[monthKey] += item.TotalRevenue;
    return acc;
  }, {} as Record<string, number>);

  const revenueChartData = Object.entries(revenueByMonth)
    .sort((a, b) => a[0].localeCompare(b[0]))
    .map(([month, revenue]) => ({
      date: month,
      "Revenue": revenue
    }));

  return (
    <div className="p-4 space-y-6">
      <div className="mb-8">
        <h1 className="text-2xl font-bold text-gray-800 dark:text-gray-200 mb-2">Data Warehouse Analytics</h1>
        <p className="text-gray-600 dark:text-gray-400">
          Comprehensive overview of inventory, orders, customers, and revenue
        </p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-6">
        <DashboardMetric
          title="Total Inventory"
          value={totalInventory.toLocaleString()}
          description="Items in stock"
          icon={<Database className="w-6 h-6 text-blue-600" />}
          color="bg-blue-100"
        />
        <DashboardMetric
          title="Total Orders"
          value={totalOrders.toLocaleString()}
          description="Processed orders"
          icon={<ShoppingCart className="w-6 h-6 text-green-600" />}
          color="bg-green-100"
        />
        {/* <DashboardMetric
          title="Total Revenue"
          value={`$${totalRevenue.toLocaleString()}`}
          description="Generated revenue"
          icon={<BarChart3 className="w-6 h-6 text-purple-600" />}
          color="bg-purple-100"
        />
        <DashboardMetric
          title="Total Customers"
          value={totalCustomers.toLocaleString()}
          description="Active customers"
          icon={<Users className="w-6 h-6 text-yellow-600" />}
          color="bg-yellow-100"
        /> */}
      </div>

      <TabGroup>
        <TabList className="mb-6">
          <Tab>Overview</Tab>
          <Tab>Inventory</Tab>
          <Tab>Orders</Tab>
          <Tab>Revenue</Tab>
        </TabList>
        
        <TabPanels>
          <TabPanel>
            <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
              <Card>
                <Title>Inventory by City</Title>
                <BarChart
                  data={inventoryChartData}
                  index="name"
                  categories={["Stock Level"]}
                  colors={["blue"]}
                  className="h-72"
                />
              </Card>
              
              {/* <Card>
                <Title>Orders by Customer Type</Title>
                <DonutChart
                  data={orderChartData}
                  category="value"
                  index="name"
                  colors={["emerald", "violet", "indigo"]}
                  className="h-72"
                />
              </Card> */}
            </div>
          </TabPanel>
          
          <TabPanel>
            <Card>
              <Title>Inventory Distribution</Title>
              <BarChart
                data={inventoryChartData}
                index="name"
                categories={["Stock Level"]}
                colors={["blue"]}
                className="h-96"
              />
            </Card>
          </TabPanel>
          
          <TabPanel>
            <Card>
              <Title>Customer Order Distribution</Title>
              <DonutChart
                data={orderChartData}
                category="value"
                index="name"
                colors={["emerald", "violet", "indigo"]}
                className="h-96"
              />
            </Card>
          </TabPanel>
          
          <TabPanel>
            <Card>
              <Title>Revenue Trend</Title>
              <LineChart
                data={revenueChartData}
                index="date"
                categories={["Revenue"]}
                colors={["purple"]}
                className="h-96"
              />
            </Card>
          </TabPanel>
        </TabPanels>
      </TabGroup>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mt-6">
        <Link
          to="/inventory"
          className="bg-white dark:bg-gray-800 p-6 rounded-lg shadow-md hover:shadow-lg transition-shadow"
        >
          <div className="flex items-center gap-4">
            <Database className="w-8 h-8 text-blue-600" />
            <div>
              <h3 className="text-lg font-semibold">Inventory Analysis</h3>
              <p className="text-gray-600 dark:text-gray-400">Detailed inventory metrics and trends</p>
            </div>
          </div>
        </Link>

        <Link
          to="/orders"
          className="bg-white dark:bg-gray-800 p-6 rounded-lg shadow-md hover:shadow-lg transition-shadow"
        >
          <div className="flex items-center gap-4">
            <ShoppingCart className="w-8 h-8 text-green-600" />
            <div>
              <h3 className="text-lg font-semibold">Order Analytics</h3>
              <p className="text-gray-600 dark:text-gray-400">Order patterns and customer insights</p>
            </div>
          </div>
        </Link>

        <Link
          to="/order-details"
          className="bg-white dark:bg-gray-800 p-6 rounded-lg shadow-md hover:shadow-lg transition-shadow"
        >
          <div className="flex items-center gap-4">
            <Users className="w-8 h-8 text-yellow-600" />
            <div>
              <h3 className="text-lg font-semibold">Order Details</h3>
              <p className="text-gray-600 dark:text-gray-400">Order Details</p>
            </div>
          </div>
        </Link>
      </div>
    </div>
  );
};

export default Dashboard;