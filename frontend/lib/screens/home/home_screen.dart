import 'package:flutter/material.dart';
import 'package:frontend/screens/auth/login_screen.dart';
import 'package:frontend/screens/expense/add_expense_screen.dart';
import 'package:frontend/screens/home/tabs/analytics_tab.dart';
import 'package:frontend/screens/home/tabs/dashboard_tab.dart';
import 'package:frontend/screens/home/tabs/expenses_tab.dart';
import 'package:frontend/screens/home/tabs/profile_tab.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/services/expense_service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  // List of tabs
  final List<Widget> _tabs = [
    const DashboardTab(),
    const ExpensesTab(),
    const AnalyticsTab(),
    const ProfileTab(),
  ];
  
  @override
  void initState() {
    super.initState();
    // Fetch expenses when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ExpenseService>(context, listen: false).fetchExpenses();
    });
  }
  
  // Handle logout
  Future<void> _logout() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    await authService.logout();
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          // Logout button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      // Show current tab
      body: _tabs[_currentIndex],
      // Floating action button for adding expenses
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const AddExpenseScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
