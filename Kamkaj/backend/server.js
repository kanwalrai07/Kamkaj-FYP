const express = require('express');
const connectDB = require('./config/db');
const authRouter = require('./routes/authRoutes');

// Initialize Express
const app = express();

// Define Port
const PORT = process.env.PORT || 5000;

// Connect to MongoDB Database
connectDB();

// ------------------------------------
// MIDDLEWARE
// ------------------------------------

// Parse incoming JSON requests
app.use(express.json());

// ------------------------------------
// ROUTES
// ------------------------------------

// Mount the Auth Router
// This adds all routes from authRoutes.js (like /api/signup) to the app
app.use(authRouter);

// Root Endpoint (Sanity Check)
// Note: We avoid conflicting with authRouter's potential routes.
// But it's good to have a simple ping endpoint.
app.get('/ping', (req, res) => {
    res.send('KamKaj Backend is running!');
});

// ------------------------------------
// START SERVER
// ------------------------------------
app.listen(PORT, "0.0.0.0", () => {
    console.log(`Server running at port ${PORT}`);
});
