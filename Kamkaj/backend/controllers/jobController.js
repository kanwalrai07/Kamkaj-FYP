const Job = require('../models/Job');

exports.createJob = async (req, res) => {
    try {
        const { title, description, location, category, budget } = req.body;

        // req.user is added by auth middleware
        const clientId = req.user;

        // Basic Validation
        if (!title || !description || !location || !category || !budget) {
            return res.status(400).json({ msg: 'Please enter all fields' });
        }

        const newJob = new Job({
            title,
            description,
            location,
            category,
            budget,
            clientId,
        });

        const savedJob = await newJob.save();
        res.json(savedJob);

    } catch (err) {
        console.error(err.message);
        res.status(500).json({ error: err.message });
    }
};

// Get jobs posted by the logged-in client
exports.getClientJobs = async (req, res) => {
    try {
        const jobs = await Job.find({ clientId: req.user }).sort({ createdAt: -1 });
        res.json(jobs);
    } catch (err) {
        console.error(err.message);
        res.status(500).json({ error: err.message });
    }
};

// Get all OPEN jobs for workers to see
exports.getOpenJobs = async (req, res) => {
    try {
        // Optionally we can filter by category here too
        const jobs = await Job.find({ status: 'OPEN' }).sort({ createdAt: -1 });
        res.json(jobs);
    } catch (err) {
        console.error(err.message);
        res.status(500).json({ error: err.message });
    }
};

// Delete a Job
exports.deleteJob = async (req, res) => {
    try {
        const job = await Job.findById(req.params.id);

        if (!job) {
            return res.status(404).json({ msg: 'Job not found' });
        }

        // Check if user owns the job
        if (job.clientId.toString() !== req.user) {
            return res.status(401).json({ msg: 'User not authorized' });
        }

        await job.deleteOne();
        res.json({ msg: 'Job removed' });
    } catch (err) {
        console.error(err.message);
        if (err.kind === 'ObjectId') {
            return res.status(404).json({ msg: 'Job not found' });
        }
        res.status(500).json({ error: 'Server Error' });
    }
};

// Update a Job
exports.updateJob = async (req, res) => {
    try {
        const { title, description, location, category, budget, status } = req.body;

        // Build job object
        const jobFields = {};
        if (title) jobFields.title = title;
        if (description) jobFields.description = description;
        if (location) jobFields.location = location;
        if (category) jobFields.category = category;
        if (budget) jobFields.budget = budget;
        if (status) jobFields.status = status;

        let job = await Job.findById(req.params.id);

        if (!job) return res.status(404).json({ msg: 'Job not found' });

        // Make sure user owns job
        if (job.clientId.toString() !== req.user) {
            return res.status(401).json({ msg: 'Not authorized' });
        }

        job = await Job.findByIdAndUpdate(
            req.params.id,
            { $set: jobFields },
            { new: true }
        );

        res.json(job);
    } catch (err) {
        console.error(err.message);
        res.status(500).json({ error: 'Server Error' });
    }
};

// Place a Bid on a Job
exports.placeBid = async (req, res) => {
    try {
        const { amount } = req.body;
        const jobId = req.params.id;
        const workerId = req.user; // From auth middleware

        if (!amount) {
            return res.status(400).json({ msg: 'Bid amount is required' });
        }

        const job = await Job.findById(jobId);
        if (!job) {
            return res.status(404).json({ msg: 'Job not found' });
        }

        // Check if user is the owner (Client cannot bid on their own job)
        if (job.clientId.toString() === workerId) {
            return res.status(400).json({ msg: 'You cannot bid on your own job' });
        }

        // Check if worker already bid
        const existingBid = job.bids.find(bid => bid.workerId.toString() === workerId);
        if (existingBid) {
            return res.status(400).json({ msg: 'You have already placed a bid on this job' });
        }

        // Add bid
        job.bids.push({
            workerId,
            amount
        });

        await job.save();
        res.json(job);

    } catch (err) {
        console.error(err.message);
        res.status(500).json({ error: 'Server Error' });
    }
};
