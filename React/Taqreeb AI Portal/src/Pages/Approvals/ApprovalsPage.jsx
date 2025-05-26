import React, { useState, useEffect } from "react";
import "./ApprovalsPage.css";
import ListingCard from "./ListingCard";
import VendorCard from "./VendorCard";
import apiService from "../../api/api";

const ApprovalsPage = () => {
  const [activeTab, setActiveTab] = useState("listings");
  const [selectedItems, setSelectedItems] = useState([]);
  const [categoryFilter, setCategoryFilter] = useState("All Categories");
  const [searchQuery, setSearchQuery] = useState("");
  const [listingsData, setListingsData] = useState([]);
  const [vendorsData, setVendorsData] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [stats, setStats] = useState({
    listings: { totalPending: 0, pendingByType: {} },
    vendors: { totalPending: 0, pendingByType: {} },
  });
  const [pagination, setPagination] = useState({
    page: 1,
    pageSize: 10,
    total: 0,
    totalPages: 1,
  });

  // Fetch stats for both listings and vendors
  useEffect(() => {
    const fetchStats = async () => {
      try {
        const [listingsResponse, vendorsResponse] = await Promise.all([
          apiService.getApprovalStats(),
          apiService.getVendorApprovalStats(),
        ]);
        setStats({
          listings: listingsResponse.pendingStats || {
            totalPending: 0,
            pendingByType: {},
          },
          vendors: vendorsResponse.pendingStats || {
            totalPending: 0,
            pendingByType: {},
          },
        });
      } catch (err) {
        console.error("Error fetching stats:", err);
      }
    };
    fetchStats();
  }, []);

  // Fetch data based on active tab
  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true);
        setError(null);

        if (activeTab === "listings") {
          const response = await apiService.getPendingListings({
            type: categoryFilter === "All Categories" ? null : categoryFilter,
            search: searchQuery,
            page: pagination.page,
            page_size: pagination.pageSize,
          });

          setListingsData(response.listings || []);
          setPagination((prev) => ({
            ...prev,
            total: response.pagination?.total || 0,
            totalPages: response.pagination?.total_pages || 1,
          }));
        } else {
          const response = await apiService.getPendingVendors({
            type: categoryFilter === "All Categories" ? null : categoryFilter,
            search: searchQuery,
            page: pagination.page,
            page_size: pagination.pageSize,
          });

          setVendorsData(response.vendors || []);
          setPagination((prev) => ({
            ...prev,
            total: response.pagination?.total || 0,
            totalPages: response.pagination?.total_pages || 1,
          }));
        }
      } catch (err) {
        console.error(`Error fetching ${activeTab}:`, err);
        setError(err.message || "Failed to load data");
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, [activeTab, categoryFilter, searchQuery, pagination.page]);

  const handleApprove = async () => {
    if (selectedItems.length === 0) return;

    try {
      if (activeTab === "listings") {
        await apiService.bulkUpdateListingStatus(selectedItems, "active");
      } else {
        const vendorType =
          vendorsData.find((v) => selectedItems.includes(v.id))?.type ||
          "business";
        await apiService.bulkUpdateVendorStatus(
          selectedItems,
          vendorType === "Freelancer" ? "freelancer" : "business",
          "approved"
        );
      }
      refreshData();
    } catch (err) {
      console.error("Error approving:", err);
      setError("Failed to approve items");
    }
  };

  const handleReject = async () => {
    if (selectedItems.length === 0) return;

    try {
      if (activeTab === "listings") {
        await apiService.bulkUpdateListingStatus(selectedItems, "rejected");
      } else {
        const vendorType =
          vendorsData.find((v) => selectedItems.includes(v.id))?.type ||
          "business";
        await apiService.bulkUpdateVendorStatus(
          selectedItems,
          vendorType === "Freelancer" ? "freelancer" : "business",
          "rejected"
        );
      }
      refreshData();
    } catch (err) {
      console.error("Error rejecting:", err);
      setError("Failed to reject items");
    }
  };

  const refreshData = () => {
    setPagination((prev) => ({ ...prev, page: 1 }));
    setSelectedItems([]);
  };

  const handlePageChange = (newPage) => {
    setPagination((prev) => ({ ...prev, page: newPage }));
  };

  const handleItemSelect = (id) => {
    setSelectedItems((prev) =>
      prev.includes(id) ? prev.filter((itemId) => itemId !== id) : [...prev, id]
    );
  };

  const handleSelectAll = () => {
    const currentItems =
      activeTab === "listings"
        ? listingsData.map((item) => item.id)
        : vendorsData.map((item) => item.id);

    setSelectedItems((prev) =>
      prev.length === currentItems.length ? [] : currentItems
    );
  };

  const getCategoryOptions = () => {
    if (activeTab === "listings") {
      return [
        "All Categories",
        ...Object.keys(stats.listings.pendingByType || {}),
      ];
    }
    return ["All Categories", "Business Owners", "Freelancers"];
  };

  if (loading) return <div className="loading">Loading...</div>;
  if (error) return <div className="error">Error: {error}</div>;

  return (
    <div className="approvals-container">
      <div className="approvals-tabs">
        <button
          className={`tab ${activeTab === "listings" ? "active" : ""}`}
          onClick={() => setActiveTab("listings")}
        >
          Unapproved Listings ({stats.listings.totalPending || 0})
        </button>
        <button
          className={`tab ${activeTab === "vendors" ? "active" : ""}`}
          onClick={() => setActiveTab("vendors")}
        >
          Unapproved Vendors ({stats.vendors.totalPending || 0})
        </button>
      </div>

      <div className="search-filter">
        <div className="filter-row">
          <div className="search-bar">
            <input
              type="text"
              placeholder={`Search ${activeTab}...`}
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
            />
          </div>

          <select
            value={categoryFilter}
            onChange={(e) => setCategoryFilter(e.target.value)}
            className="category-select"
          >
            {getCategoryOptions().map((type) => (
              <option key={type} value={type}>
                {type}
              </option>
            ))}
          </select>
        </div>

        <div className="select-all">
          <input
            type="checkbox"
            id="selectAll"
            checked={
              selectedItems.length > 0 &&
              ((activeTab === "listings" &&
                selectedItems.length === listingsData.length) ||
                (activeTab === "vendors" &&
                  selectedItems.length === vendorsData.length))
            }
            onChange={handleSelectAll}
          />
          <label htmlFor="selectAll">Select All</label>
        </div>
      </div>

      <div className="approval-cards">
        {activeTab === "listings" ? (
          listingsData.length > 0 ? (
            listingsData.map((listing) => (
              <ListingCard
                key={listing.id}
                listing={listing}
                isSelected={selectedItems.includes(listing.id)}
                onSelect={handleItemSelect}
              />
            ))
          ) : (
            <div className="no-results">No pending listings found</div>
          )
        ) : vendorsData.length > 0 ? (
          vendorsData.map((vendor) => (
            <VendorCard
              key={vendor.id}
              vendor={vendor}
              isSelected={selectedItems.includes(vendor.id)}
              onSelect={handleItemSelect}
            />
          ))
        ) : (
          <div className="no-results">No pending vendors found</div>
        )}
      </div>

      {pagination.totalPages > 1 && (
        <div className="pagination-controls">
          <button
            onClick={() => handlePageChange(pagination.page - 1)}
            disabled={pagination.page === 1}
          >
            &lt;
          </button>
          {[...Array(pagination.totalPages)].map((_, index) => (
            <button
              key={index}
              className={pagination.page === index + 1 ? "active" : ""}
              onClick={() => handlePageChange(index + 1)}
            >
              {index + 1}
            </button>
          ))}
          <button
            onClick={() => handlePageChange(pagination.page + 1)}
            disabled={pagination.page === pagination.totalPages}
          >
            &gt;
          </button>
        </div>
      )}

      <div className="approval-actions">
        <div className="action-buttons">
          <button
            className="approve-btn"
            onClick={handleApprove}
            disabled={selectedItems.length === 0}
          >
            Approve Selected ({selectedItems.length})
          </button>
          <button
            className="reject-btn"
            onClick={handleReject}
            disabled={selectedItems.length === 0}
          >
            Reject Selected ({selectedItems.length})
          </button>
        </div>
      </div>
    </div>
  );
};

export default ApprovalsPage;
