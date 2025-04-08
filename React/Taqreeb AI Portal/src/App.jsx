import React from "react";
import { BrowserRouter as Router, Route, Routes, useLocation } from "react-router-dom";
import Sidebar from "./Components/Sidebar/sidebar.jsx";
import Navbar from "./Components/NavBar/NavBar.jsx";
import Login from "./Pages/Login/login.jsx";
import Dashboard from "./Pages/Dashboard/DashboardScreen.jsx";
import Events from "./Pages/Events/EventsScreen.jsx";
import Users from "./Pages/Users/UserScreen.jsx";
import Vendors from "./Pages/Vendors/VendorScreen.jsx";
import "./styles/global.css";

const AppContent = () => {
  const location = useLocation();
  const isLoginPage = location.pathname === "/";

  return (
    <div className="app-container">
      {!isLoginPage && <Sidebar />}
      <div className="main-content">
        {!isLoginPage && <Navbar />}
        <div className="page-content">
          <Routes>
            <Route path="/" element={<Login />} />
            <Route path="/dashboard" element={<Dashboard />} />
            <Route path="/events" element={<Events />} />
            <Route path="/users" element={<Users />} />
            <Route path="/vendor" element={<Vendors />} />
          </Routes>
        </div>
      </div>
    </div>
  );
};

function App() {
  return (
    <Router>
      <AppContent />
    </Router>
  );
}

export default App;