import React from "react";
import "./login.css";
import StatsCard from "../../Components/StatsCard/statscard.jsx";
import { FaUserShield, FaUsers, FaChartLine } from "react-icons/fa";

const LoginScreen = () => {
  return (
    <div className="login-screen">
      <div className="login-container">
        <h2>Admin Dashboard Login</h2>
        <p>Please sign in to your admin account</p>
        <form className="login-form">
          <div className="input-group">
            <label>Email address</label>
            <input type="email" placeholder="Enter your email" required />
          </div>
          <div className="input-group">
            <label>Password</label>
            <input type="password" placeholder="Enter your password" required />
          </div>
          <div className="remember-forgot">
            <div className="remember-me">
              <input type="checkbox" id="remember-me" />
              <label htmlFor="remember-me">Remember me</label>
            </div>
            <a href="https://password/">Forgot password?</a>
          </div>
          <button type="submit" className="login-btn">Sign in</button>
        </form>
      </div>
    </div>
  );
};

export default LoginScreen;