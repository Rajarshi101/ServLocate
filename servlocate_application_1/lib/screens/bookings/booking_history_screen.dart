import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../mock_payment_screen.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';

class BookingHistoryScreen extends StatelessWidget {
  final String currentUid;

  const BookingHistoryScreen({super.key, required this.currentUid});

  void _markAsCompleted(BuildContext context, String bookingId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MockPaymentScreen(bookingId: bookingId),
      ),
    );
  }

  void _startChat(BuildContext context, String providerId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        // builder: (_) => CometChatMessages(
        //   user: User(uid: providerId, name: "Provider"),
        // ),
        builder: (_) => WillPopScope(
            onWillPop: () async {
              Navigator.pop(context); // Prevent screen blackout
              return false;
            },
            child: CometChatMessages(
              user: User(uid: providerId, name: "Provider"),
            ),
          ),
      
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .where('clientId', isEqualTo: currentUid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final bookings = snapshot.data!.docs;

          if (bookings.isEmpty) return const Center(child: Text('No bookings found.'));

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              final status = booking['status'];
              final paid = booking['paid'] ?? false;

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text('Service ID: ${booking['serviceId']}'),
                  subtitle: Text('Status: $status\nPaid: ${paid ? "Yes" : "No"}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (status == 'accepted' && !paid)
                        IconButton(
                          icon: const Icon(Icons.payment),
                          onPressed: () => _markAsCompleted(context, booking.id),
                        ),
                      IconButton(
                        icon: const Icon(Icons.chat),
                        onPressed: () => _startChat(context, booking['providerId']),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
