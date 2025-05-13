import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'addproduct.dart';
import 'background_model.dart';
import 'language_model.dart';
import 'login.dart';
import 'myproduct_screen.dart';
import 'productinfo.dart';
import 'settings.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> allProducts = [];
  bool isLoading = true;
  String? userName;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    loadProducts();
    loadUserInfo();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showWelcomeDialog();
    });
  }

  void showWelcomeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Welcome!"),
        content: Text("You have successfully logged in."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<void> loadProducts() async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.1.137:8000/api/products?all=1'));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final raw = jsonData['data'] ?? jsonData;
        List<Map<String, dynamic>> fetched =
            List<Map<String, dynamic>>.from(raw);
        fetched.shuffle(Random());

        setState(() {
          allProducts = fetched;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Failed to load products: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'User Name';
      userEmail = prefs.getString('user_email') ?? 'user@example.com';
    });
  }

  Widget productList(List<Map<String, dynamic>> items, {Set<int>? excludeIds}) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final product = items[index];
          if (excludeIds != null && excludeIds.contains(product['id'])) {
            return SizedBox.shrink(); // Skip duplicates
          }
          final hasImage = product['image_path'] != null &&
              product['image_path'].toString().isNotEmpty;
          final imageWidget = hasImage
              ? Image.network(
                  'http://192.168.1.137:8000/storage/${product['image_path']}',
                  height: 100,
                  width: 130,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/product_placeholder.png',
                      height: 100,
                      width: 130,
                      fit: BoxFit.cover),
                )
              : Image.asset('assets/product_placeholder.png',
                  height: 100, width: 130, fit: BoxFit.cover);
          return Padding(
            padding: EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ProductDetailsScreen(product: product)),
              ),
              child: ProductItem(
                imageWidget: imageWidget,
                name: product['name'],
                description: product['description'],
                price: '₱${product['price']}',
              ),
            ),
          );
        },
      ),
    );
  }

  Widget recommendedGrid(List<Map<String, dynamic>> items) {
    final random = Random();
    final recommended = List<Map<String, dynamic>>.from(items)..shuffle(random);
    final recs = recommended.take(4).toList();
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: GestureDetector(
              onTap: () => _navigateToProductInfo(recs, 0),
              child: RecommendedProductItem(
                  imagePath: getProductImage(recs, 0),
                  price: getProductPrice(recs, 0),
                  name: getProductName(recs, 0),
                  description: getProductDesc(recs, 0)),
            )),
            SizedBox(width: 10),
            Expanded(
                child: GestureDetector(
              onTap: () => _navigateToProductInfo(recs, 1),
              child: RecommendedProductItem(
                  imagePath: getProductImage(recs, 1),
                  price: getProductPrice(recs, 1),
                  name: getProductName(recs, 1),
                  description: getProductDesc(recs, 1)),
            )),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
                child: GestureDetector(
              onTap: () => _navigateToProductInfo(recs, 2),
              child: RecommendedProductItem(
                  imagePath: getProductImage(recs, 2),
                  price: getProductPrice(recs, 2),
                  name: getProductName(recs, 2),
                  description: getProductDesc(recs, 2)),
            )),
            SizedBox(width: 10),
            Expanded(
                child: GestureDetector(
              onTap: () => _navigateToProductInfo(recs, 3),
              child: RecommendedProductItem(
                  imagePath: getProductImage(recs, 3),
                  price: getProductPrice(recs, 3),
                  name: getProductName(recs, 3),
                  description: getProductDesc(recs, 3)),
            )),
          ],
        ),
      ],
    );
  }

  String getProductImage(List<Map<String, dynamic>> list, int idx) {
    if (idx >= list.length) return 'assets/product_placeholder.png';
    final p = list[idx];
    if (p['image_path'] != null && p['image_path'].toString().isNotEmpty) {
      return 'http://192.168.1.137:8000/storage/${p['image_path']}';
    }
    return 'assets/product_placeholder.png';
  }

  String getProductPrice(List<Map<String, dynamic>> list, int idx) {
    if (idx >= list.length) return '';
    return '₱${list[idx]['price'] ?? ''}';
  }

  String getProductName(List<Map<String, dynamic>> list, int idx) {
    if (idx >= list.length) return '';
    return list[idx]['name'] ?? '';
  }

  String getProductDesc(List<Map<String, dynamic>> list, int idx) {
    if (idx >= list.length) return '';
    return list[idx]['description'] ?? '';
  }

  void _navigateToProductInfo(List<Map<String, dynamic>> list, int idx) {
    if (idx >= list.length) return;
    final product = list[idx];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailsScreen(product: product),
      ),
    );
  }

  Widget trendingProductsSection(List<Map<String, dynamic>> items) {
    final random = Random();
    final trending = List<Map<String, dynamic>>.from(items)..shuffle(random);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle('Trending Products'),
        productList(trending.take(8).toList()),
      ],
    );
  }

  Widget hotDealsSection(List<Map<String, dynamic>> items) {
    final random = Random();
    final hotDeals = List<Map<String, dynamic>>.from(items)..shuffle(random);
    final recs = hotDeals.take(4).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle('Hot Deals'),
        recommendedGrid(recs),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isFilipino = Provider.of<LanguageModel>(context).isFilipino();
    final backgroundModel = Provider.of<Backgroundmodel>(context);
    int split = (allProducts.length / 2).ceil();
    final productsSection = allProducts.take(split).toList();
    final bestSellersSection = allProducts.skip(split).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: backgroundModel.appBar,
        elevation: 0,
        actions: [
          Icon(Icons.notifications_none, color: Colors.black),
          SizedBox(width: 15),
          CircleAvatar(backgroundImage: AssetImage("assets/profile.jpg")),
          SizedBox(width: 15),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: backgroundModel.appBar),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                      backgroundImage: AssetImage("assets/profile.jpg"),
                      radius: 30),
                  SizedBox(height: 10),
                  Text(userName ?? "User Name",
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                  Text(userEmail ?? "user@example.com",
                      style: TextStyle(fontSize: 14, color: Colors.white70)),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.add_box),
              title: Text(isFilipino ? "Magdagdag ng Produkto" : 'Add Product'),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => AddProductScreen())),
            ),
            ListTile(
              leading: Icon(Icons.inventory),
              title: Text(isFilipino ? "Iyong Mga Produkto" : 'My Products'),
              onTap: () async {
                Navigator.pop(context);
                final prefs = await SharedPreferences.getInstance();
                final userId = prefs.getInt('user_id');
                if (userId != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => MyProductsScreen(userId: userId)));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(isFilipino
                          ? "Walang naka-log in na user."
                          : "No user logged in.")));
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => SettingsScreen())),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text(isFilipino ? "Mag-Logout" : 'Logout'),
              onTap: () => Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => LoginScreen())),
            ),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await loadProducts();
                await loadUserInfo();
              },
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Image.asset("assets/banner.jpg",
                        height: 300, width: double.infinity, fit: BoxFit.cover),
                    SizedBox(height: 20),
                    sectionTitle(isFilipino ? "Mga Produkto" : "Products"),
                    productList(productsSection),
                    sectionTitleWithAction(
                      isFilipino ? "Pinakamabenta" : "Best Seller",
                      isFilipino ? "Ipakita lahat >" : "See all >",
                    ),
                    productList(bestSellersSection),
                    sectionTitle(isFilipino ? "Mga Kategorya" : "Categories"),
                    categoryGrid(),
                    sectionTitle(isFilipino
                        ? "Inirerekomenda para sa iyo"
                        : "Recommended for you"),
                    recommendedGrid(allProducts),
                    trendingProductsSection(allProducts),
                    hotDealsSection(allProducts),
                  ],
                ),
              ),
            ),
    );
  }

  Widget sectionTitle(String title) {
    return Column(
      children: [
        Text(title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
      ],
    );
  }

  Widget sectionTitleWithAction(String title, String actionText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(actionText, style: TextStyle(color: Colors.blue, fontSize: 14)),
      ],
    );
  }

  Widget categoryGrid() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CategoryItem(
                title: "Mobile and Gadgets", imagePath: "assets/mobile.jpg"),
            CategoryItem(title: "Men's Apparel", imagePath: "assets/men.jpg"),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CategoryItem(
                title: "Women's Apparel", imagePath: "assets/women.jpg"),
            CategoryItem(
                title: "Kitchen Appliances", imagePath: "assets/kitchen.jpg"),
          ],
        ),
      ],
    );
  }
}

