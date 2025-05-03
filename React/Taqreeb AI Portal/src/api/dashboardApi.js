import axios from 'axios';

const BASE_URL = 'http://127.0.0.1:8000'; // Change to your deployed Django URL if needed

export const getDashboardData = async () => {
  try {
    const token = localStorage.getItem('access'); // 🟡 This line gets your JWT from localStorage
    const response = await axios.get(`${BASE_URL}/api/admin-dashboard/`, {
      headers: {
        Authorization: `Bearer ${token}`, // 🟢 This sends the token to Django
      },
    });
    return response.data;
  } catch (error) {
    console.error("Failed to fetch dashboard data:", error);
    throw error;
  }
};
