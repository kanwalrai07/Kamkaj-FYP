const mongoose = require('mongoose');

// Function to connect to MongoDB
// This function handles the connection logic to the MongoDB database
const connectDB = async () => {
    try {
        // DB URI - Placeholder
        // TODO: Replace 'mongodb://localhost:27017/kamkaj' with your actual MongoDB Atlas connection string if deploying
        // For local development, this assumes you have MongoDB running locally
        const dbURI = 'mongodb://localhost:27017/kamkaj';

        // Connect to MongoDB using Mongoose
        await mongoose.connect(dbURI);

        console.log('MongoDB Connected successfully');
    } catch (error) {
        console.error('MongoDB connection failed:', error.message);
        // Exit process with failure code 1 if connection fails
        process.exit(1);
    }
};

module.exports = connectDB;
