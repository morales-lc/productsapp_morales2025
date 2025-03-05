import 'package:flutter/material.dart';
import 'homescreen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProductDetailsScreen(),
    );
  }
}

class ProductDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        elevation: 0,
        title: Text("Product Name",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Icon(Icons.chat_bubble_outline, color: Colors.black),
          SizedBox(width: 15),
          Icon(Icons.shopping_cart_outlined, color: Colors.black),
          SizedBox(width: 15),
          CircleAvatar(
            backgroundImage: AssetImage("assets/profile.jpg"),
            radius: 15,
          ),
          SizedBox(width: 15),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image Slider
            SizedBox(
              height: 200,
              child: PageView(
                children: [
                  Image.asset("assets/headphones.jpg",
                      height: 200, width: double.infinity, fit: BoxFit.cover),
                  Image.asset("assets/headphones2.jpg",
                      height: 200, width: double.infinity, fit: BoxFit.cover),
                  Image.asset("assets/headphones3.jpg",
                      height: 200, width: double.infinity, fit: BoxFit.cover),
                ],
              ),
            ),
            SizedBox(height: 10),

            // Product Price & Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("\$99",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.orange, size: 18),
                    Text(" 4.5 ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("(99 reviews)", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),

            // Description
            Text("Description",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 5),
            Text(
              "Quis occaecat magna elit magna do nisi ipsum amet excepteur tempor nisi exercitation qui... Quis occaecat magna elit magna do nisi ipsum amet excepteur tempor nisi exercitation qui... Quis occaecat magna elit magna do nisi ipsum amet excepteur tempor nisi exercitation qui...",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 15),

            // Category
            Text("Category",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 5),
            Text("Mobile and Gadgets", style: TextStyle(color: Colors.black)),
            SizedBox(height: 20),

            // Reviews Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Reviews",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text("See all >",
                    style: TextStyle(color: Colors.blue, fontSize: 14)),
              ],
            ),
            SizedBox(height: 10),

            // Rating Breakdown
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("4.5/5",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text("(99 reviews)", style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange),
                      Icon(Icons.star, color: Colors.orange),
                      Icon(Icons.star, color: Colors.orange),
                      Icon(Icons.star, color: Colors.orange),
                      Icon(Icons.star_half, color: Colors.orange),
                    ],
                  ),
                  SizedBox(height: 10),

                  // Review Bars
                  _buildReviewBar(5, 80),
                  _buildReviewBar(4, 60),
                  _buildReviewBar(3, 40),
                  _buildReviewBar(2, 20),
                  _buildReviewBar(1, 10),
                ],
              ),
            ),
            SizedBox(height: 15),

            // User Reviews
            _buildUserReview("Rovi T.", "Occaecat laboris cupidatat dolo",
                "assets/user1.jpg"),
            _buildUserReview("Sean S.", "Occaecat laboris cupidatat dolo",
                "assets/user2.jpg"),

            SizedBox(height: 20),

            // Relevant Products Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Relevant products",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text("See all >",
                    style: TextStyle(color: Colors.blue, fontSize: 14)),
              ],
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 240,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  RecommendedProductItem(
                      imagePath: "assets/product.jpg", price: "\$99"),
                  SizedBox(width: 10), // Space between items
                  RecommendedProductItem(
                      imagePath: "assets/product.jpg", price: "\$99"),
                  SizedBox(width: 10),
                  RecommendedProductItem(
                      imagePath: "assets/product.jpg", price: "\$99"),
                ],
              ),
            ),
          ],
        ),
      ),

      // Buy Now Button
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        color: Colors.white,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(0, 105, 95, 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.symmetric(vertical: 15)),
          onPressed: () {},
          child: Text("Buy Now",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  // Helper function for review bars
  Widget _buildReviewBar(int stars, double percentage) {
    return Row(
      children: [
        Text("$stars", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(width: 5),
        Expanded(
          child: LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: Colors.grey[300],
            color: Colors.orange,
          ),
        ),
        SizedBox(width: 10),
        Text("${(percentage / 20).round()}",
            style: TextStyle(color: Colors.grey))
      ],
    );
  }

  // Helper function for user reviews
  Widget _buildUserReview(String name, String review, String imagePath) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: AssetImage(imagePath)),
      title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(review, style: TextStyle(color: Colors.grey)),
    );
  }
}
