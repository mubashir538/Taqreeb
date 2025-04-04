import React from "react";
import { Link } from "react-router-dom";
import "./NavBar.css";
import { FaBell, FaUserCircle } from "react-icons/fa";

const NavBar = () => {
  return (
    <nav className="navbar">
      <div className="navbar-left">
        <Link to="/" className="navbar-logo">
          <img src="/logo.png" alt="Logo" />
        </Link>
      </div>

      <div className="navbar-center">
        <ul className="nav-links">
          <li>
            <Link to="/">Home</Link>
          </li>
          <li>
            <Link to="/events">Events</Link>
          </li>
          <li>
            <Link to="/users">Users</Link>
          </li>
          <li>
            <Link to="/vendors">Vendors</Link>
          </li>
        </ul>
      </div>

      <div className="navbar-right">
        <FaBell className="icon notification-icon" />
        <div className="profile">
          <div className="date-display">Today’s Date: Friday, March 7, 2025</div>
        </div>
      </div>
    </nav>
  );
};

export default NavBar;
