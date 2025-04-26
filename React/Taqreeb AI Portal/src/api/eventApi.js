import axios from 'axios';

const BASE_URL = 'http://127.0.0.1:8000/app';

// Helper functions for token management
const getAuthToken = () => {
  try {
    return localStorage.getItem('access');  // Changed from 'token' to 'access'
  } catch (error) {
    console.error('Error accessing localStorage:', error);
    return null;
  }
};

const getRefreshToken = () => {
  try {
    return localStorage.getItem('refresh');  // Changed from 'refreshToken' to 'refresh'
  } catch (error) {
    console.error('Error accessing localStorage:', error);
    return null;
  }
};

const setTokens = (accessToken, refreshToken) => {
  try {
    localStorage.setItem('access', accessToken);  // Changed from 'token' to 'access'
    if (refreshToken) {
      localStorage.setItem('refresh', refreshToken);  // Changed from 'refreshToken' to 'refresh'
    }
  } catch (error) {
    console.error('Error storing tokens:', error);
  }
};

const clearTokens = () => {
  try {
    localStorage.removeItem('access');  // Changed from 'token' to 'access'
    localStorage.removeItem('refresh');  // Changed from 'refreshToken' to 'refresh'
  } catch (error) {
    console.error('Error clearing tokens:', error);
  }
};

const API_CONFIG = {
  baseURL: process.env.REACT_APP_API_URL || 'http://127.0.0.1:8000/app',
  timeout: 10000,
  react: {
    login: '/api/react/login/',
    refresh: '/api/react/token/refresh/',
    verify: '/api/react/auth/verify/'
  }
};

// Axios instance configuration
const api = axios.create({
  baseURL: API_CONFIG.baseURL,
  timeout: API_CONFIG.timeout,
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  }
});

// Improved interceptors
api.interceptors.request.use(config => {
  const token = getAuthToken();
  if (token) config.headers.Authorization = `Bearer ${token}`;
  return config;
}, error => Promise.reject(error));

api.interceptors.response.use(
  response => response,
  async error => {
    const originalRequest = error.config;
    
    if (error.response?.status === 401 && !originalRequest._retry) {
      try {
        const refreshToken = getRefreshToken();
        if (!refreshToken) throw new Error('No refresh token');
        
        const { data } = await axios.post(
          `${API_CONFIG.baseURL}${API_CONFIG.react.refresh}`,
          { refresh: refreshToken }
        );
        
        setTokens(data.access, data.refresh);
        originalRequest.headers.Authorization = `Bearer ${data.access}`;
        return api(originalRequest);
      } catch (err) {
        clearTokens();
        if (window.location.pathname !== '/login') {
          window.location.href = '/login?sessionExpired=true';
        }
        return Promise.reject(err);
      }
    }
    
    return Promise.reject(error);
  }
);

// Response interceptor to handle token refresh
api.interceptors.response.use(
  (response) => response,
  async (error) => {
    const originalRequest = error.config;
    
    // Handle network errors
    if (!error.response) {
      console.error('Network error:', error.message);
      return Promise.reject({
        message: 'Network error. Please check your connection.',
        isNetworkError: true
      });
    }

    // Handle 401 Unauthorized
    if (error.response.status === 401 && !originalRequest._retry) {
      originalRequest._retry = true;
      
      try {
        const refreshToken = getRefreshToken();
        if (!refreshToken) throw new Error('No refresh token available');
        
        const response = await axios.post(`${BASE_URL}/api/token/refresh/`, {
          refresh: refreshToken
        }, {
          headers: {
            'Content-Type': 'application/json'
          }
        });

        if (!response.data?.access) {
          throw new Error('Invalid token refresh response');
        }

        setTokens(response.data.access, response.data.refresh);
        originalRequest.headers.Authorization = `Bearer ${response.data.access}`;
        return api(originalRequest);
      } catch (refreshError) {
        console.error('Token refresh failed:', refreshError);
        clearTokens();
        
        // Redirect to login if we're not already there
        if (window.location.pathname !== '/login') {
          window.location.href = '/login?sessionExpired=true';
        }
        
        return Promise.reject({
          message: 'Session expired. Please login again.',
          isAuthError: true
        });
      }
    }

    // Handle other error statuses
    const errorMessage = error.response.data?.message || 
                        error.response.data?.detail || 
                        error.message || 
                        'An unexpected error occurred';
    
    return Promise.reject({
      message: errorMessage,
      status: error.response.status,
      data: error.response.data
    });
  }
);

// API functions
export const getEventDashboardData = async () => {
  try {
    const response = await api.get('api/dashboard/events/');  // Updated endpoint to match your Django URL
    return {
      success: true,
      data: response.data
    };
  } catch (error) {
    return {
      success: false,
      error: error.message || 'Failed to fetch event dashboard data',
      status: error.status
    };
  }
};

export const approveEvent = async (eventId) => {
  try {
    const response = await api.post(`/api/events/${eventId}/approve/`);
    return {
      success: true,
      data: response.data
    };
  } catch (error) {
    return {
      success: false,
      error: error.message || 'Failed to approve event',
      status: error.status
    };
  }
};

export const rejectEvent = async (eventId, reason) => {
  try {
    const response = await api.post(`/api/events/${eventId}/reject/`, { reason });
    return {
      success: true,
      data: response.data
    };
  } catch (error) {
    return {
      success: false,
      error: error.message || 'Failed to reject event',
      status: error.status
    };
  }
};

// Auth utility functions
export const checkAuth = async () => {
  try {
    await api.get('/api/auth/verify/');
    return true;
  } catch (error) {
    return false;
  }
};

export const loginUser = async (email, password) => {
  try {
    const response = await axios.post(`${BASE_URL}/api/react/login/`, {
      email: email,
      password: password
    });
    
    if (response.data.tokens) {
      setTokens(response.data.tokens.access, response.data.tokens.refresh);
    }
    
    return {
      success: true,
      data: response.data
    };
  } catch (error) {
    console.log(error);
    return {
      success: false,
      error: error.response?.data?.message || 'Login failed',
      status: error.response?.status
    };
  }
};

export const authAPI = {
  login: async (email, password) => {
    try {
      const response = await api.post(API_CONFIG.react.login, { email, password });
      setTokens(response.data.tokens.access, response.data.tokens.refresh);
      return { success: true, data: response.data };
    } catch (error) {
      return {
        success: false,
        error: error.response?.data?.message || error.message,
        status: error.response?.status
      };
    }
  },
  
  verify: async () => {
    try {
      await api.get(API_CONFIG.react.verify);
      return true;
    } catch {
      return false;
    }
  },
  
  logout: () => {
    clearTokens();
  }
};
export const logout = () => {
  clearTokens();
};
export const eventsAPI = {
  getDashboardData: async () => {
    try {
      const response = await api.get('/api/get_event_dashboard_data/');
      return { success: true, data: response.data };
    } catch (error) {
      return {
        success: false,
        error: error.response?.data?.message || error.message,
        status: error.response?.status
      };
    }
  },
  
  approve: async (eventId) => {
    try {
      const response = await api.post(`/api/events/${eventId}/approve/`);
      return { success: true, data: response.data };
    } catch (error) {
      return {
        success: false,
        error: error.response?.data?.message || error.message,
        status: error.response?.status
      };
    }
  },
  
  reject: async (eventId, reason) => {
    try {
      const response = await api.post(`/api/events/${eventId}/reject/`, { reason });
      return { success: true, data: response.data };
    } catch (error) {
      return {
        success: false,
        error: error.response?.data?.message || error.message,
        status: error.response?.status
      };
    }
  }
};
export default api;