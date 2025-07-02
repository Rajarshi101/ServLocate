// lib/models/service_model.dart
class ServiceModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final double price;
  final String? imageUrl;
  final String location;
  final String postedBy;
  final DateTime timestamp;

  ServiceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    this.imageUrl,
    required this.location,
    required this.postedBy,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'price': price,
      'imageUrl': imageUrl,
      'location': location,
      'postedBy': postedBy,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      category: map['category'],
      price: map['price'],
      imageUrl: map['imageUrl'],
      location: map['location'],
      postedBy: map['postedBy'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
} 
