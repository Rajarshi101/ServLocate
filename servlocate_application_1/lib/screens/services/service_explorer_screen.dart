import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/service_model.dart';
import 'service_details_screen.dart';

class ServiceExplorerScreen extends StatefulWidget {
  final String currentUid;
  const ServiceExplorerScreen({super.key, required this.currentUid});

  @override
  State<ServiceExplorerScreen> createState() => _ServiceExplorerScreenState();
}

class _ServiceExplorerScreenState extends State<ServiceExplorerScreen> {
  String selectedCategory = 'All';
  final List<String> categories = [
    'All', 'Cleaning', 'Teaching', 'Beauty', 'Pet Care',
    'Electrical', 'Babysitting', 'Health', 'Tech Support'
  ];

  Stream<List<ServiceModel>> _getServices() {
    final query = FirebaseFirestore.instance.collection('services');
    return (selectedCategory == 'All'
        ? query.snapshots()
        : query.where('category', isEqualTo: selectedCategory).snapshots())
        .map((snapshot) {
      return snapshot.docs.map((doc) => ServiceModel.fromMap(doc.data())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isSelected = cat == selectedCategory;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (_) => setState(() => selectedCategory = cat),
                  ),
                );
              },
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<List<ServiceModel>>(
            stream: _getServices(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final services = snapshot.data!;

              if (services.isEmpty) {
                return const Center(child: Text('No services found in this category.'));
              }

              return ListView.builder(
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: ListTile(
                      leading: Image.network(
                        service.imageUrl ?? '',
                        width: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 40),
                      ),
                      title: Text(service.title),
                      subtitle: Text('${service.category} • ₹${service.price}/hr'),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ServiceDetailsScreen(
                            service: service,
                            currentUid: widget.currentUid,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
