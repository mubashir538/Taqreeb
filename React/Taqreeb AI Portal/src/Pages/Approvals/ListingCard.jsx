import React, { useState } from "react";
import "./ListingCard.css";

const ListingCard = ({ listing, isSelected, onSelect }) => {
  const [isExpanded, setIsExpanded] = useState(false);

  const toggleExpand = (e) => {
    if (!e.target.closest(".card-checkbox")) {
      setIsExpanded(!isExpanded);
    }
  };

  if (!listing) return null;

  const formatDate = (dateString) => {
    if (!dateString) return "No date";
    const date = new Date(dateString);
    return date.toLocaleDateString();
  };

  const formatCurrency = (amount) => {
    return new Intl.NumberFormat("en-PK", {
      style: "currency",
      currency: "PKR",
      minimumFractionDigits: 0,
    })
      .format(amount)
      .replace("PKR", "Rs.");
  };

  const renderServiceDetails = () => {
    if (!listing.serviceDetails) return null;

    const details = [];
    for (const [key, value] of Object.entries(listing.serviceDetails)) {
      if (value && value !== "None" && value !== "") {
        details.push(
          <p key={key}>
            <strong>
              {key
                .replace(/([A-Z])/g, " $1")
                .replace(/^./, (str) => str.toUpperCase())}
              :
            </strong>{" "}
            {value}
          </p>
        );
      }
    }

    return (
      <div className="section">
        <h4>{listing.type} Details</h4>
        {details}
      </div>
    );
  };

  return (
    <div
      className={`listing-card ${isExpanded ? "expanded" : ""}`}
      onClick={toggleExpand}
    >
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

        <p className="submitted-by">Submitted by: {listing.owner_name}</p>

        <div className="card-details">
          <div className="detail-item">📍 {listing.location}</div>
          <div className="detail-item">
            💰 {formatCurrency(listing.priceMin)} -{" "}
            {formatCurrency(listing.priceMax)}
          </div>
          <div className="detail-item">
            ⭐ {listing.rating} ({listing.ratingCount} reviews)
          </div>
        </div>

        {isExpanded && (
          <div className="expanded-content">
            <div className="status-badge">Pending Review</div>

            <div className="section">
              <h4>Basic Information</h4>
              <p>
                <strong>Created:</strong> {formatDate(listing.created_at)}
              </p>
              <p>
                <strong>Base Price:</strong>{" "}
                {formatCurrency(listing.basicPrice)}
              </p>
              <p>
                <strong>Status:</strong> {listing.status}
              </p>
              {listing.booked_dates && listing.booked_dates.length > 0 && (
                <p>
                  <strong>Booked Dates:</strong>{" "}
                  {listing.booked_dates.join(", ")}
                </p>
              )}
            </div>

            <div className="section">
              <h4>Description</h4>
              <p>{listing.description}</p>
            </div>

            {renderServiceDetails()}

            {listing.images.length > 0 && (
              <div className="section">
                <h4>Listing Images ({listing.images.length})</h4>
                <div className="images-grid">
                  {listing.images.map((img, idx) => (
                    <div key={idx} className="image-container">
                      <img
                        src={img}
                        alt={`Listing ${idx}`}
                        className="listing-image"
                        onError={(e) => (e.target.style.display = "none")}
                      />
                    </div>
                  ))}
                </div>
              </div>
            )}

            {listing.packages.length > 0 && (
              <div className="section">
                <h4>Packages ({listing.packages.length})</h4>
                <div className="packages-grid">
                  {listing.packages.map((pkg) => (
                    <div key={pkg.id} className="package-card">
                      <h5>
                        {pkg.name} - {formatCurrency(pkg.price)}
                      </h5>
                      <p>{pkg.description}</p>
                      {pkg.images.length > 0 && (
                        <div className="package-images">
                          {pkg.images.map((img, idx) => (
                            <div key={idx} className="image-container">
                              <img
                                src={img}
                                alt={`Package ${pkg.name}`}
                                className="package-image"
                                onError={(e) =>
                                  (e.target.style.display = "none")
                                }
                              />
                            </div>
                          ))}
                        </div>
                      )}
                    </div>
                  ))}
                </div>
              </div>
            )}

            {listing.products.length > 0 && (
              <div className="section">
                <h4>Products ({listing.products.length})</h4>
                <div className="products-grid">
                  {listing.products.map((prod) => (
                    <div key={prod.id} className="product-card">
                      <h5>
                        {prod.name} - {formatCurrency(prod.price)}
                      </h5>
                      <p>{prod.description}</p>
                      <p>
                        <strong>Quantity:</strong> {prod.quantity}
                      </p>
                      {prod.images.length > 0 && (
                        <div className="product-images">
                          {prod.images.map((img, idx) => (
                            <div key={idx} className="image-container">
                              <img
                                src={img}
                                alt={prod.name}
                                className="product-image"
                                onError={(e) =>
                                  (e.target.style.display = "none")
                                }
                              />
                            </div>
                          ))}
                        </div>
                      )}
                    </div>
                  ))}
                </div>
              </div>
            )}

            {listing.addons.length > 0 && (
              <div className="section">
                <h4>Add-ons ({listing.addons.length})</h4>
                <div className="addons-grid">
                  {listing.addons.map((addon) => (
                    <div key={addon.id} className="addon-card">
                      <h5>
                        {addon.name} - {formatCurrency(addon.price)}
                      </h5>
                      <p>
                        {addon.isPer ? `Per ${addon.perType}` : "One-time fee"}
                      </p>
                    </div>
                  ))}
                </div>
              </div>
            )}
          </div>
        )}
      </div>
    </div>
  );
};

export default ListingCard;
