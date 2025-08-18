import React, { useState, useEffect } from "react";
import { Link, useLocation } from "react-router-dom";
import "./Sidebar.css";
import { FaHome, FaChartBar, FaBars, FaTimes, FaCheckCircle } from "react-icons/fa"; // Added FaCheckCircle for Approvals icon
import logo from "../../assets/logo.png";


const Sidebar = () => {
  const location = useLocation();
  const [active, setActive] = useState(location.pathname);
  const [isSidebarOpen, setIsSidebarOpen] = useState(true);
  const [userData, setUserData] = useState(null);
  const backendBaseUrl = "http://127.0.0.1:8000/app/";

  useEffect(() => {
    // Update active state when location changes
    setActive(location.pathname);
  }, [location]);

  useEffect(() => {
    // Fetch user data from localStorage
    const user = JSON.parse(localStorage.getItem('user'));
    if (user) {
      setUserData(user);
    }
  }, []);

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
            <img src={logo} alt="Logo" />
            <div className="logo-text"></div>
            <div className="logo-subtext"></div>
          </div>
          <ul className="sidebar-menu">
            <li className={active === "/home" ? "active" : ""}>
              <Link to="/home" onClick={() => setActive("/home")}>
                <FaHome className="icon" />
                Home
              </Link>
            </li>
            <li className={active === "/statistics" ? "active" : ""}>
              <Link to="/statistics" onClick={() => setActive("/statistics")}>
                <FaChartBar className="icon" />
                Statistics
              </Link>
            </li>
            <li className={active === "/approvals" ? "active" : ""}>
              <Link to="/approvals" onClick={() => setActive("/approvals")}>
                <FaCheckCircle className="icon" />
                Approvals
              </Link>
            </li>
          </ul>
          <div className="user-profile">
            {userData ? (
              <>
                <img 
                  src={`${backendBaseUrl}${userData.profilePicturePath}`} 
                  alt={userData.name} 
                  onError={(e) => {
                    e.target.onerror = null; 
                    e.target.src = "/user-avatar.png"
                  }}
                />
                <div className="user-info">
                  <p>{userData.name}</p>
                  <span>@{userData.username}</span>
                </div>
              </>
            ) : (
              <>
                <img src="/user-avatar.png" alt="User" />
                <div className="user-info">
                  <p>Loading...</p>
                  <span>User</span>
                </div>
              </>
            )}
          </div>
        </>
      )}
    </div>
  );
};

export default Sidebar;