const mongoose = require('mongoose');

// User Schema for KamKaj App
// Defines the structure of the user document in MongoDB
const userSchema = mongoose.Schema({
    name: {
        type: String,
        required: true,
        trim: true,
    },
    email: {
        type: String,
        required: true,
        unique: true, // Ensure email is unique across the database
        trim: true,
        // Regex for basic email validation
        match: [
            /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/,
            'Please enter a valid email address',
        ],
    },
    password: {
        type: String,
        required: true,
        // Note: This will store the generic hashed password
    },
    address: {
        type: String,
        default: '',
    },
    type: {
        type: String,
        default: 'client', // Default role. Options: 'client', 'worker'
    },
    // Start of Schema
});

const User = mongoose.model('User', userSchema);
module.exports = User;
