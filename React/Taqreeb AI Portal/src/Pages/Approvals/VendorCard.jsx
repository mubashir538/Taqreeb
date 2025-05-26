import React, { useState } from "react";
import "./VendorCard.css";

const VendorCard = ({ vendor, isSelected, onSelect }) => {
  const [isExpanded, setIsExpanded] = useState(false);

  const toggleExpand = (e) => {
    if (!e.target.closest(".card-checkbox, .action-buttons")) {
      setIsExpanded(!isExpanded);
    }
  };

  if (!vendor) return null;

  // Helper functions
  const formatDate = (dateString) => {
    if (!dateString) return "No date";
    const date = new Date(dateString);
    return date.toLocaleDateString();
  };

  const renderImage = (src, alt) => {
    if (!src) return null;
    return <img src={src} alt={alt} className="document-image" />;
  };

  return (
    <div
      className={`approval-card ${isExpanded ? "expanded" : ""}`}
      onClick={toggleExpand}
    >
      <div className="card-checkbox" onClick={(e) => e.stopPropagation()}>
        <input
          type="checkbox"
          checked={isSelected}
          onChange={() => onSelect(vendor.id)}
        />
      </div>

      <div className="card-content">
        <div className="card-header">
          <h3>{vendor.name || "Unknown Vendor"}</h3>
          <span className="vendor-type">{vendor.type}</span>
        </div>

        {!isExpanded ? (
          <>
            <p className="submitted-by">
              Submitted by: {vendor.user?.firstName} {vendor.user?.lastName}
            </p>
            <div className="card-details">
              <div className="detail-item">
                Registered: {formatDate(vendor.created_at)}
              </div>
              <div className="detail-item">Status: {vendor.status}</div>
            </div>
            <div className="status-pending">Pending Review</div>
          </>
        ) : (
          <div className="expanded-content">
            <div className="vendor-info-grid">
              <div className="vendor-info-left">
                <h4>Business Information</h4>
                <p>
                  <strong>Business Name:</strong> {vendor.name}
                </p>
                <p>
                  <strong>Business Type:</strong> {vendor.type}
                </p>
                {vendor.cnic && (
                  <p>
                    <strong>CNIC:</strong> {vendor.cnic}
                  </p>
                )}
                {vendor.portfolioLink && (
                  <p>
                    <strong>Portfolio:</strong>{" "}
                    <a
                      href={vendor.portfolioLink}
                      target="_blank"
                      rel="noopener noreferrer"
                    >
                      {vendor.portfolioLink}
                    </a>
                  </p>
                )}
                <p>
                  <strong>Balance:</strong> ${vendor.balance}
                </p>
                <p>
                  <strong>Registered:</strong> {formatDate(vendor.created_at)}
                </p>

                <h4>Contact Information</h4>
                <p>
                  <strong>Name:</strong> {vendor.user?.firstName}{" "}
                  {vendor.user?.lastName}
                </p>
                <p>
                  <strong>Email:</strong> {vendor.user?.email || "N/A"}
                </p>
                <p>
                  <strong>Phone:</strong> {vendor.user?.contactNumber || "N/A"}
                </p>
                <p>
                  <strong>City:</strong> {vendor.user?.city || "N/A"}
                </p>

                <h4>Business Description</h4>
                <p>{vendor.description || "No description provided"}</p>
              </div>

              <div className="vendor-info-right">
                <div className="vendor-images">
                  {vendor.profilePic && (
                    <div className="image-section">
                      <h5>Profile Picture</h5>
                      {renderImage(vendor.profilePic, "Profile")}
                    </div>
                  )}

                  {vendor.user?.profilePicture && (
                    <div className="image-section">
                      <h5>User Profile Picture</h5>
                      {renderImage(vendor.user.profilePicture, "User Profile")}
                    </div>
                  )}
                </div>

                <div className="documents-section">
                  <h5>Verification Documents</h5>
                  <ul className="document-list">
                    {vendor.cnicFront && (
                      <li>
                        <strong>CNIC Front:</strong>
                        {renderImage(vendor.cnicFront, "CNIC Front")}
                      </li>
                    )}
                    {vendor.cnicBack && (
                      <li>
                        <strong>CNIC Back:</strong>
                        {renderImage(vendor.cnicBack, "CNIC Back")}
                      </li>
                    )}
                  </ul>
                </div>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default VendorCard;
