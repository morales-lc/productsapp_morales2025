import 'package:flutter/material.dart';
import 'productinfo.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<Map<String, String>> products = [
    {
      "image": "assets/product.jpg",
      "name": "Wireless Headphones",
      "description": "Noise-canceling Bluetooth",
      "price": "\$99",
      "category": "Electronics"
    },
    {
      "image": "assets/product.jpg",
      "name": "Smartwatch",
      "description": "Health tracker & notifications",
      "price": "\$79",
      "category": "Wearables"
    },
    {
      "image": "assets/product.jpg",
      "name": "Gaming Mouse",
      "description": "Ergonomic with RGB lights",
      "price": "\$120",
      "category": "Accessories"
    },
    {
      "image": "assets/product.jpg",
      "name": "Portable Speaker",
      "description": "Waterproof & powerful sound",
      "price": "\$45",
      "category": "Audio"
    },
  ];

  final List<Map<String, String>> bestSellers = [
    {
      "image": "assets/product.jpg",
      "name": "Mechanical Keyboard",
      "description": "RGB backlit & responsive keys",
      "price": "\$150",
      "category": "Accessories"
    },
    {
      "image": "assets/product.jpg",
      "name": "Noise Cancelling Earbuds",
      "description": "High-quality audio & mic",
      "price": "\$130",
      "category": "Audio"
    },
    {
      "image": "assets/product.jpg",
      "name": "External SSD",
      "description": "Fast 1TB storage",
      "price": "\$95",
      "category": "Storage"
    },
    {
      "image": "assets/product.jpg",
      "name": "Fitness Tracker",
      "description": "Monitors steps & heart rate",
      "price": "\$110",
      "category": "Wearables"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        elevation: 0,
        leading: Icon(Icons.chat, color: Colors.black),
        actions: [
          Icon(Icons.notifications_none, color: Colors.black),
          SizedBox(width: 15),
          CircleAvatar(
            backgroundImage: AssetImage("assets/profile.jpg"), // Profile image
          ),
          SizedBox(width: 15),
        ],
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
              Text("Products",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                  Text("Best Seller",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("See all >",
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
              Text("Categories",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
              Text("Recommended for you",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                  color: Colors.pinkAccent, fontWeight: FontWeight.bold)),
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
                  color: Colors.pinkAccent, fontWeight: FontWeight.bold)),
          Text("500 sold", style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}
