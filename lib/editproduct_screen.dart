import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'models/Products.dart';
import 'category_service.dart';
import 'config.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;

  const EditProductScreen({Key? key, required this.product}) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  String? _selectedCategoryId;
  List<Map<String, dynamic>> _categories = [];
  bool _isLoadingCategories = true;
  File? _pickedImage;
  String? _currentImagePath;
  bool _isPickingImage = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _descriptionController =
        TextEditingController(text: widget.product.description);
    _priceController =
        TextEditingController(text: widget.product.price.toString());
    _currentImagePath = widget.product.imagePath ?? '';
    _loadCategories();
  }

  void _loadCategories() async {
    try {
      _categories = await CategoryService.getCategories();
      _selectedCategoryId = widget.product.categoryId.toString();
    } catch (e) {
      // Handle error if needed
    } finally {
      setState(() {
        _isLoadingCategories = false;
      });
    }
  }

  Future<void> _pickImage() async {
    if (_isPickingImage) return;
    setState(() {
      _isPickingImage = true;
    });
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _pickedImage = File(pickedFile.path);
        });
      }
    } finally {
      setState(() {
        _isPickingImage = false;
      });
    }
  }

  Future<void> _updateProduct() async {
    if (_pickedImage != null) {
      // Send as multipart
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${AppConfig.baseUrl}/api/products/${widget.product.id}?_method=PUT'),
      );
      request.fields['name'] = _nameController.text;
      request.fields['description'] = _descriptionController.text;
      request.fields['price'] = _priceController.text;
      request.fields['category_id'] = _selectedCategoryId!;
      request.files
          .add(await http.MultipartFile.fromPath('image', _pickedImage!.path));
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        Navigator.pop(context);
      } else {
        // Handle error
      }
    } else {
      // No new image, send as JSON
      final response = await http.put(
        Uri.parse('${AppConfig.baseUrl}/api/products/${widget.product.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': _nameController.text,
          'description': _descriptionController.text,
          'price': double.parse(_priceController.text),
          'category_id': int.parse(_selectedCategoryId!),
        }),
      );
      if (response.statusCode == 200) {
        Navigator.pop(context);
      } else {
        // Handle error
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product',
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold)),
        backgroundColor: theme.colorScheme.primary,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: _pickedImage != null
                          ? Image.file(_pickedImage!,
                              height: 140, width: 140, fit: BoxFit.cover)
                          : (_currentImagePath != null &&
                                  _currentImagePath!.isNotEmpty)
                              ? Image.network(
                                  '${AppConfig.baseUrl}/storage/$_currentImagePath',
                                  height: 140,
                                  width: 140,
                                  fit: BoxFit.cover)
                              : Image.asset('assets/product_placeholder.png',
                                  height: 140, width: 140, fit: BoxFit.cover),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Material(
                        color: theme.colorScheme.primary,
                        shape: CircleBorder(),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap: _pickImage,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.camera_alt,
                                color: Colors.white, size: 22),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Product Name',
                  prefixIcon: Icon(Icons.label_outline),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              SizedBox(height: 14),
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description',
                  prefixIcon: Icon(Icons.description_outlined),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              SizedBox(height: 14),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Price',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 14),
              _isLoadingCategories
                  ? Center(child: CircularProgressIndicator())
                  : DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Category',
                        prefixIcon: Icon(Icons.category_outlined),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      value: _selectedCategoryId,
                      items: _categories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category['id'].toString(),
                          child: Text(category['name']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategoryId = value;
                        });
                      },
                    ),
              SizedBox(height: 28),
              ElevatedButton.icon(
                onPressed: _updateProduct,
                icon: Icon(Icons.save),
                label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text('Update', style: TextStyle(fontSize: 16)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
