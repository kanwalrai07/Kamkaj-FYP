const express = require('express');
const jobRouter = express.Router();
const jobController = require('../controllers/jobController');
const auth = require('../middleware/authMiddleware');

// Create a Job (Client only)
// TODO: Could add role check middleware here
jobRouter.post('/api/jobs/create', auth, jobController.createJob);

// Get Client's posted jobs
jobRouter.get('/api/jobs/client', auth, jobController.getClientJobs);

// Get Open jobs for Workers
jobRouter.get('/api/jobs/open', auth, jobController.getOpenJobs);

// Delete Job
jobRouter.delete('/api/jobs/:id', auth, jobController.deleteJob);

// Update Job
jobRouter.put('/api/jobs/:id', auth, jobController.updateJob);

// Place a Bid on a job (Worker only)
jobRouter.post('/api/jobs/:id/bid', auth, jobController.placeBid);

module.exports = jobRouter;
