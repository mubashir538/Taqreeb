import React from "react";
import { Link, useLocation } from "react-router-dom";
import "./NavBar.css";
import { FaBell, FaUserCircle, FaCheckCircle } from "react-icons/fa";

const NavBar = () => {
  const location = useLocation();
  
  // Function to format the current date
  const getCurrentDate = () => {
    const options = { 
      weekday: 'long', 
      year: 'numeric', 
      month: 'long', 
      day: 'numeric' 
    };
    return new Date().toLocaleDateString('en-US', options);
  };

  // Function to check if a route is active
  const isActive = (path) => {
    return location.pathname === path;
  };

  return (
    <nav className="navbar">
      <div className="navbar-left">
        <Link to="/" className="navbar-logo">
          <img src="/logo.png" alt="Logo" />
        </Link>
      </div>

      <div className="navbar-center">
        <ul className="nav-links">
          <li className={isActive("/home") ? "active" : ""}>
            <Link to="/home">Home</Link>
          </li>
          <li className={isActive("/statistics") ? "active" : ""}>
            <Link to="/statistics">Statistics</Link>
          </li>
          <li className={isActive("/approvals") ? "active" : ""}>
            <Link to="/approvals">
              Approvals
            </Link>
          </li>
        </ul>
      </div>

      <div className="navbar-right">
        <FaBell className="icon notification-icon" />
        <div className="profile">
          <div className="date-display"> {getCurrentDate()}</div>
        </div>
      </div>
    </nav>
  );
};

export default NavBar;