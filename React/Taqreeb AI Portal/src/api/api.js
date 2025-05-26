// src/api/apiService.js
import axios from "axios";

const API_BASE_URL = "http://127.0.0.1:8000"; // Base URL without the endpoint

class ApiService {
  constructor() {
    this.api = axios.create({
      baseURL: API_BASE_URL,
    });

    const accessToken = localStorage.getItem("access");
    const refreshToken = localStorage.getItem("refresh");
    this.setAuthTokens(accessToken, refreshToken);
  }

  setAuthTokens(accessToken, refreshToken) {
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;

    if (accessToken) {
      this.api.defaults.headers.common[
        "Authorization"
      ] = `Bearer ${accessToken}`;
    } else {
      delete this.api.defaults.headers.common["Authorization"];
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
      console.error("API Error:", error.response.status, error.response.data);
      // Handle 401 unauthorized (token expired)
      if (error.response.status === 401) {
        // You might want to add token refresh logic here
      }
    } else if (error.request) {
      console.error("API Error: No response received", error.request);
    } else {
      console.error("API Error:", error.message);
    }
  }

  // Specific API methods
  async login(email, password) {
    const response = await this.post("/app/api/react/login/", {
      email,
      password,
    });

    if (response.status === "success") {
      this.setAuthTokens(response.access, response.refresh);
      return response;
    }

    throw new Error(response.message || "Login failed");
  }

  // Approval endpoints
  async getApprovalStats() {
    return this.get("app/api/approvals/stats/");
  }

  async getVendorApprovalStats() {
    return this.get("app/api/approvals/vendors/stats/");
  }

  async getPendingListings(params) {
    return this.get("app/api/approvals/listings/", params);
  }

  async getPendingVendors(params) {
    return this.get("app/api/approvals/vendors/", params);
  }

  async bulkUpdateListingStatus(ids, status) {
    return this.post("app/api/approvals/bulk-status/", { ids, status });
  }

  async bulkUpdateVendorStatus(ids, vendorType, status) {
    return this.post("app/api/approvals/vendors/bulk-status/", {
      ids,
      vendor_type: vendorType,
      status,
    });
  }
}

const apiService = new ApiService();
export default apiService;