class ProductItem extends StatelessWidget {
  final Widget imageWidget;
  final String name;
  final String description;
  final String price;

  const ProductItem({
    super.key,
    required this.imageWidget,
    required this.name,
    required this.description,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundModel = Provider.of<Backgroundmodel>(context);
    return SizedBox(
      width: 130,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          imageWidget,
          SizedBox(height: 5),
          Text(name,
              style: TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          Text(description,
              style: TextStyle(fontSize: 12, color: Colors.grey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          SizedBox(height: 3),
          Row(children: [
            Icon(Icons.star, color: Colors.orange, size: 16),
            Text(" 4.5")
          ]),
          SizedBox(height: 3),
          Text(price,
              style: TextStyle(
                  color: backgroundModel.textColor,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String title;
  final String imagePath;

  const CategoryItem({super.key, required this.title, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Column(
        children: [
          Image.asset(imagePath, height: 100, width: 200, fit: BoxFit.cover),
          SizedBox(height: 5),
          Text(title,
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class RecommendedProductItem extends StatelessWidget {
  final String imagePath;
  final String price;
  final String? name;
  final String? description;

  const RecommendedProductItem({
    super.key,
    required this.imagePath,
    required this.price,
    this.name,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundModel = Provider.of<Backgroundmodel>(context);
    return SizedBox(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          imagePath.startsWith('http')
              ? Image.network(imagePath,
                  height: 120,
                  width: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/product_placeholder.png',
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover // Ensure placeholder fits
                      ))
              : Image.asset(imagePath,
                  height: 120, width: 200, fit: BoxFit.cover),
          Text(name ?? "Product title",
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text(description ?? "Product description",
              style: TextStyle(fontSize: 12, color: Colors.grey)),
          SizedBox(height: 5),
          Text("30% Off",
              style: TextStyle(
                  color: const Color.fromRGBO(51, 171, 159, 1),
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          Text(price,
              style: TextStyle(
                  color: backgroundModel.textColor,
                  fontWeight: FontWeight.bold)),
          Text("500 sold", style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}
