import axios from 'axios';

const API_URL = import.meta.env.VITE_API_URL;

export const api = {
  getInventoryCube: async () => {
    const response = await axios.get(`${API_URL}/api/inventory`);
    return response.data;
  },

  getOrderCube: async () => {
    const response = await axios.get(`${API_URL}/api/orders`);
    return response.data;
  },

  getOrderDetailCube: async () => {
    const response = await axios.get(`${API_URL}/api/order-details`);
    return response.data;
  },

  getCustomerTypeCube: async () => {
    const response = await axios.get(`${API_URL}/api/customer-types`);
    return response.data;
  },

  getStoreProductOrderCube: async () => {
    const response = await axios.get(`${API_URL}/api/store-product-orders`);
    return response.data;
  }
};