import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';

class ProviderAcceptedBookingsScreen extends StatelessWidget {
  final String currentUid;

  const ProviderAcceptedBookingsScreen({super.key, required this.currentUid});

  void _startChat(BuildContext context, String clientId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        // builder: (_) => CometChatMessages(
        //   user: User(uid: clientId, name: "Client"),
        // ),
        builder: (_) => WillPopScope(
          onWillPop: () async {
            Navigator.pop(context); // Prevent screen blackout
            return false;
          },
          child: CometChatMessages(
            user: User(uid: clientId, name: "Client"),
          ),
        ),
      
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Accepted Bookings')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .where('providerId', isEqualTo: currentUid)
            .where('status', isEqualTo: 'accepted')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final bookings = snapshot.data!.docs;

          if (bookings.isEmpty) return const Center(child: Text('No accepted bookings.'));

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              final paid = booking['paid'] ?? false;

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text('Service ID: ${booking['serviceId']}'),
                  subtitle: Text('Client ID: ${booking['clientId']}\nPaid: ${paid ? "Yes" : "No"}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.chat),
                    onPressed: () => _startChat(context, booking['clientId']),
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
