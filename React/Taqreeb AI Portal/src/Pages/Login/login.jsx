import React, { useState } from "react";
import "./login.css";
import { useNavigate } from "react-router-dom";
import { useAuth } from "../../App";
import apiService from "../../api/api";

const LoginScreen = () => {
  const navigate = useNavigate();
  const { login } = useAuth();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [errorMsg, setErrorMsg] = useState("");
  const [isLoading, setIsLoading] = useState(false);

  const handleLogin = async (e) => {
    e.preventDefault();
    setErrorMsg("");
    setIsLoading(true);

    try {
      const response = await apiService.login(email, password);
      
      // Assuming your useAuth hook expects user data and tokens
      login({
        user: response.user,
        accessToken: response.access,
        refreshToken: response.refresh
      });
      
      // Redirect to dashboard or home page after successful login
      navigate("/dashboard");
    } catch (error) {
      setErrorMsg(error.message || "Invalid email or password");
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="login-screen">
      <div className="login-container">
        <h2>Admin Dashboard Login</h2>
        <p>Please sign in to your admin account</p>
        {errorMsg && <p className="error-message">{errorMsg}</p>}
        <form className="login-form" onSubmit={handleLogin}>
          <div className="input-group">
            <label>Email address</label>
            <input
              type="email"
              placeholder="Enter your email"
              required
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              autoComplete="username"
            />
          </div>
          <div className="input-group">
            <label>Password</label>
            <input
              type="password"
              placeholder="Enter your password"
              required
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              autoComplete="current-password"
            />
          </div>
          <div className="remember-forgot">
            <div className="remember-me">
              <input type="checkbox" id="remember-me" />
              <label htmlFor="remember-me">Remember me</label>
            </div>
            <a href="/forgot-password">Forgot password?</a>
          </div>
          <button
            type="submit"
            className="login-btn"
            disabled={isLoading}
          >
            {isLoading ? "Signing in..." : "Sign in"}
          </button>
        </form>
      </div>
    </div>
  );
};

export default LoginScreen;