const express = require("express");
const { Pool } = require("pg");

const app = express();

const pool = new Pool({
  host: process.env.DB_HOST,
  port: process.env.DB_PORT,
  database: process.env.DB_NAME,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  ssl: process.env.DB_SSL === "true"
    ? { rejectUnauthorized: false }
    : false
});

app.get("/api/", (req, res) => {
  res.send("Supplier Directory Backend is running");
});

app.get("/api/db", async (req, res) => {
  try {
    const result = await pool.query("SELECT NOW()");

    res.json({
      status: "Database connected",
      time: result.rows[0].now
    });
  } catch (error) {
    res.status(500).json({
      status: "Database connection failed",
      error: error.message
    });
  }
});

app.listen(5000, "0.0.0.0", () => {
  console.log("Backend running on port 5000");
});