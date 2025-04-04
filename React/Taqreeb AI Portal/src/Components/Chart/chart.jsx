import React from "react";
import "./Chart.css";
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from "recharts";

const Chart = ({ data, title }) => {
  return (
    <div className="chart-container">
      <h2 className="chart-title">{title}</h2>
      <ResponsiveContainer width="100%" height={300}>
        <LineChart data={data} margin={{ top: 10, right: 30, left: 0, bottom: 0 }}>
          <CartesianGrid strokeDasharray="3 3" stroke="#444" />
          <XAxis dataKey="name" stroke="#ccc" />
          <YAxis stroke="#ccc" />
          <Tooltip contentStyle={{ backgroundColor: "#1a202c", border: "none", color: "white" }} />
          <Line type="monotone" dataKey="value" stroke="#facc15" strokeWidth={3} dot={{ fill: "#facc15", r: 4 }} />
        </LineChart>
      </ResponsiveContainer>
    </div>
  );
};

export default Chart;
