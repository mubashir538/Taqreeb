// auth.js
export const getAuthToken = () => {
    return localStorage.getItem('authToken');
  };
  
  export const setAuthToken = (token) => {
    localStorage.setItem('authToken', token);
  };
  
  export const clearAuthToken = () => {
    localStorage.removeItem('authToken');
  };