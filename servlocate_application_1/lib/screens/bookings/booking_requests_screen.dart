import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/service_model.dart';

class BookingRequestsScreen extends StatelessWidget {
  final String currentUid;
  const BookingRequestsScreen({super.key, required this.currentUid});

  Future<ServiceModel?> _getService(String serviceId) async {
    final doc = await FirebaseFirestore.instance.collection('services').doc(serviceId).get();
    if (doc.exists) {
      return ServiceModel.fromMap(doc.data()!);
    }
    return null;
  }

  Future<void> _updateStatus(String bookingId, String status) async {
    await FirebaseFirestore.instance.collection('bookings').doc(bookingId).update({
      'status': status,
    });
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking Requests')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .where('providerId', isEqualTo: currentUid)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final bookings = snapshot.data!.docs;
          if (bookings.isEmpty) {
            return const Center(child: Text('No booking requests.'));
          }

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              final data = booking.data() as Map<String, dynamic>;
              final status = data['status'];
              final serviceId = data['serviceId'];
              final clientId = data['clientId'];

              return FutureBuilder<ServiceModel?>(
                future: _getService(serviceId),
                builder: (context, snap) {
                  if (!snap.hasData) {
                    return const ListTile(title: Text('Loading...'));
                  }
                  final service = snap.data!;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    child: ListTile(
                      title: Text(service.title),
                      subtitle: Text('Requested by: $clientId'),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _statusColor(status),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              status.toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          if (status == 'pending')
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.check_circle, color: Colors.green),
                                  onPressed: () => _updateStatus(booking.id, 'approved'),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.cancel, color: Colors.red),
                                  onPressed: () => _updateStatus(booking.id, 'rejected'),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
