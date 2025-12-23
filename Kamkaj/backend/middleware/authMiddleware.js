const jwt = require('jsonwebtoken');

// Middleware to verify JWT token
const auth = async (req, res, next) => {
    try {
        // 1. Get the token from the request header
        // keys are case-insensitive in headers usually, but we standardise on 'x-auth-token'
        const token = req.header('x-auth-token');

        // 2. Check if token exists
        if (!token) {
            return res.status(401).json({ msg: 'No authentication token, access denied.' });
        }

        // 3. Verify the token
        // If verification fails, it throws an error which is caught by catch block
        const verified = jwt.verify(token, 'kamkaj_secret_key');

        if (!verified) {
            return res.status(401).json({ msg: 'Token verification failed, authorization denied.' });
        }

        // 4. Add user ID and token to request object
        // This allows subsequent route handlers to access the logged-in user's ID
        req.user = verified.id;
        req.token = token;

        // 5. Build call the next middleware or route handler
        next();
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

module.exports = auth;
