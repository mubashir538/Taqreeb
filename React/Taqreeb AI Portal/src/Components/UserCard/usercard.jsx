import React from "react";
import "./UserCard.css";
import { FaUserCircle } from "react-icons/fa";

const UserCard = ({ name, role, profilePic }) => {
  return (
    <div className="user-card">
      <div className="user-avatar">
        {profilePic ? <img src={profilePic} alt="User" /> : <FaUserCircle />}
      </div>
      <div className="user-info">
        <h3 className="user-name">{name}</h3>
        <p className="user-role">{role}</p>
      </div>
    </div>
  );
};

export default UserCard;
