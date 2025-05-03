import React, { useState } from 'react';
import './VendorCard.css';

const VendorCard = ({ vendor, isSelected, onSelect }) => {
  const [isExpanded, setIsExpanded] = useState(false);

  const toggleExpand = (e) => {
    if (!e.target.closest('.card-checkbox, .action-buttons')) {
      setIsExpanded(!isExpanded);
    }
  };

  if (!vendor) return null;

  return (
    <div className={`approval-card ${isExpanded ? 'expanded' : ''}`} onClick={toggleExpand}>
      <div className="card-checkbox" onClick={(e) => e.stopPropagation()}>
        <input 
          type="checkbox"
          checked={isSelected}
          onChange={() => onSelect(vendor.id)}
        />
      </div>

      <div className="card-content">
        <h3>{vendor.name || 'Unknown Vendor'}</h3>

        {!isExpanded ? (
          <>
            <p className="business-type">{vendor.type || 'No type specified'}</p>
            <div className="card-details">
              <div className="detail-item">Applied: {vendor.dateApplied || 'No date'}</div>
              <div className="detail-item">{vendor.location || 'No location'}</div>
            </div>
            <div className="status-pending">Pending Review</div>
          </>
        ) : (
          <div className="expanded-content">
            <div className="vendor-info-grid">
              <div className="vendor-info-left">
                <h4>Business Information</h4>
                <p><strong>Business Name:</strong> {vendor.name}</p>
                <p><strong>Business Type:</strong> {vendor.type}</p>
                <p><strong>Registration Number:</strong> {vendor.registrationNumber}</p>
                <p><strong>Tax ID:</strong> {vendor.taxId}</p>
                <p><strong>Established:</strong> {vendor.established}</p>
                <p><strong>Number of Employees:</strong> {vendor.employeeCount}</p>

                <h4>Contact Information</h4>
                <p><strong>Primary Contact:</strong> {vendor.contactName}</p>
                <p><strong>Position:</strong> {vendor.position}</p>
                <p><strong>Email:</strong> {vendor.email}</p>
                <p><strong>Phone:</strong> {vendor.phone}</p>
                <p><strong>Business Address:</strong> {vendor.address}</p>

                <h4>Business Description</h4>
                <p>{vendor.description}</p>
              </div>

              <div className="vendor-info-right">
                <div className="vendor-logo">
                  <h5>Business Logo</h5>
                  <div className="logo-placeholder">🖼️</div>
                </div>

                <div className="documents-section">
                  <h5>Verification Documents</h5>
                  <ul className="document-list">
                    {vendor.documents?.map((doc, idx) => (
                      <li key={idx}>
                        📄 {doc.name} <span className="doc-size">({doc.size})</span>
                        <button className="download-btn">⤓</button>
                      </li>
                    ))}
                  </ul>
                </div>

                <div className="social-section">
                  <h5>Social Media & Website</h5>
                  <ul className="social-list">
                    {vendor.website && <li>🌐 {vendor.website}</li>}
                    {vendor.instagram && <li>📸 {vendor.instagram}</li>}
                    {vendor.twitter && <li>🐦 {vendor.twitter}</li>}
                  </ul>
                </div>
              </div>
            </div>

            <div className="action-buttons">
              <button className="request-info">Request More Info</button>
              <button className="reject">Reject</button>
              <button className="approve">Approve</button>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default VendorCard;
