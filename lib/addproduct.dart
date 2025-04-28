import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'language_model.dart';
import 'background_model.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'category_service.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddProductScreenState createState() => _AddProductScreenState();
}

// 👈 for kIsWeb

class AddProductService {
  static Future<bool> addProduct({
    required String name,
    required String description,
    required String price,
    required int categoryId,
    File? imageFile,
    Uint8List? webImageBytes,
    String? webImageName, // 👈
  }) async {
    final url = Uri.parse('http://127.0.0.1:8000/api/products');

    var request = http.MultipartRequest('POST', url);
    request.fields['name'] = name;
    request.fields['description'] = description;
    request.fields['price'] = price;
    request.fields['category_id'] = categoryId.toString();

    if (kIsWeb) {
      // If Flutter Web
      if (webImageBytes != null && webImageName != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            webImageBytes,
            filename: webImageName,
            contentType:
                MediaType('image', 'jpeg'), // or detect mimeType dynamically
          ),
        );
      }
    } else {
      // For Android/iOS
      if (imageFile != null) {
        final mimeTypeData = lookupMimeType(imageFile.path)?.split('/');
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            imageFile.path,
            contentType: mimeTypeData != null
                ? MediaType(mimeTypeData[0], mimeTypeData[1])
                : null,
          ),
        );
      }
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Failed to add product: ${response.body}');
    }
  }
}

class _AddProductScreenState extends State<AddProductScreen> {
  String? selectedCategory;
  bool _isUploading = false;
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productDescriptionController =
      TextEditingController();
  final TextEditingController priceController = TextEditingController();

  File? _selectedImage;

  Uint8List? _webImage;
  String? _webImageName;

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _selectedImage =
            File(pickedFile.path); // Still keep this for Android/iOS
        _webImage = bytes; // <-- For Web!
        _webImageName = pickedFile.name;
      });
    }
  }

  List<Map<String, dynamic>> categories = [];
  bool isLoadingCategories = true;

  int mapCategoryToId(String categoryName) {
    switch (categoryName) {
      case "Mobile and Gadgets":
        return 1;
      case "Wearables":
        return 2;
      case "Accessories":
        return 3;
      default:
        return 1; // Default fallback
    }
  }

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  void loadCategories() async {
    try {
      categories = await CategoryService.getCategories();
    } catch (e) {
      // Handle error if needed
    } finally {
      setState(() {
        isLoadingCategories = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFilipino = Provider.of<LanguageModel>(context).isFilipino();
    final backgroundModel = Provider.of<Backgroundmodel>(context);

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white, // Always white
          appBar: AppBar(
            backgroundColor: backgroundModel.appBar,
            title: Text(
              isFilipino ? "Magdagdag ng Bagong Produkto" : 'Add New Product',
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isFilipino
                      ? "Magdagdag ng mga larawan ng produkto"
                      : "Add product images",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  isFilipino
                      ? "Magdagdag ng hanggang 5 larawan. Ang unang larawan ang ipapakita."
                      : "Add up to 5 images. First image will be highlighted.",
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    GestureDetector(
                      onTap: pickImage,
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _selectedImage == null
                            ? Icon(Icons.add, size: 40, color: Colors.grey)
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: _webImage != null
                                    ? Image.memory(_webImage!,
                                        fit: BoxFit.cover)
                                    : Icon(Icons.add,
                                        size: 40, color: Colors.grey),
                              ),
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  isFilipino ? "Mga detalye ng produkto" : "Product details",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                isLoadingCategories
                    ? CircularProgressIndicator()
                    : DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: isFilipino
                              ? "Pumili ng kategorya ng produkto"
                              : "Select product category",
                          border: OutlineInputBorder(),
                        ),
                        value: selectedCategory,
                        items: categories.map((category) {
                          return DropdownMenuItem<String>(
                            value: category['id'].toString(),
                            child: Text(category['name']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                      ),
                SizedBox(height: 10),
                TextField(
                  controller: productNameController,
                  decoration: InputDecoration(
                    labelText:
                        isFilipino ? "Pangalan ng produkto" : "Product name",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: productDescriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: isFilipino
                        ? "Deskripsyon ng produkto"
                        : "Product description",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: isFilipino ? "Presyo" : "Price",
                    border: OutlineInputBorder(),
                  ),
                ),
                Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: backgroundModel.secondBtn,
                          foregroundColor:
                              Colors.white, // explicitly set text color
                        ),
                        child: Text(isFilipino ? "Kanselahin" : "Cancel"),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (productNameController.text.isEmpty ||
                              productDescriptionController.text.isEmpty ||
                              priceController.text.isEmpty ||
                              selectedCategory == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(isFilipino
                                      ? "Pakitapos ang lahat ng fields."
                                      : "Please complete all fields.")),
                            );
                            return;
                          }

                          try {
                            setState(() {
                              _isUploading = true; // 👈 start spinner
                            });

                            await AddProductService.addProduct(
                              name: productNameController.text,
                              description: productDescriptionController.text,
                              price: priceController.text,
                              categoryId: int.parse(selectedCategory!),
                              imageFile: _selectedImage,
                              webImageBytes: _webImage,
                              webImageName: _webImageName,
                            );

                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(isFilipino
                                      ? "Matagumpay na naidagdag ang produkto!"
                                      : "Product added successfully!")),
                            );
                            Navigator.pop(context);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(isFilipino
                                      ? "Nabigo ang pagdaragdag ng produkto."
                                      : "Failed to add product.")),
                            );
                          } finally {
                            setState(() {
                              _isUploading = false; // 👈 hide spinner
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: backgroundModel.button,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(isFilipino ? "Idagdag" : "Add product"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (_isUploading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text(
                    "Uploading...",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
