import express from 'express';
import mysql from 'mysql2/promise';
import cors from 'cors';
import dotenv from 'dotenv';

dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());

// Create MySQL connection pool
const pool = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_DATABASE,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

// Inventory Cube endpoints
app.get('/api/inventory', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM InventoryCube');
    res.json(rows);
  } catch (error) {
    console.error('Error fetching inventory data:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Order Cube endpoints
app.get('/api/orders', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM OrderCube');
    res.json(rows);
  } catch (error) {
    console.error('Error fetching order data:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Order Detail Cube endpoints
app.get('/api/order-details', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM OrderDetailCube');
    res.json(rows);
  } catch (error) {
    console.error('Error fetching order detail data:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Customer Type Cube endpoints
app.get('/api/customer-types', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM CustomerTypeCube');
    res.json(rows);
  } catch (error) {
    console.error('Error fetching customer type data:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Store Product Order Cube endpoints
app.get('/api/store-product-orders', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM StoreProductOrderCube');
    res.json(rows);
  } catch (error) {
    console.error('Error fetching store product order data:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});