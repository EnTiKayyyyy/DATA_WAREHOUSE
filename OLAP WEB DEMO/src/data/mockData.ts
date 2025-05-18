// Generate realistic sample data for demonstration
const generateMockData = () => {
  // Time periods
  const years = [2022, 2023, 2024];
  const quarters = [1, 2, 3, 4];
  const months = Array.from({ length: 12 }, (_, i) => i + 1);
  
  // Dimensions
  const cities = ['Hanoi', 'Ho Chi Minh', 'Da Nang'];
  const products = ['Laptop', 'Smartphone', 'Tablet', 'Camera'];
  const warehouses = ['Main Warehouse', 'East Warehouse', 'West Warehouse'];
  const customerTypes = ['Individual', 'Corporate', 'Reseller'];
  const customerTiers = ['Standard', 'Premium', 'VIP'];
  const paymentMethods = ['Credit Card', 'Bank Transfer', 'Cash'];
  const productCategories = ['Electronics', 'Accessories', 'Peripherals'];
  const stores = ['Main Store', 'Downtown Branch', 'Mall Location'];
  
  // Helper function to get random int between min and max (inclusive)
  const randomInt = (min: number, max: number): number => {
    return Math.floor(Math.random() * (max - min + 1)) + min;
  };
  
  // Helper function to get random float between min and max with precision
  const randomFloat = (min: number, max: number, precision: number = 2): number => {
    const value = Math.random() * (max - min) + min;
    return parseFloat(value.toFixed(precision));
  };
  
  // Generate inventory cube data
  const inventoryCube = [];
  for (const year of years) {
    for (const quarter of quarters) {
      for (const month of months.filter(m => Math.ceil(m / 3) === quarter)) {
        for (const city of cities) {
          for (const product of products) {
            for (const warehouse of warehouses) {
              inventoryCube.push({
                Year: year,
                Quarter: quarter,
                Month: month,
                CityName: city,
                ProductName: product,
                WarehouseName: warehouse,
                QuantityInStock: randomInt(100, 1000),
                AvgPrice: randomFloat(500, 2000)
              });
            }
          }
        }
      }
    }
  }
  
  // Generate order cube data
  const orderCube = [];
  for (const year of years) {
    for (const quarter of quarters) {
      for (const month of months.filter(m => Math.ceil(m / 3) === quarter)) {
        for (const city of cities) {
          for (const customerType of customerTypes) {
            for (const paymentMethod of paymentMethods) {
              // Calculate some realistic metrics
              const orderCount = randomInt(5, 100);
              const totalAmount = randomFloat(1000, 50000);
              
              orderCube.push({
                Year: year,
                Quarter: quarter,
                Month: month,
                CityName: city,
                CustomerType: customerType,
                PaymentMethod: paymentMethod,
                OrderCount: orderCount,
                TotalAmount: totalAmount,
                AvgOrderValue: parseFloat((totalAmount / orderCount).toFixed(2))
              });
            }
          }
        }
      }
    }
  }
  
  // Generate order detail cube data
  const orderDetailCube = [];
  for (const year of years) {
    for (const quarter of quarters) {
      for (const month of months.filter(m => Math.ceil(m / 3) === quarter)) {
        for (const product of products) {
          for (const customerType of customerTypes) {
            for (const productCategory of productCategories) {
              // Calculate some realistic metrics
              const quantity = randomInt(10, 200);
              const unitPrice = randomFloat(200, 1000);
              const discount = randomFloat(0, 0.2);
              const totalValue = parseFloat((quantity * unitPrice * (1 - discount)).toFixed(2));
              
              orderDetailCube.push({
                Year: year,
                Quarter: quarter,
                Month: month,
                ProductName: product,
                CustomerType: customerType,
                ProductCategory: productCategory,
                Quantity: quantity,
                UnitPrice: unitPrice,
                Discount: discount,
                TotalValue: totalValue
              });
            }
          }
        }
      }
    }
  }
  
  // Generate customer type cube data
  const customerTypeCube = [];
  for (const year of years) {
    for (const quarter of quarters) {
      for (const month of months.filter(m => Math.ceil(m / 3) === quarter)) {
        for (const customerType of customerTypes) {
          for (const city of cities) {
            for (const customerTier of customerTiers) {
              // Calculate some realistic metrics
              const customerCount = randomInt(5, 100);
              const totalSpent = randomFloat(1000, 100000);
              
              customerTypeCube.push({
                Year: year,
                Quarter: quarter,
                Month: month,
                CustomerType: customerType,
                CityName: city,
                CustomerTier: customerTier,
                CustomerCount: customerCount,
                TotalSpent: totalSpent,
                AvgSpentPerCustomer: parseFloat((totalSpent / customerCount).toFixed(2))
              });
            }
          }
        }
      }
    }
  }
  
  // Generate store product order cube data
  const storeProductOrderCube = [];
  for (const year of years) {
    for (const quarter of quarters) {
      for (const month of months.filter(m => Math.ceil(m / 3) === quarter)) {
        for (const store of stores) {
          for (const product of products) {
            for (const city of cities) {
              // Calculate some realistic metrics
              const salesQuantity = randomInt(10, 500);
              const unitPrice = randomFloat(200, 1000);
              const unitCost = unitPrice * randomFloat(0.5, 0.8);
              const revenue = parseFloat((salesQuantity * unitPrice).toFixed(2));
              const cost = parseFloat((salesQuantity * unitCost).toFixed(2));
              
              storeProductOrderCube.push({
                Year: year,
                Quarter: quarter,
                Month: month,
                StoreName: store,
                ProductName: product,
                CityName: city,
                SalesQuantity: salesQuantity,
                Revenue: revenue,
                Cost: cost,
                Profit: parseFloat((revenue - cost).toFixed(2))
              });
            }
          }
        }
      }
    }
  }
  
  // Return a small subset of data for better performance when developing
  const getSubset = (data: any[], factor: number = 0.2) => {
    const size = Math.max(20, Math.floor(data.length * factor));
    const shuffled = [...data].sort(() => 0.5 - Math.random());
    return shuffled.slice(0, size);
  };
  
  return {
    inventoryCube: getSubset(inventoryCube),
    orderCube: getSubset(orderCube),
    orderDetailCube: getSubset(orderDetailCube),
    customerTypeCube: getSubset(customerTypeCube),
    storeProductOrderCube: getSubset(storeProductOrderCube)
  };
};

export const MockData = generateMockData();