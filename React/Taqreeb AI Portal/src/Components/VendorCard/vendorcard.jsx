import React from "react";
import "./VendorCard.css";

const VendorCard = ({ name, contact, service, rating }) => {
  return (
    <div className="vendor-card">
      <h3>{name}</h3>
      <p>{contact}</p>
      <p>{service}</p>
      <p>Rating: {rating}</p>
    </div>
  );
};

export default VendorCard;