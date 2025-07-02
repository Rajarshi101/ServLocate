import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/service_model.dart';
import 'package:uuid/uuid.dart';
import '../main_navigation_screen.dart';

class PostServiceScreen extends StatefulWidget {
  final String currentUid;
  const PostServiceScreen({super.key, required this.currentUid});

  @override
  State<PostServiceScreen> createState() => _PostServiceScreenState();
}

class _PostServiceScreenState extends State<PostServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  String selectedCategory = 'Teaching';
  File? _pickedImage;
  bool _isUploading = false;

  final List<String> categories = [
    'Teaching', 'Cleaning', 'Beauty', 'Electrical', 'Pet Sitting',
    'Babysitting', 'Healthcare', 'Caretaking', 'Tech Support', 'Others'
  ];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isUploading = true);

    try {
      final serviceId = const Uuid().v4();
      String? imageUrl;

      if (_pickedImage != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('service_images/$serviceId.jpg');
        await ref.putFile(_pickedImage!);
        imageUrl = await ref.getDownloadURL();
      }

      final service = ServiceModel(
        id: serviceId,
        title: titleController.text.trim(),
        description: descController.text.trim(),
        category: selectedCategory,
        price: double.parse(priceController.text.trim()),
        imageUrl: imageUrl ?? '',
        location: locationController.text.trim(),
        postedBy: widget.currentUid,
        timestamp: DateTime.now(),
      );

      await FirebaseFirestore.instance
          .collection('services')
          .doc(serviceId)
          .set(service.toMap());

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Service posted successfully!')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MainNavigationScreen(currentUid: widget.currentUid),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to post service: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post a Service')),
      body: _isUploading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: _pickedImage != null
                          ? Image.file(_pickedImage!,
                              height: 150, width: 150, fit: BoxFit.cover)
                          : Container(
                              height: 150,
                              width: 150,
                              color: Colors.grey[300],
                              child: const Icon(Icons.camera_alt, size: 40),
                            ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Enter title' : null,
                    ),
                    TextFormField(
                      controller: descController,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      validator: (val) => val == null || val.isEmpty
                          ? 'Enter description'
                          : null,
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      items: categories
                          .map((e) =>
                              DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) => setState(() => selectedCategory = val!),
                    ),
                    TextFormField(
                      controller: priceController,
                      decoration:
                          const InputDecoration(labelText: 'Price (₹)'),
                      keyboardType: TextInputType.number,
                      validator: (val) => val == null || val.isEmpty
                          ? 'Enter price'
                          : null,
                    ),
                    TextFormField(
                      controller: locationController,
                      decoration:
                          const InputDecoration(labelText: 'Location'),
                      validator: (val) => val == null || val.isEmpty
                          ? 'Enter location'
                          : null,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
