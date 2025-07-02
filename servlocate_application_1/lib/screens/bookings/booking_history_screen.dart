import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookingHistoryScreen extends StatelessWidget {
  final String currentUid;

  const BookingHistoryScreen({super.key, required this.currentUid});

  Stream<List<Map<String, dynamic>>> _getBookings() async* {
    final bookingsStream = FirebaseFirestore.instance
        .collection('bookings')
        .where('clientId', isEqualTo: currentUid)
        .snapshots();

    await for (final snapshot in bookingsStream) {
      List<Map<String, dynamic>> bookings = [];

      for (final bookingDoc in snapshot.docs) {
        final bookingData = bookingDoc.data();
        final serviceId = bookingData['serviceId'];

        if (serviceId != null) {
          final serviceSnapshot = await FirebaseFirestore.instance
              .collection('services')
              .doc(serviceId)
              .get();

          if (serviceSnapshot.exists) {
            final serviceData = serviceSnapshot.data();
            if (serviceData != null) {
              bookings.add({
                'bookingId': bookingDoc.id,
                'status': bookingData['status'],
                'timestamp': bookingData['timestamp'],
                'service': serviceData,
              });
            }
          }
        }
      }

      yield bookings;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings')),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _getBookings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No bookings found.'));
          }

          final bookings = snapshot.data!;

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              final service = booking['service'];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(service['title'] ?? 'Unknown Service'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Category: ${service['category']}'),
                      Text('Status: ${booking['status']}'),
                      Text('Date: ${booking['timestamp'].toString().split('T').first}'),
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
