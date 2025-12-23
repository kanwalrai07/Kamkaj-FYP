const User = require('../models/User');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

// SIGN UP USER
// Route: POST /api/signup
exports.signUpUser = async (req, res) => {
    try {
        const { name, email, password, type } = req.body;

        // Check if a user with this email already exists
        const existingUser = await User.findOne({ email });
        if (existingUser) {
            return res
                .status(400)
                .json({ msg: 'User with same email already exists!' });
        }

        // Hash the password securely
        // 8 is the salt rounds (cost factor)
        const hashedPassword = await bcrypt.hash(password, 8);

        // Create new user model explicitly
        // Logic: Workers might need more fields later, clients fewer.
        let user = new User({
            name,
            email,
            password: hashedPassword,
            type: type || 'client', // Defaults to 'client'
        });

        // Save to MongoDB
        user = await user.save();

        // Create JWT Token for Auto-Login
        const token = jwt.sign({ id: user._id }, 'kamkaj_secret_key');

        // Return token and user data
        res.json({ token, ...user._doc });
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
};

// SIGN IN USER
// Route: POST /api/signin
exports.signInUser = async (req, res) => {
    try {
        const { email, password } = req.body;

        // 1. Find user by email
        const user = await User.findOne({ email });
        if (!user) {
            return res
                .status(400)
                .json({ msg: 'User with this email does not exist!' });
        }

        // 2. Validate password
        // Compare the plain text password with the hashed password in DB
        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) {
            return res.status(400).json({ msg: 'Incorrect password.' });
        }

        // 3. Create JWT Token
        // This token validates the user for future requests
        const token = jwt.sign({ id: user._id }, 'kamkaj_secret_key');

        // 4. Send response with token + user data
        res.json({ token, ...user._doc });
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
};

// CHECK TOKEN VALIDITY
// Route: POST /tokenIsValid
// Useful for frontend to check if user is still logged in on app launch
exports.checkToken = async (req, res) => {
    try {
        const token = req.header('x-auth-token');
        if (!token) return res.json(false);

        const verified = jwt.verify(token, 'kamkaj_secret_key');
        if (!verified) return res.json(false);

        const user = await User.findById(verified.id);
        if (!user) return res.json(false);

        res.json(true);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
};

// GOOGLE SIGN IN
// Route: POST /api/google
exports.googleSignIn = async (req, res) => {
    try {
        const { email, name, type } = req.body;

        // 1. Check if user exists
        let user = await User.findOne({ email });

        if (!user) {
            // 2. If not, create new user
            // We need a password for the model validation, so we generate a random one.
            // The user won't know this password, they just use Google.
            const randomPassword = Math.random().toString(36).slice(-8) + Math.random().toString(36).slice(-8);
            const hashedPassword = await bcrypt.hash(randomPassword, 8);

            user = new User({
                email,
                name,
                password: hashedPassword,
                type: type || 'client',
            });
            user = await user.save();
        }

        // 3. Create JWT Token (Same as signInUser)
        const token = jwt.sign({ id: user._id }, 'kamkaj_secret_key');

        // 4. Send response
        res.json({ token, ...user._doc });

    } catch (e) {
        res.status(500).json({ error: e.message });
    }
};

// GET USER DATA
// Route: GET /
// Middleware 'auth' attaches req.user
exports.getUserData = async (req, res) => {
    try {
        const user = await User.findById(req.user);
        res.json({ ...user._doc, token: req.token });
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
};
