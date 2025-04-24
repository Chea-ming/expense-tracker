import sqlite3 from 'sqlite3';
import { open } from 'sqlite';

// Create and initialize the database
async function initializeDatabase() {
  const db = await open({
    filename: './expense_tracker.db',
    driver: sqlite3.Database
  });

  // Create USERS table
  await db.exec(`
    CREATE TABLE IF NOT EXISTS USERS (
      ID INTEGER PRIMARY KEY AUTOINCREMENT,
      USERNAME TEXT UNIQUE NOT NULL,
      EMAIL TEXT UNIQUE NOT NULL,
      HASHED_PASS TEXT NOT NULL
    )
  `);

  // Create EXPENSE table
  await db.exec(`
    CREATE TABLE IF NOT EXISTS EXPENSE (
      ID INTEGER PRIMARY KEY AUTOINCREMENT,
      USER_ID INTEGER NOT NULL,
      AMOUNT DECIMAL(10,2) NOT NULL,
      CATEGORY TEXT NOT NULL,
      DATE TEXT NOT NULL,
      NOTES TEXT,
      FOREIGN KEY (USER_ID) REFERENCES USERS(ID)
    )
  `);

  console.log('Database initialized successfully');
  return db;
}

// Export a singleton database instance
let dbInstance = null;

export async function getDb() {
  if (!dbInstance) {
    dbInstance = await initializeDatabase();
  }
  return dbInstance;
}