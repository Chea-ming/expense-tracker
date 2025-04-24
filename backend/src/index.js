import express from 'express';
import cors from 'cors';
import { getDb } from './db/database.js';
import config from './config/config.js';
import userRoutes from './routes/userRoutes.js';
import expenseRoutes from './routes/expenseRoutes.js';

const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// Initialize database
(async () => {
  try {
    await getDb();
    console.log('Database connected successfully');
  } catch (error) {
    console.error('Database connection error:', error);
    process.exit(1);
  }
})();

// Routes
app.use('/api/users', userRoutes);
app.use('/api/expenses', expenseRoutes);

// Health check route
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'ok' });
});

// Start server
app.listen(config.port, () => {
  console.log(`Server running on port ${config.port}`);
});