import 'package:flutter/material.dart';
import 'productinfo.dart';
import 'addproduct.dart';
import 'settings.dart';
import 'language_model.dart';
import 'background_model.dart';
import 'package:provider/provider.dart';
import 'login.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<Map<String, String>> products = [
    {
      "image": "assets/wirelessheadphone.jpg",
      "name": "Wireless Headphones",
      "description":
          "Experience unparalleled audio quality with the UltraSound Wireless Noise-Cancelling Bluetooth Headphones. Designed for the ultimate listening experience, these headphones feature advanced noise-cancelling technology that blocks out ambient noise, allowing you to immerse yourself in your music, podcasts, or calls without distractions.",
      "price": "\$99",
      "category": "Electronics"
    },
    {
      "image": "assets/smartwatch.jpg",
      "name": "Smartwatch",
      "description":
          "Stay on top of your health and fitness goals with the HealthPro Smartwatch Health Tracker. This advanced smartwatch is designed to provide comprehensive health monitoring and fitness tracking, all while keeping you connected and stylish.",
      "price": "\$79",
      "category": "Wearables"
    },
    {
      "image": "assets/gamingmouse.jpg",
      "name": "Gaming Mouse",
      "description":
          "Elevate your gaming experience with the HyperSpeed Gaming Mouse, designed for precision, speed, and comfort. This high-performance gaming mouse is perfect for both casual and competitive gamers, offering a range of features to enhance your gameplay.",
      "price": "\$120",
      "category": "Accessories"
    },
    {
      "image": "assets/portablespeaker.jpg",
      "name": "Portable Speaker",
      "description":
          "Take your music anywhere with the AquaSound Portable Bluetooth Waterproof Speaker. Designed for outdoor enthusiasts and music lovers, this speaker delivers powerful sound and durability in any environment.",
      "price": "\$45",
      "category": "Audio"
    },
  ];

  final List<Map<String, String>> bestSellers = [
    {
      "image": "assets/mechanicalkeyboard.jpg",
      "name": "Mechanical Keyboard",
      "description":
          "Enhance your gaming experience with the Lumina RGB Mechanical Gaming Keyboard. Designed for gamers who demand precision, speed, and style, this keyboard offers a range of features to elevate your gameplay.",
      "price": "\$150",
      "category": "Accessories"
    },
    {
      "image": "assets/earbuds.jpg",
      "name": "Wireless Earbuds",
      "description":
          "Immerse yourself in your favorite music with the QuietBuds Noise-Cancelling Bluetooth Earbuds. Designed for superior sound quality and comfort, these earbuds feature advanced noise-cancelling technology to block out unwanted ambient noise, allowing you to enjoy your audio without distractions.",
      "price": "\$130",
      "category": "Audio"
    },
    {
      "image": "assets/ssd.jpg",
      "name": "External SSD",
      "description":
          "Experience lightning-fast data transfer and reliable storage with the SpeedDrive 1TB External SSD. Designed for professionals and tech enthusiasts, this portable SSD offers high-speed performance and durability in a compact form factor.",
      "price": "\$95",
      "category": "Storage"
    },
    {
      "image": "assets/fitnesstracker.jpg",
      "name": "Fitness Tracker",
      "description":
          "Stay on top of your health and fitness goals with the FitTrack Pro Fitness Tracker. This advanced fitness tracker is designed to provide comprehensive health monitoring and fitness tracking, all while keeping you connected and stylish.",
      "price": "\$110",
      "category": "Wearables"
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isFilipino = Provider.of<LanguageModel>(context).isFilipino();
    final backgroundModel = Provider.of<Backgroundmodel>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: backgroundModel.appBar,
        elevation: 0,
        actions: [
          Icon(Icons.notifications_none, color: Colors.black),
          SizedBox(width: 15),
          CircleAvatar(
            backgroundImage: AssetImage("assets/profile.jpg"), // Profile image
          ),
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
                    radius: 30,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "User Name",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Text(
                    "user@example.com",
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.add_box),
              title: Text(isFilipino ? "Magdagdag ng Produkto" : 'Add Product'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddProductScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Handle settings
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text(isFilipino ? "Mag-Logout" : 'Logout'),
              onTap: () {
                // Handle logout
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return LoginScreen(); // Assuming you have a LoginScreen
                }));
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              // Banner
              Image.asset("assets/banner.jpg",
                  height: 150, width: double.infinity, fit: BoxFit.cover),
              SizedBox(height: 20),

              // Products Section
              Text(
                isFilipino ? "Mga Produkto" : "Products",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsScreen(
                                  product: products[index]),
                            ),
                          );
                        },
                        child: ProductItem(
                          imagePath: products[index]["image"]!,
                          name: products[index]["name"]!,
                          description: products[index]["description"]!,
                          price: products[index]["price"]!,
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 20),

              // Best Seller Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isFilipino ? "Pinakamabenta" : "Best Seller",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(isFilipino ? "Ipakita lahat >" : "See all >",
                      style: TextStyle(color: Colors.blue, fontSize: 14)),
                ],
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: bestSellers.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsScreen(
                                  product: bestSellers[index]),
                            ),
                          );
                        },
                        child: ProductItem(
                          imagePath: bestSellers[index]["image"]!,
                          name: bestSellers[index]["name"]!,
                          description: bestSellers[index]["description"]!,
                          price: bestSellers[index]["price"]!,
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 20),

              // Categories Section
              Text(
                isFilipino ? "Mga Kategorya" : "Categories",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CategoryItem(
                          title: "Mobile and Gadgets",
                          imagePath: "assets/mobile.jpg"),
                      CategoryItem(
                          title: "Men's Apparel", imagePath: "assets/men.jpg"),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CategoryItem(
                          title: "Women's Apparel",
                          imagePath: "assets/women.jpg"),
                      CategoryItem(
                          title: "Kitchen Appliances",
                          imagePath: "assets/kitchen.jpg"),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Recommended Products Section
              // Recommended Products Section
              Text(
                isFilipino
                    ? "Inirerekomenda para sa iyo"
                    : "Recommended for you",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Column(
                children: [
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween, // Adjusted spacing
                    children: [
                      Expanded(
                        child: RecommendedProductItem(
                            imagePath: "assets/laptop.jpg", price: "₱1,000"),
                      ),
                      SizedBox(width: 10), // Added spacing
                      Expanded(
                        child: RecommendedProductItem(
                            imagePath: "assets/ssd.jpg", price: "₱1,699"),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween, // Adjusted spacing
                    children: [
                      Expanded(
                        child: RecommendedProductItem(
                            imagePath: "assets/camera.jpg", price: "₱1,000"),
                      ),
                      SizedBox(width: 10), // Added spacing
                      Expanded(
                        child: RecommendedProductItem(
                            imagePath: "assets/laptop2.jpg", price: "₱1,000"),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//class for product item lists
class ProductItem extends StatelessWidget {
  final String imagePath;
  final String name;
  final String description;
  final String price;

  const ProductItem({
    super.key,
    required this.imagePath,
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
          Image.asset(imagePath, height: 100, width: 130, fit: BoxFit.cover),
          SizedBox(height: 5),
          Text(name,
              style: TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          SizedBox(height: 3),
          Text(description,
              style: TextStyle(fontSize: 12, color: Colors.grey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          SizedBox(height: 3),
          Row(
            children: [
              Icon(Icons.star, color: Colors.orange, size: 16),
              Text(" 4.5"),
            ],
          ),
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
          Image.asset(imagePath,
              height: 100, width: 200, fit: BoxFit.cover), // Category image
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

  const RecommendedProductItem(
      {super.key, required this.imagePath, required this.price});

  @override
  Widget build(BuildContext context) {
    final backgroundModel = Provider.of<Backgroundmodel>(context);
    return SizedBox(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(imagePath,
              height: 120, width: 200, fit: BoxFit.cover), // Using an image now
          SizedBox(height: 5),
          Text("Product title", style: TextStyle(fontWeight: FontWeight.bold)),
          Text("Product description",
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
