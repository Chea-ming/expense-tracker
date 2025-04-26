# Personal Expense Tracker App

A comprehensive mobile application that allows users to track daily expenses, organize them into categories, and view monthly analytics.

## Features

- **User Authentication**: Secure JWT-based authentication
- **Expense Tracking**: Add, edit, and delete expenses with categories
- **Monthly View**: Grid view showing daily spending for selected months
- **Analytics**: View expense distribution by category
- **Responsive UI**: User-friendly interface built with Flutter

## Tech Stack

### Frontend
- **Framework**: Flutter 3.24
- **State Management**: Provider
- **HTTP Client**: Dio
- **Storage**: Flutter Secure Storage, Shared Preferences

### Backend
- **Framework**: Express.js on Node.js 20
- **Authentication**: JWT (jsonwebtoken)
- **Database**: SQLite3
- **Password Hashing**: bcrypt

### Prerequisites

- Node.js 20.x
- Flutter 3.24
- Git

### Quick Start

1. Clone the repository:
   \`\`\`bash
   git clone https://github.com/yourusername/expense-tracker.git
   cd expense-tracker
   \`\`\`

2. Set up the backend:
   \`\`\`bash
   cd backend
   npm install
   npm run dev
   \`\`\`
   The backend server will start on http://localhost:3000

3. Set up the frontend:
   \`\`\`bash
   cd ../frontend/expense_tracker
   flutter pub get
   flutter run
   \`\`\`

For detailed setup instructions, see:
- [Backend Setup](docs/backend.md)
- [Frontend Setup](docs/frontend.md)

## API Endpoints

### Authentication
- `POST /api/users/register` - Register a new user
- `POST /api/users/login` - Login a user

### Expenses
- `GET /api/expenses` - Get all expenses for the authenticated user
- `POST /api/expenses` - Create a new expense
- `GET /api/expenses/:id` - Get a specific expense
- `PUT /api/expenses/:id` - Update an expense
- `DELETE /api/expenses/:id` - Delete an expense

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- [Flutter](https://flutter.dev/)
- [Node.js](https://nodejs.org/)
- [Express.js](https://expressjs.com/)
- [SQLite](https://www.sqlite.org/)
\`\`\`

