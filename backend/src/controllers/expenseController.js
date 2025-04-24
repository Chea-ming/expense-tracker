import { getDb } from '../db/database.js';

// Create a new expense
export const createExpense = async (req, res) => {
  try {
    const { amount, category, date, notes } = req.body;
    const userId = req.userId; // From auth middleware
    
    if (!amount || !category || !date) {
      return res.status(400).json({ message: 'Amount, category, and date are required' });
    }
    
    const db = await getDb();
    
    const result = await db.run(
      'INSERT INTO EXPENSE (USER_ID, AMOUNT, CATEGORY, DATE, NOTES) VALUES (?, ?, ?, ?, ?)',
      [userId, amount, category, date, notes || '']
    );
    
    res.status(201).json({
      message: 'Expense created successfully',
      expense: {
        id: result.lastID,
        userId,
        amount,
        category,
        date,
        notes: notes || ''
      }
    });
  } catch (error) {
    console.error('Create expense error:', error);
    res.status(500).json({ message: 'Server error' });
  }
};

// Get all expenses for a user
export const getExpenses = async (req, res) => {
  try {
    const userId = req.userId; // From auth middleware
    const { month, year } = req.query;
    
    const db = await getDb();
    
    let query = 'SELECT * FROM EXPENSE WHERE USER_ID = ?';
    let params = [userId];
    
    // Filter by month and year if provided
    if (month && year) {
      // SQLite date filtering
      const startDate = `${year}-${month.padStart(2, '0')}-01`;
      const endMonth = parseInt(month) === 12 ? 1 : parseInt(month) + 1;
      const endYear = parseInt(month) === 12 ? parseInt(year) + 1 : parseInt(year);
      const endDate = `${endYear}-${endMonth.toString().padStart(2, '0')}-01`;
      
      query += ' AND DATE >= ? AND DATE < ?';
      params.push(startDate, endDate);
    }
    
    query += ' ORDER BY DATE DESC';
    
    const expenses = await db.all(query, params);
    
    res.status(200).json({ expenses });
  } catch (error) {
    console.error('Get expenses error:', error);
    res.status(500).json({ message: 'Server error' });
  }
};

// Get expense by ID
export const getExpenseById = async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.userId; // From auth middleware
    
    const db = await getDb();
    
    const expense = await db.get(
      'SELECT * FROM EXPENSE WHERE ID = ? AND USER_ID = ?',
      [id, userId]
    );
    
    if (!expense) {
      return res.status(404).json({ message: 'Expense not found' });
    }
    
    res.status(200).json({ expense });
  } catch (error) {
    console.error('Get expense by ID error:', error);
    res.status(500).json({ message: 'Server error' });
  }
};

// Update expense
export const updateExpense = async (req, res) => {
  try {
    const { id } = req.params;
    const { amount, category, date, notes } = req.body;
    const userId = req.userId; // From auth middleware
    
    if (!amount && !category && !date && notes === undefined) {
      return res.status(400).json({ message: 'At least one field is required to update' });
    }
    
    const db = await getDb();
    
    // Check if expense exists and belongs to user
    const existingExpense = await db.get(
      'SELECT * FROM EXPENSE WHERE ID = ? AND USER_ID = ?',
      [id, userId]
    );
    
    if (!existingExpense) {
      return res.status(404).json({ message: 'Expense not found' });
    }
    
    // Update fields
    const updatedAmount = amount || existingExpense.AMOUNT;
    const updatedCategory = category || existingExpense.CATEGORY;
    const updatedDate = date || existingExpense.DATE;
    const updatedNotes = notes !== undefined ? notes : existingExpense.NOTES;
    
    await db.run(
      'UPDATE EXPENSE SET AMOUNT = ?, CATEGORY = ?, DATE = ?, NOTES = ? WHERE ID = ? AND USER_ID = ?',
      [updatedAmount, updatedCategory, updatedDate, updatedNotes, id, userId]
    );
    
    res.status(200).json({
      message: 'Expense updated successfully',
      expense: {
        id: parseInt(id),
        userId,
        amount: updatedAmount,
        category: updatedCategory,
        date: updatedDate,
        notes: updatedNotes
      }
    });
  } catch (error) {
    console.error('Update expense error:', error);
    res.status(500).json({ message: 'Server error' });
  }
};

// Delete expense
export const deleteExpense = async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.userId; // From auth middleware
    
    const db = await getDb();
    
    // Check if expense exists and belongs to user
    const existingExpense = await db.get(
      'SELECT * FROM EXPENSE WHERE ID = ? AND USER_ID = ?',
      [id, userId]
    );
    
    if (!existingExpense) {
      return res.status(404).json({ message: 'Expense not found' });
    }
    
    await db.run(
      'DELETE FROM EXPENSE WHERE ID = ? AND USER_ID = ?',
      [id, userId]
    );
    
    res.status(200).json({ message: 'Expense deleted successfully' });
  } catch (error) {
    console.error('Delete expense error:', error);
    res.status(500).json({ message: 'Server error' });
  }
};