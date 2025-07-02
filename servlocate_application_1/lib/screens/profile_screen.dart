import 'package:flutter/material.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'bookings/provider_booking_requests_screen.dart';
import 'bookings/provider_accepted_bookings_screen.dart';
import 'package:servlocate_application_1/screens/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  final String currentUid;

  const ProfileScreen({super.key, required this.currentUid});

  void _logout(BuildContext context) async {
    await CometChatUIKit.logout();
    if (!context.mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
            const SizedBox(height: 10),
            Text(currentUid, style: const TextStyle(fontSize: 18)),
            const Divider(height: 30),

            ListTile(
              leading: const Icon(Icons.request_page),
              title: const Text('Booking Requests (Provider)'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProviderBookingRequestsScreen(currentUid: currentUid),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.check_circle),
              title: const Text('Accepted Bookings (Provider)'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProviderAcceptedBookingsScreen(currentUid: currentUid),
                  ),
                );
              },
            ),

            const Spacer(),

            ElevatedButton.icon(
              onPressed: () => _logout(context),
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
