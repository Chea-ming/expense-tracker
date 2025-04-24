import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import { getDb } from '../db/database.js';
import config from '../config/config.js';

// Register a new user
export const register = async (req, res) => {
  try {
    const { username, email, password } = req.body;
    
    if (!username || !email || !password) {
      return res.status(400).json({ message: 'All fields are required' });
    }
    
    const db = await getDb();
    
    // Check if user already exists
    const existingUser = await db.get('SELECT * FROM USERS WHERE EMAIL = ?', [email]);
    if (existingUser) {
      return res.status(400).json({ message: 'User already exists' });
    }
    
    // Hash password
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);
    
    // Insert new user
    const result = await db.run(
      'INSERT INTO USERS (USERNAME, EMAIL, HASHED_PASS) VALUES (?, ?, ?)',
      [username, email, hashedPassword]
    );
    
    // Generate JWT token
    const token = jwt.sign({ id: result.lastID }, config.jwtSecret, {
      expiresIn: config.jwtExpiration
    });
    
    res.status(201).json({
      message: 'User registered successfully',
      token,
      user: {
        id: result.lastID,
        username,
        email
      }
    });
  } catch (error) {
    console.error('Registration error:', error);
    res.status(500).json({ message: 'Server error' });
  }
};

// Login user
export const login = async (req, res) => {
  try {
    const { email, password } = req.body;
    
    if (!email || !password) {
      return res.status(400).json({ message: 'Email and password are required' });
    }
    
    const db = await getDb();
    
    // Find user by email
    const user = await db.get('SELECT * FROM USERS WHERE EMAIL = ?', [email]);
    if (!user) {
      return res.status(401).json({ message: 'Invalid credentials' });
    }
    
    // Verify password
    const isPasswordValid = await bcrypt.compare(password, user.HASHED_PASS);
    if (!isPasswordValid) {
      return res.status(401).json({ message: 'Invalid credentials' });
    }
    
    // Generate JWT token
    const token = jwt.sign({ id: user.ID }, config.jwtSecret, {
      expiresIn: config.jwtExpiration
    });
    
    res.status(200).json({
      message: 'Login successful',
      token,
      user: {
        id: user.ID,
        username: user.USERNAME,
        email: user.EMAIL
      }
    });
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({ message: 'Server error' });
  }
};