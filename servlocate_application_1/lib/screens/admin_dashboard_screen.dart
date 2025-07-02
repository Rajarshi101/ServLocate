import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/service_model.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  Future<ServiceModel?> _getService(String id) async {
    final doc = await FirebaseFirestore.instance.collection('services').doc(id).get();
    if (doc.exists) {
      return ServiceModel.fromMap(doc.data()!);
    }
    return null;
  }

  Widget _statusChip(String status) {
    final color = {
      'approved': Colors.green,
      'pending': Colors.orange,
      'rejected': Colors.red,
    }[status] ?? Colors.grey;

    return Chip(
      label: Text(status.toUpperCase()),
      backgroundColor: color,
      labelStyle: const TextStyle(color: Colors.white),
    );
  }

  Future<Map<String, int>> _getAnalytics() async {
    final snapshot = await FirebaseFirestore.instance.collection('bookings').get();
    int total = snapshot.docs.length;
    int paid = snapshot.docs.where((doc) => doc['paid'] == true).length;
    return {'total': total, 'paid': paid};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: Column(
        children: [
          FutureBuilder<Map<String, int>>(
            future: _getAnalytics(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const LinearProgressIndicator();
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Total Bookings: ${snapshot.data!['total']}", style: const TextStyle(fontSize: 16)),
                    Text("Paid: ${snapshot.data!['paid']}", style: const TextStyle(fontSize: 16)),
                  ],
                ),
              );
            },
          ),
          const Divider(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('bookings').orderBy('timestamp', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final bookings = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final data = bookings[index].data() as Map<String, dynamic>;
                    final status = data['status'];
                    final paid = data['paid'] == true;
                    final serviceId = data['serviceId'];

                    return FutureBuilder<ServiceModel?>(
                      future: _getService(serviceId),
                      builder: (context, serviceSnap) {
                        if (!serviceSnap.hasData) return const ListTile(title: Text('Loading service...'));
                        final service = serviceSnap.data!;

                        return ListTile(
                          title: Text(service.title),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Client: ${data['clientId']}'),
                              Text('Provider: ${data['providerId']}'),
                            ],
                          ),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _statusChip(status),
                              if (paid)
                                const Text("PAID", style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
