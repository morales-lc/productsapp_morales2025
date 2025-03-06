import 'package:flutter/material.dart';
import 'homescreen.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Map<String, String> product;
  const ProductDetailsScreen({super.key, required this.product});

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
            Image.asset(product["image"]!,
                height: 200, width: double.infinity, fit: BoxFit.cover),
            SizedBox(height: 10),
            Text(product["name"]!,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(product["price"]!,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.orange, size: 18),
                    Text(" 4.5 "),
                    Text("(99 reviews)", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Text("Description",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 5),
            Text(product["description"]!, style: TextStyle(color: Colors.grey)),
            SizedBox(height: 15),
            Text("Category",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 5),
            Text(product["category"]!, style: TextStyle(color: Colors.black)),
            SizedBox(height: 20),
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
                    children: List.generate(
                        5,
                        (index) => Icon(
                            index < 4 ? Icons.star : Icons.star_half,
                            color: Colors.orange)),
                  ),
                  SizedBox(height: 10),
                  ...List.generate(5, (index) {
                    return Row(
                      children: [
                        Text("${5 - index}",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(width: 5),
                        Expanded(
                          child: LinearProgressIndicator(
                            value: (80 - (index * 20)) / 100,
                            backgroundColor: Colors.grey[300],
                            color: Colors.orange,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text("${(80 - (index * 20)) ~/ 20}",
                            style: TextStyle(color: Colors.grey))
                      ],
                    );
                  }),
                ],
              ),
            ),
            SizedBox(height: 15),
            Row(
              children: [
                CircleAvatar(backgroundImage: AssetImage("assets/user1.jpg")),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Rovi T.",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("Occaecat laboris cupidatat dolo",
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                CircleAvatar(backgroundImage: AssetImage("assets/user2.jpg")),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Sean S.",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("Occaecat laboris cupidatat dolo",
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
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
}
