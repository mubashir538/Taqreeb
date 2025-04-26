import React, { useEffect, useState } from "react";
import { 
  BrowserRouter as Router, 
  Route, 
  Routes, 
  useLocation,
  Navigate,
  Outlet 
} from "react-router-dom";
import Sidebar from "./Components/Sidebar/sidebar.jsx";
import Navbar from "./Components/NavBar/NavBar.jsx";
import Login from "./Pages/Login/login.jsx";
import Dashboard from "./Pages/Dashboard/DashboardScreen.jsx";
import Events from "./Pages/Events/EventsScreen.jsx";
import Users from "./Pages/Users/UserScreen.jsx";
import Vendors from "./Pages/Vendors/VendorScreen.jsx";
import "./styles/global.css";

// Auth context to manage authentication state
const AuthContext = React.createContext();

const AuthProvider = ({ children }) => {
  const [isAuthenticated, setIsAuthenticated] = useState(() => {
    const accessToken = localStorage.getItem('access');
    return !!accessToken;
  });

  const login = (token) => {
    localStorage.setItem('access', token);
    setIsAuthenticated(true);
  };

  const logout = () => {
    localStorage.removeItem('access');
    localStorage.removeItem('refresh');
    setIsAuthenticated(false);
  };

  return (
    <AuthContext.Provider value={{ isAuthenticated, login, logout }}>
      {children}
    </AuthContext.Provider>
  );
};

const useAuth = () => {
  return React.useContext(AuthContext);
};

const ProtectedRoute = ({ children }) => {
  const { isAuthenticated } = useAuth();
  const location = useLocation();

  if (!isAuthenticated) {
    return <Navigate to="/login" state={{ from: location }} replace />;
  }

  return children ? children : <Outlet />;
};

const PublicRoute = ({ children }) => {
  const { isAuthenticated } = useAuth();
  const location = useLocation();

  if (isAuthenticated) {
    const from = location.state?.from?.pathname || '/dashboard';
    return <Navigate to={from} replace />;
  }

  return children ? children : <Outlet />;
};

const AppContent = () => {
  const location = useLocation();
  const isAuthPage = ['/login', '/'].includes(location.pathname);

  return (
    <div className="app-container">
      {!isAuthPage && <Sidebar />}
      <div className="main-content">
        {!isAuthPage && <Navbar />}
        <div className="page-content">
          <Routes>
            {/* Public routes */}
            <Route element={<PublicRoute />}>
              <Route path="/login" element={<Login />} />
              <Route path="/" element={<Navigate to="/login" replace />} />
            </Route>
            
            {/* Protected routes */}
            <Route element={<ProtectedRoute />}>
              <Route path="/dashboard" element={<Dashboard />} />
              <Route path="/events" element={<Events />} />
              <Route path="/users" element={<Users />} />
              <Route path="/vendor" element={<Vendors />} />
            </Route>
            
            {/* Catch-all route */}
            <Route path="*" element={<Navigate to="/login" replace />} />
          </Routes>
        </div>
      </div>
    </div>
  );
};

function App() {
  return (
    <AuthProvider>
      <Router>
        <AppContent />
      </Router>
    </AuthProvider>
  );
}

export default App;
export { useAuth };