import React from "react";
import "./StatsCard.css";

const StatsCard = ({ icon, label, value }) => {
  return (
    <div className="stats-card">
      <div className="stats-icon">{icon}</div>
      <div className="stats-info">
        <p className="stats-label">{label}</p>
        <h2 className="stats-value">{value}</h2>
      </div>
    </div>
  );
};

export default StatsCard;
