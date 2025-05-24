import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';
import 'productinfo.dart';

class CategoryProductsScreen extends StatefulWidget {
  final int initialCategoryId;
  final String initialCategoryName;

  const CategoryProductsScreen({
    super.key,
    required this.initialCategoryId,
    required this.initialCategoryName,
  });

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> products = [];
  int? selectedCategoryId;
  String? selectedCategoryName;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    selectedCategoryId = widget.initialCategoryId;
    selectedCategoryName = widget.initialCategoryName;
    loadCategoriesAndProducts();
  }

  Future<void> loadCategoriesAndProducts() async {
    setState(() => isLoading = true);
    await loadCategories();
    await loadProductsForCategory(selectedCategoryId!);
    setState(() => isLoading = false);
  }

  Future<void> loadCategories() async {
    final response =
        await http.get(Uri.parse('${AppConfig.baseUrl}/api/categories'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        categories = data
            .map<Map<String, dynamic>>((item) => {
                  'id': item['id'],
                  'name': item['name'],
                })
            .toList();
      });
    }
  }

  Future<void> loadProductsForCategory(int categoryId) async {
    setState(() => isLoading = true);
    final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/api/categories/$categoryId/products'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<dynamic> raw = jsonData['data'] ?? jsonData;
      setState(() {
        products = List<Map<String, dynamic>>.from(raw);
        selectedCategoryId = categoryId;
        selectedCategoryName =
            categories.firstWhere((c) => c['id'] == categoryId)['name'];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color accent = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          selectedCategoryName ?? "Category",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: accent,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      backgroundColor: const Color(0xFFF6F8FA),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Category selector
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: selectedCategoryId,
                          isExpanded: true,
                          icon: Icon(Icons.arrow_drop_down, color: accent),
                          items: categories
                              .map((cat) => DropdownMenuItem<int>(
                                    value: cat['id'],
                                    child: Text(
                                      cat['name'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: accent),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              loadProductsForCategory(value);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                // Products grid/list
                Expanded(
                  child: products.isEmpty
                      ? const Center(
                          child: Text(
                            "No products found.",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(12),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.68,
                          ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            final hasImage = product['image_path'] != null &&
                                product['image_path'].toString().isNotEmpty;
                            final imageWidget = hasImage
                                ? ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(16)),
                                    child: Image.network(
                                      '${AppConfig.baseUrl}/storage/${product['image_path']}',
                                      height: 140,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error,
                                              stackTrace) =>
                                          Image.asset(
                                              'assets/product_placeholder.png',
                                              height: 140,
                                              fit: BoxFit.cover),
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(16)),
                                    child: Image.asset(
                                        'assets/product_placeholder.png',
                                        height: 140,
                                        fit: BoxFit.cover),
                                  );
                            return Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ProductDetailsScreen(
                                          product: product),
                                    ),
                                  );
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 8,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      imageWidget,
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            12, 12, 12, 4),
                                        child: Text(
                                          product['name'] ?? '',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12.0),
                                        child: Text(
                                          product['description'] ?? '',
                                          style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const Spacer(),
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text(
                                          '₱${product['price']?.toString() ?? ''}',
                                          style: TextStyle(
                                              color: accent,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
