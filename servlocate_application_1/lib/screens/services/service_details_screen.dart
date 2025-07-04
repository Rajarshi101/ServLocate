import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import '../../models/service_model.dart';

class ServiceDetailsScreen extends StatelessWidget {
  final ServiceModel service;
  final String currentUid;

  const ServiceDetailsScreen({super.key, required this.service, required this.currentUid});

  Future<void> _bookService(BuildContext context) async {
    await FirebaseFirestore.instance.collection('bookings').add({
      'serviceId': service.id,
      'clientId': currentUid,
      'providerId': service.postedBy,
      'status': 'pending',
      'timestamp': DateTime.now().toIso8601String(),
      'paid': false,
    });

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Booking request sent.')),
    );
  }

  void _startChat(BuildContext context) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (_) => const CometChatConversationsWithMessages(),
    //   ),
    // );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WillPopScope(
          onWillPop: () async {
            Navigator.pop(context);
            return false;
          },
          child: const CometChatConversationsWithMessages(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = service.toMap()['imageUrl'];

    return Scaffold(
      appBar: AppBar(title: Text(service.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null)
              Image.network(imageUrl, height: 200, width: double.infinity, fit: BoxFit.cover),
            const SizedBox(height: 16),
            Text(service.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(service.description),
            const SizedBox(height: 8),
            Text('Category: ${service.category}'),
            Text('Location: ${service.location}'),
            Text('Price: ₹${service.price.toStringAsFixed(0)}'),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.message),
                    label: const Text('Contact Provider'),
                    onPressed: () => _startChat(context),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.book_online),
                    label: const Text('Book Now'),
                    onPressed: () => _bookService(context),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
