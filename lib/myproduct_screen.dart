import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/Products.dart';
import 'editproduct_screen.dart';
import 'config.dart';
import 'package:provider/provider.dart';
import 'models/background_model.dart';
import 'models/language_model.dart';

class MyProductsScreen extends StatefulWidget {
  final int userId;

  const MyProductsScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _MyProductsScreenState createState() => _MyProductsScreenState();
}

class _MyProductsScreenState extends State<MyProductsScreen> {
  List<Product> _products = [];
  Set<int> _selectedProductIds = {};

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final response =
        await http.get(Uri.parse('${AppConfig.baseUrl}/api/products?all=1'));
    if (!mounted) return;
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final List<dynamic> data = body['data'] ?? [];
      if (mounted) {
        setState(() {
          _products = data
              .where((item) => item['user_id'] == widget.userId)
              .map((item) => Product.fromJson(item))
              .toList();
        });
      }
    } else {
      //TODO: Handle error
    }
  }

  Future<void> _deleteProduct(int id) async {
    final response =
        await http.delete(Uri.parse('${AppConfig.baseUrl}/api/products/$id'));
    if (!mounted) return;
    if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          _products.removeWhere((product) => product.id == id);
          _selectedProductIds.remove(id);
        });
      }
    } else {
      // Handle error
    }
  }

  Future<void> _deleteSelectedProducts() async {
    final languageModel = Provider.of<LanguageModel>(context, listen: false);
    final isFilipino = languageModel.isFilipino();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
            isFilipino ? 'Burahin ang Napili' : 'Delete Selected Products'),
        content: Text(isFilipino
            ? 'Sigurado ka bang gusto mong burahin ang mga napiling produkto?'
            : 'Are you sure you want to delete the selected products?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(isFilipino ? 'Hindi' : 'No')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(isFilipino ? 'Oo' : 'Yes')),
        ],
      ),
    );
    if (confirm == true) {
      final idsToDelete = _selectedProductIds.toList(); // Make a copy!
      for (var id in idsToDelete) {
        await _deleteProduct(id);
      }
    }
  }

  Future<void> _editSelectedProduct() async {
    if (_selectedProductIds.length == 1) {
      final productId = _selectedProductIds.first;
      final product = _products.firstWhere((p) => p.id == productId);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditProductScreen(product: product),
        ),
      ).then((_) => _fetchProducts());
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundModel = Provider.of<Backgroundmodel>(context);
    final languageModel = Provider.of<LanguageModel>(context);
    final isFilipino = languageModel.isFilipino();
    final isSelectionMode = _selectedProductIds.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isFilipino ? 'Iyong Mga Produkto' : 'My Products',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: backgroundModel.appBar,
        elevation: 0,
        actions: [
          if (_selectedProductIds.isNotEmpty)
            IconButton(
              icon:
                  Icon(Icons.delete, color: const Color.fromARGB(255, 0, 0, 0)),
              tooltip: isFilipino ? "Burahin ang napili" : "Delete Selected",
              onPressed: _deleteSelectedProducts,
            ),
          if (_selectedProductIds.length == 1)
            IconButton(
              icon: Icon(Icons.edit, color: Color.fromARGB(255, 0, 0, 0)),
              tooltip: isFilipino ? "I-edit ang napili" : "Edit Selected",
              onPressed: _editSelectedProduct,
            ),
        ],
      ),
      backgroundColor: backgroundModel.background,
      body: RefreshIndicator(
        onRefresh: _fetchProducts,
        child: _products.isEmpty
            ? Center(
                child: Text(
                  isFilipino
                      ? "Walang nahanap na produkto."
                      : "No products found.",
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
              )
            : ListView.separated(
                padding: EdgeInsets.all(16),
                itemCount: _products.length,
                separatorBuilder: (context, index) => SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final product = _products[index];
                  final isSelected = _selectedProductIds.contains(product.id);
                  return GestureDetector(
                    onLongPress: () {
                      setState(() {
                        if (isSelected) {
                          _selectedProductIds.remove(product.id);
                        } else {
                          _selectedProductIds.add(product.id);
                        }
                      });
                    },
                    onTap: () {
                      if (_selectedProductIds.isNotEmpty) {
                        setState(() {
                          if (isSelected) {
                            _selectedProductIds.remove(product.id);
                          } else {
                            _selectedProductIds.add(product.id);
                          }
                        });
                        // If only one is selected after tap, open edit screen
                        if (_selectedProductIds.length == 1 &&
                            isSelected == false) {
                          final productId = _selectedProductIds.first;
                          final selectedProduct =
                              _products.firstWhere((p) => p.id == productId);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditProductScreen(product: selectedProduct),
                            ),
                          ).then((_) => _fetchProducts());
                        }
                      }
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? backgroundModel.accent.withOpacity(0.08)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: isSelected
                            ? Border.all(
                                color: backgroundModel.accent, width: 2)
                            : Border.all(color: Colors.transparent),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: product.imagePath != null &&
                                    product.imagePath!.isNotEmpty
                                ? Image.network(
                                    '${AppConfig.baseUrl}/storage/${product.imagePath}',
                                    height: 70,
                                    width: 70,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error,
                                            stackTrace) =>
                                        Image.asset(
                                            'assets/product_placeholder.png',
                                            height: 70,
                                            width: 70,
                                            fit: BoxFit.cover),
                                  )
                                : Image.asset('assets/product_placeholder.png',
                                    height: 70, width: 70, fit: BoxFit.cover),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: backgroundModel.textColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  product.description,
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 13,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "₱${product.price}",
                                  style: TextStyle(
                                    color: backgroundModel.accent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8),
                          Column(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit,
                                    color: backgroundModel.accent),
                                tooltip: isFilipino ? "I-edit" : "Edit",
                                onPressed: () {
                                  // Always allow edit button to open edit screen for this product
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditProductScreen(product: product),
                                    ),
                                  ).then((_) => _fetchProducts());
                                },
                              ),
                              IconButton(
                                icon:
                                    Icon(Icons.delete, color: Colors.redAccent),
                                tooltip: isFilipino ? "Burahin" : "Delete",
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text(isFilipino
                                          ? 'Burahin ang Produkto'
                                          : 'Delete Product'),
                                      content: Text(isFilipino
                                          ? 'Sigurado ka bang gusto mong burahin ang "${product.name}"?'
                                          : 'Are you sure you want to delete "${product.name}"?'),
                                      actions: [
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: Text(
                                                isFilipino ? 'Hindi' : 'No')),
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: Text(
                                                isFilipino ? 'Oo' : 'Yes')),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    await _deleteProduct(product.id);
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
