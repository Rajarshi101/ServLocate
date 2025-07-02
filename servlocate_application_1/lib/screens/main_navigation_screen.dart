import 'package:flutter/material.dart';
import 'package:servlocate_application_1/screens/services/service_explorer_screen.dart';
import 'package:servlocate_application_1/screens/bookings/booking_history_screen.dart';
import 'package:servlocate_application_1/screens/profile_screen.dart';
import 'package:servlocate_application_1/screens/inbox_screen.dart';
import 'package:servlocate_application_1/screens/services/post_service_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final String currentUid;

  const MainNavigationScreen({super.key, required this.currentUid});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      ServiceExplorerScreen(currentUid: widget.currentUid),
      BookingHistoryScreen(currentUid: widget.currentUid),
      PostServiceScreen(currentUid: widget.currentUid),
      InboxScreen(currentUid: widget.currentUid),
      ProfileScreen(currentUid: widget.currentUid),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Post'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Inbox'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
