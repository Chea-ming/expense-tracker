# Personal Expense Tracker App

A comprehensive mobile application for tracking daily expenses, organizing them by categories, and visualizing monthly spending analytics.

[![Flutter](https://img.shields.io/badge/Flutter-3.24-blue?logo=flutter)](https://flutter.dev)
[![Node.js](https://img.shields.io/badge/Node.js-20-green?logo=node.js)](https://nodejs.org)
[![Express.js](https://img.shields.io/badge/Express.js-4.x-black?logo=express)](https://expressjs.com)
[![SQLite](https://img.shields.io/badge/SQLite-3-blue?logo=sqlite)](https://www.sqlite.org)
[![License](https://img.shields.io/badge/License-MIT-yellow)](LICENSE)

## Features

- **User Authentication**: Secure JWT-based login and registration.
- **Expense Tracking**: Add, edit, delete, and categorize expenses.
- **Monthly View**: Grid-based view of daily spending for selected months.
- **Analytics**: Visualize expense distribution by category.
- **Responsive UI**: Intuitive and user-friendly interface built with Flutter.

## Tech Stack

### Frontend
- **Framework**: [Flutter 3.24](https://flutter.dev)
- **State Management**: [Provider](https://pub.dev/packages/provider)
- **HTTP Client**: [Dio](https://pub.dev/packages/dio)
- **Storage**: [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage), [Shared Preferences](https://pub.dev/packages/shared_preferences)

### Backend
- **Framework**: [Express.js](https://expressjs.com) on [Node.js 20](https://nodejs.org)
- **Authentication**: [JWT (jsonwebtoken)](https://www.npmjs.com/package/jsonwebtoken)
- **Database**: [SQLite3](https://www.sqlite.org)
- **Password Hashing**: [bcrypt](https://www.npmjs.com/package/bcrypt)

## Project Structure

```
expense-tracker/
├── backend/           # Node.js Express backend
├── frontend/          # Flutter mobile app
├── docs/
│   ├── backend.md     # Backend setup instructions
│   └── frontend.md    # Frontend setup instructions
└── README.md          # Project overview
```

## Getting Started

### Prerequisites
- [Node.js 20.x](https://nodejs.org/en/download)
- [Flutter 3.24](https://flutter.dev/docs/get-started/install)
- [Git](https://git-scm.com/downloads)

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/expense-tracker.git
   cd expense-tracker
   ```

2. **Set up the backend**:
   ```bash
   cd backend
   npm install
   npm run dev
   ```
   The backend server will run on `http://localhost:3000`.

3. **Set up the frontend**:
   ```bash
   cd ../frontend/expense_tracker
   flutter pub get
   flutter run
   ```

## API Endpoints

### Authentication
- `POST /api/users/register` - Register a new user
- `POST /api/users/login` - Log in a user
- `GET /api/users/profile` - Fetch the authenticated user's profile

### Expenses
- `GET /api/expenses` - Retrieve all expenses for the authenticated user
- `POST /api/expenses` - Create a new expense
- `GET /api/expenses/:id` - Retrieve a specific expense
- `PUT /api/expenses/:id` - Update an existing expense
- `DELETE /api/expenses/:id` - Delete an expense

## License

This project is licensed under the [MIT License](LICENSE).

## Acknowledgments

- [Flutter](https://flutter.dev)
- [Node.js](https://nodejs.org)
- [Express.js](https://expressjs.com)
- [SQLite](https://www.sqlite.org)
