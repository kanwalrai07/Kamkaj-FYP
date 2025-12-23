const express = require('express');
const authRouter = express.Router();
const authController = require('../controllers/authController');
const auth = require('../middleware/authMiddleware');

// ------------------------------------
// AUTHENTICATION ROUTES
// ------------------------------------

// Sign Up Route
// Body: { name, email, password, type }
authRouter.post('/api/signup', authController.signUpUser);

// Sign In Route
// Body: { email, password }
authRouter.post('/api/signin', authController.signInUser);

// Google Sign In Route
// Body: { email, name, type }
authRouter.post('/api/google', authController.googleSignIn);

// Check Token Validity Route
// Header: x-auth-token
authRouter.post('/tokenIsValid', authController.checkToken);

// Get User Data Route
// Header: x-auth-token
// Protected by 'auth' middleware
authRouter.get('/', auth, authController.getUserData);

module.exports = authRouter;
