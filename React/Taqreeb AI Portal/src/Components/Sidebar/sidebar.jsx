import React, { useState } from "react";
import { Link, useLocation } from "react-router-dom";
import "./Sidebar.css";
import { FaHome, FaUser, FaUsers, FaClipboardList, FaBars, FaTimes } from "react-icons/fa";

const Sidebar = () => {
  const location = useLocation();
  const [active, setActive] = useState(location.pathname);
  const [isSidebarOpen, setIsSidebarOpen] = useState(true);

  const toggleSidebar = () => {
    setIsSidebarOpen(!isSidebarOpen);
  };

  return (
    <div className={`sidebar ${isSidebarOpen ? "" : "closed"}`}>
      <div className="sidebar-toggle" onClick={toggleSidebar}>
        {isSidebarOpen ? <FaTimes className="icon" /> : <FaBars className="icon" />}
      </div>
      {isSidebarOpen && (
        <>
          <div className="logo">
            <img src="/logo.png" alt="Logo" />
          </div>
          <ul className="sidebar-menu">
            <li className={active === "/" ? "active" : ""}>
              <Link to="/" onClick={() => setActive("/")}>
                <FaHome className="icon" />
                Home
              </Link>
            </li>
            <li className={active === "/events" ? "active" : ""}>
              <Link to="/events" onClick={() => setActive("/events")}>
                <FaClipboardList className="icon" />
                Events
              </Link>
            </li>
            <li className={active === "/users" ? "active" : ""}>
              <Link to="/users" onClick={() => setActive("/users")}>
                <FaUser className="icon" />
                Users
              </Link>
            </li>
            <li className={active === "/vendors" ? "active" : ""}>
              <Link to="/vendors" onClick={() => setActive("/vendors")}>
                <FaUsers className="icon" />
                Vendors
              </Link>
            </li>
          </ul>
          <div className="user-profile">
            <img src="/user-avatar.png" alt="User" />
            <div className="user-info">
              <p>Wishma Khan</p>
              <span>Administrator</span>
            </div>
          </div>
        </>
      )}
    </div>
  );
};

export default Sidebar;