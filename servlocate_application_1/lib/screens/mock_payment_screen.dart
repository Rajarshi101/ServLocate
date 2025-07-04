import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MockPaymentScreen extends StatefulWidget {
  final String bookingId;
  const MockPaymentScreen({super.key, required this.bookingId});

  @override
  State<MockPaymentScreen> createState() => _MockPaymentScreenState();
}

class _MockPaymentScreenState extends State<MockPaymentScreen> {
  final cardController = TextEditingController();
  final cvvController = TextEditingController();
  final nameController = TextEditingController();

  Future<void> _processPayment() async {
    await FirebaseFirestore.instance.collection('bookings').doc(widget.bookingId).update({
      'paid': true,
      'status': 'completed',
      'paymentTimestamp': DateTime.now().toIso8601String(),
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment Successful')),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    cardController.dispose();
    cvvController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mock Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Enter Card Details", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name on Card'),
            ),
            TextField(
              controller: cardController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Card Number'),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: cvvController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'CVV'),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(labelText: 'Expiry (MM/YY)'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.payment),
                label: const Text('Pay Now'),
                onPressed: _processPayment,
              ),
            )
          ],
        ),
      ),
    );
  }
}
