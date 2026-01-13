const mongoose = require('mongoose');

const jobSchema = new mongoose.Schema({
    title: {
        type: String,
        required: true,
        trim: true,
    },
    description: {
        type: String,
        required: true,
    },
    location: {
        type: String,
        required: true,
    },
    category: {
        type: String,
        required: true,
    },
    budget: {
        type: Number,
        required: true,
    },
    clientId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true,
    },
    status: {
        type: String,
        enum: ['OPEN', 'ASSIGNED', 'COMPLETED'],
        default: 'OPEN',
    },
    createdAt: {
        type: Date,
        default: Date.now,
    },
    bids: [{
        workerId: {
            type: mongoose.Schema.Types.ObjectId,
            ref: 'User',
            required: true
        },
        amount: {
            type: Number,
            required: true
        },
        status: {
            type: String,
            enum: ['PENDING', 'ACCEPTED', 'REJECTED'],
            default: 'PENDING'
        },
        createdAt: {
            type: Date,
            default: Date.now
        }
    }]
});

const Job = mongoose.model('Job', jobSchema);

module.exports = Job;
