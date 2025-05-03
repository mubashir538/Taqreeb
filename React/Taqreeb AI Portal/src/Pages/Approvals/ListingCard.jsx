import React, { useState, useEffect } from 'react';
import axios from 'axios';
import './ListingCard.css';

const ListingCard = ({ listing, isSelected, onSelect }) => {
  const [isExpanded, setIsExpanded] = useState(false);
  const [details, setDetails] = useState(null);
  const [loadingDetails, setLoadingDetails] = useState(false);
  const [error, setError] = useState(null);

  const toggleExpand = async (e) => {
    if (e.target.type !== 'checkbox') {
      if (!isExpanded && !details) {
        setLoadingDetails(true);
        try {
          const response = await axios.get(`/api/approvals/listings/${listing.id}/`);
          setDetails(response.data);
        } catch (err) {
          setError('Failed to load details');
          console.error('Error fetching details:', err);
        } finally {
          setLoadingDetails(false);
        }
      }
      setIsExpanded(!isExpanded);
    }
  };

  return (
    <div className={`approval-card ${isExpanded ? 'expanded' : ''}`} onClick={toggleExpand}>
      <div className="card-checkbox" onClick={(e) => e.stopPropagation()}>
        <input 
          type="checkbox"
          checked={isSelected}
          onChange={() => onSelect(listing.id)}
        />
      </div>

      <div className="card-content">
        <div className="card-header">
          <h3>{listing.name}</h3>
          <span className="listing-type">{listing.type}</span>
        </div>

        <p className="submitted-by">
          Submitted by: {listing.ownerID?.name || listing.freelancerID?.name || 'Unknown'}
        </p>

        <div className="card-details">
          <div className="detail-item">📍 {listing.location || 'Unknown Location'}</div>
          <div className="detail-item">💰 ${listing.priceMin} - ${listing.priceMax}</div>
          <div className="detail-item">⭐ {listing.rating} ({listing.ratingCount} reviews)</div>
        </div>

        {isExpanded && (
          <div className="expanded-content">
            <div className="status-badge">Pending Review</div>

            {error && <div className="error-message">{error}</div>}
            {loadingDetails && <div className="loading-details">Loading details...</div>}

            {!loadingDetails && details && (
              <>
                <div className="section">
                  <h4>Description</h4>
                  <p>{listing.description || 'No description provided.'}</p>
                </div>

                {details?.packages?.length > 0 && (
                  <div className="section">
                    <h4>Pricing</h4>
                    <ul>
                      {details.packages.map(pkg => (
                        <li key={pkg.id}>
                          <strong>{pkg.name}:</strong> ${pkg.price}
                          {pkg.description && <> — {pkg.description}</>}
                        </li>
                      ))}
                    </ul>
                  </div>
                )}

                {details?.images?.length > 0 && (
                  <div className="section">
                    <h4>Images</h4>
                    <div className="images-grid">
                      {details.images.map((img, idx) => (
                        <img
                          key={idx}
                          src={img.picturePath}
                          alt={`Image ${idx}`}
                          className="thumbnail"
                        />
                      ))}
                    </div>
                  </div>
                )}

                <div className="section">
                  <h4>Contact</h4>
                  <p>Email: {listing.ownerID?.email || listing.freelancerID?.email || 'N/A'}</p>
                  <p>Phone: {listing.ownerID?.phone || listing.freelancerID?.phone || 'N/A'}</p>
                </div>

                <div className="section">
                  <h4>Documents</h4>
                  <ul>
                    <li>📄 Terms and Conditions.pdf</li>
                    <li>📄 License.pdf</li>
                  </ul>
                </div>
              </>
            )}
          </div>
        )}
      </div>
    </div>
  );
};

export default ListingCard;
