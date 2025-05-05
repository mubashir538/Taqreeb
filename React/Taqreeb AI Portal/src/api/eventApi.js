import axios from 'axios';

// ==========================
//    Base Configuration
// ==========================
const BASE_URL = 'http://127.0.0.1:8000/app';

const API_CONFIG = {
  baseURL: BASE_URL,
  react: {
    login: '/api/react/login/',
    refresh: '/api/react/token/refresh/',
    verify: '/api/react/auth/verify/',
  }
};

// ==========================
//    Token Management
// ==========================
const getAuthToken = () => {
  try {
    return localStorage.getItem('access');
  } catch (error) {
    console.error('Error accessing localStorage:', error);
    return null;
  }
};

const getRefreshToken = () => {
  try {
    return localStorage.getItem('refresh');
  } catch (error) {
    console.error('Error accessing localStorage:', error);
    return null;
  }
};

const setTokens = (accessToken, refreshToken) => {
  try {
    localStorage.setItem('access', accessToken);
    if (refreshToken) {
      localStorage.setItem('refresh', refreshToken);
    }
  } catch (error) {
    console.error('Error storing tokens:', error);
  }
};

const clearTokens = () => {
  try {
    localStorage.removeItem('access');
    localStorage.removeItem('refresh');
  } catch (error) {
    console.error('Error clearing tokens:', error);
  }
};

// ==========================
//    Axios Instance
// ==========================
const api = axios.create({
  baseURL: API_CONFIG.baseURL,
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  }
});

// ==========================
//    Interceptors
// ==========================

// Request Interceptor - attach access token
api.interceptors.request.use(config => {
  const token = getAuthToken();
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
}, error => Promise.reject(error));

// Response Interceptor - handle token refresh and errors
api.interceptors.response.use(
  (response) => response,
  async (error) => {
    const originalRequest = error.config;

    // Handle network error
    if (!error.response) {
      console.error('Network error:', error.message);
      return Promise.reject({
        message: 'Network error. Please check your connection.',
        isNetworkError: true
      });
    }

    // Handle 401 Unauthorized - try token refresh
    if (error.response.status === 401 && originalRequest && !originalRequest._retry) {
      originalRequest._retry = true;
      try {
        const refreshToken = getRefreshToken();
        if (!refreshToken) throw new Error('No refresh token available');

        const { data } = await axios.post(
          `${API_CONFIG.baseURL}${API_CONFIG.react.refresh}`,
          { refresh: refreshToken },
          { headers: { 'Content-Type': 'application/json' } }
        );

        if (!data.access) {
          throw new Error('Invalid refresh response');
        }

        setTokens(data.access, data.refresh);
        originalRequest.headers.Authorization = `Bearer ${data.access}`;
        return api(originalRequest);

      } catch (refreshError) {
        console.error('Token refresh failed:', refreshError);
        clearTokens();
        if (window.location.pathname !== '/login') {
          window.location.href = '/login?sessionExpired=true';
        }
        return Promise.reject({
          message: 'Session expired. Please login again.',
          isAuthError: true
        });
      }
    }

    // Handle other errors
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

// ==========================
//    Auth API Functions
// ==========================
export const loginUser = async (email, password) => {
  try {
    const response = await axios.post(`${API_CONFIG.baseURL}${API_CONFIG.react.login}`, {
      email: email,
      password: password
    }, {
      headers: {
        'Content-Type': 'application/json'
      }
    });

    if (response.data.tokens) {
      setTokens(response.data.tokens.access, response.data.tokens.refresh);
    }

    return {
      success: true,
      data: response.data
    };
  } catch (error) {
    console.error('Login error:', error);
    return {
      success: false,
      error: error.response?.data?.message || error.message || 'Login failed',
      status: error.response?.status
    };
  }
};

export const checkAuth = async () => {
  try {
    await api.get(API_CONFIG.react.verify);
    return true;
  } catch {
    return false;
  }
};

export const logout = () => {
  clearTokens();
};

export const authAPI = {
  login: async (email, password) => {
    try {
      const response = await api.post(API_CONFIG.react.login, { email, password });
      if (response.data.tokens) {
        setTokens(response.data.tokens.access, response.data.tokens.refresh);
      }
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

// ==========================
//    Events API Functions
// ==========================
export const getEventDashboardData = async () => {
  try {
    const response = await api.get('/api/dashboard/events/');
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

// ==========================
//    Default Export
// ==========================
export default api;
