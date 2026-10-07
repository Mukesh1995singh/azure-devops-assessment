const express = require("express");
const { Pool } = require("pg");

const app = express();
const port = process.env.PORT || 8080;

const pool = new Pool({
  host: process.env.DB_HOST || "localhost",
  port: Number(process.env.DB_PORT || 5432),
  database: process.env.DB_NAME || "booking_db",
  user: process.env.DB_USER || "booking_user",
  password: process.env.DB_PASSWORD || "booking_password",
});

app.use(express.json());

app.get("/health", async (req, res) => {
  try {
    await pool.query("SELECT 1");
    res.status(200).json({
      status: "healthy",
      database: "connected"
    });
  } catch (error) {
    res.status(503).json({
      status: "unhealthy",
      database: "disconnected"
    });
  }
});

app.get("/api/bookings", async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT
        id,
        org_id,
        hotel_id,
        city,
        checkin_date,
        checkout_date,
        amount,
        status,
        created_at
      FROM hotel_bookings
      ORDER BY created_at DESC
      LIMIT 100
    `);

    res.status(200).json(result.rows);
  } catch (error) {
    console.error("Failed to fetch bookings:", error.message);

    res.status(500).json({
      error: "Failed to fetch bookings"
    });
  }
});

app.get("/api/bookings/summary", async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT
        org_id,
        status,
        COUNT(*) AS booking_count,
        SUM(amount) AS total_amount
      FROM hotel_bookings
      WHERE city = 'delhi'
        AND created_at >= NOW() - INTERVAL '30 days'
      GROUP BY org_id, status
      ORDER BY org_id, status
    `);

    res.status(200).json(result.rows);
  } catch (error) {
    console.error("Failed to fetch booking summary:", error.message);

    res.status(500).json({
      error: "Failed to fetch booking summary"
    });
  }
});

app.listen(port, "0.0.0.0", () => {
  console.log(`Hotel Booking API listening on port ${port}`);
});