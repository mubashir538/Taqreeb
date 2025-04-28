import React from 'react';
import './VendorsTable.css';

const VendorsTable = ({ vendors, selectedItems, onSelectAll, onItemSelect }) => {
  const allSelected = vendors.length > 0 && selectedItems.length === vendors.length;
  
  return (
    <div className="vendors-table">
      {vendors.length === 0 ? (
        <div className="no-results">No vendors found</div>
      ) : (
        <div className="table-container">
          <div className="table-header">
            <div className="header-checkbox">
              <input
                type="checkbox"
                checked={allSelected}
                onChange={(e) => onSelectAll(e.target.checked)}
              />
            </div>
            <div className="header-name">Vendor Name</div>
            <div className="header-type">Type</div>
            <div className="header-date">Date Registered</div>
            <div className="header-location">Location</div>
          </div>
          
          {vendors.map(vendor => (
            <div key={vendor.id} className="table-row">
              <div className="row-checkbox">
                <input
                  type="checkbox"
                  checked={selectedItems.includes(vendor.id)}
                  onChange={(e) => onItemSelect(vendor.id, e.target.checked)}
                />
              </div>
              <div className="row-name">{vendor.name}</div>
              <div className="row-type">{vendor.type}</div>
              <div className="row-date">{vendor.dateRegistered}</div>
              <div className="row-location">{vendor.location}</div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
};

export default VendorsTable;