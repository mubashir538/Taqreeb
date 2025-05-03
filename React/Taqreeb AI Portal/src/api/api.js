// src/api/apiService.js
import axios from 'axios';

const BASE_URL = 'http://127.0.0.1:8000/app/api/react/';

class ApiService {
  constructor() {
    this.api = axios.create({
      baseURL: BASE_URL,
    });

    const accessToken = localStorage.getItem('access');
    const refreshToken = localStorage.getItem('refresh');
    this.setAuthTokens(accessToken, refreshToken);
    }  

  setAuthTokens(accessToken, refreshToken) {
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;

    // Set the Authorization header if we have an access token
    if (accessToken) {
      this.api.defaults.headers.common['Authorization'] = `Bearer ${accessToken}`;
    } else {
      delete this.api.defaults.headers.common['Authorization'];
    }
  }

  async get(endpoint, params = {}) {
    try {
      const response = await this.api.get(endpoint, { params });
      return response.data;
    } catch (error) {
      this.handleError(error);
      throw error;
    }
  }

  async post(endpoint, data = {}) {
    try {
      const response = await this.api.post(endpoint, data);
      return response.data;
    } catch (error) {
      this.handleError(error);
      throw error;
    }
  }

  handleError(error) {
    if (error.response) {
      // The request was made and the server responded with a status code
      console.error('API Error:', error.response.status, error.response.data);
    } else if (error.request) {
      // The request was made but no response was received
      console.error('API Error: No response received', error.request);
    } else {
      // Something happened in setting up the request
      console.error('API Error:', error.message);
    }
  }

  // Specific API methods
  async login(email, password) {
    const response = await this.post('login/', { email, password });
    
    if (response.status === 'success') {
      this.setAuthTokens(response.access, response.refresh);
      return response;
    }
    
    throw new Error(response.message || 'Login failed');
  }

}

// Create a singleton instance of the ApiService
const apiService = new ApiService();
export default apiService;