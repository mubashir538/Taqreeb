import React from 'react';
import './ListingsTable.css';

const ListingsTable = ({ listings, selectedItems, onSelectAll, onItemSelect }) => {
  const allSelected = listings.length > 0 && selectedItems.length === listings.length;
  
  return (
    <div className="listings-container">
      {listings.length === 0 ? (
        <div className="no-results">No listings found</div>
      ) : (
        <>
          <div className="select-all-control">
            <input
              type="checkbox"
              id="selectAll"
              checked={allSelected}
              onChange={(e) => onSelectAll(e.target.checked)}
            />
            <label htmlFor="selectAll">Select All</label>
          </div>
          
          <div className="listing-cards">
            {listings.map(listing => (
              <div key={listing.id} className="listing-card">
                <div className="card-checkbox">
                  <input
                    type="checkbox"
                    checked={selectedItems.includes(listing.id)}
                    onChange={(e) => onItemSelect(listing.id, e.target.checked)}
                  />
                </div>
                <div className="card-content">
                  <h3 className="card-title">{listing.title}</h3>
                  <p className="card-submitted">Submitted by: {listing.submittedBy}</p>
                  
                  <div className="card-details">
                    <span className="detail-item">{listing.date}</span>
                    <span className="detail-separator">•</span>
                    <span className="detail-item">{listing.category}</span>
                    <span className="detail-separator">•</span>
                    <span className="detail-item">{listing.location}</span>
                  </div>
                  
                  <div className="card-status">
                    <span className="status-badge">Pending Review</span>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </>
      )}
    </div>
  );
};

export default ListingsTable;