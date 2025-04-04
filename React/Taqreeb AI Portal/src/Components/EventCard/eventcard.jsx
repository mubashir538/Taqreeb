import React from "react";
import "./EventCard.css";
import { FaCalendarAlt } from "react-icons/fa";

const EventCard = ({ title, date, description }) => {
  return (
    <div className="event-card">
      <div className="event-icon">
        <FaCalendarAlt />
      </div>
      <div className="event-content">
        <h3 className="event-title">{title}</h3>
        <p className="event-date">{date}</p>
        <p className="event-description">{description}</p>
      </div>
    </div>
  );
};

export default EventCard;
