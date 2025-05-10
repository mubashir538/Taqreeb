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
import Home from "./Pages/Home/HomeScreen.jsx";
import Statistics from "./Pages/Statistics/StatisticsScreen.jsx";
import Approvals from "./Pages/Approvals/ApprovalsPage.jsx";
import "./styles/global.css";

const AuthContext = React.createContext();

const AuthProvider = ({ children }) => {
  const [authState, setAuthState] = useState(() => {
    const accessToken = localStorage.getItem('access');
    const refreshToken = localStorage.getItem('refresh');
    const user = JSON.parse(localStorage.getItem('user'));
    
    return {
      isAuthenticated: !!accessToken,
      accessToken,
      refreshToken,
      user
    };
  });

  const login = (data) => {
    localStorage.setItem('access', data.accessToken);
    localStorage.setItem('refresh', data.refreshToken);
    localStorage.setItem('user', JSON.stringify(data.user));
    
    setAuthState({
      isAuthenticated: true,
      accessToken: data.accessToken,
      refreshToken: data.refreshToken,
      user: data.user
    });
  };

  const logout = () => {
    localStorage.removeItem('access');
    localStorage.removeItem('refresh');
    localStorage.removeItem('user');
    
    setAuthState({
      isAuthenticated: false,
      accessToken: null,
      refreshToken: null,
      user: null
    });
  };

  return (
    <AuthContext.Provider value={{ ...authState, login, logout }}>
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
    return <Navigate to="/home" replace />;
  }

  return children ? children : <Outlet />;
};

const AppContent = () => {
  const location = useLocation();
  const isAuthPage = location.pathname === '/login';
  const { isAuthenticated } = useAuth();

  return (
    <div className="app-container">
      {isAuthenticated && !isAuthPage && <Sidebar />}
      <div className="main-content">
        {isAuthenticated && !isAuthPage && <Navbar />}
        <div className="page-content">
          <Routes>
            {/* Public routes */}
            <Route element={<PublicRoute />}>
              <Route path="/login" element={<Login />} />
            </Route>
            
            {/* Protected routes */}
            <Route element={<ProtectedRoute />}>
              <Route path="/home" element={<Home />} />
              <Route path="/statistics" element={<Statistics />} />
              <Route path="/approvals" element={<Approvals />} /> 
            </Route>
            
            {/* Catch-all route */}
            <Route path="*" element={<Navigate to="/login" replace />} />
            
            {/* Root path redirects to login */}
            <Route path="/" element={<Navigate to="/login" replace />} />
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