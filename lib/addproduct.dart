import 'package:flutter/material.dart';
import 'language_model.dart';
import 'background_model.dart';
import 'package:provider/provider.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  String? selectedCategory;
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productDescriptionController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isFilipino = Provider.of<LanguageModel>(context).isFilipino();
    final backgroundModel = Provider.of<Backgroundmodel>(context);

    return Scaffold(
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
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.add, size: 40, color: Colors.grey),
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
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: isFilipino
                    ? "Pumili ng kategorya ng produkto"
                    : "Select product category",
                border: OutlineInputBorder(),
              ),
              items: ["Mobile and Gadgets", "Wearables", "Accessories"]
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
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
                labelText: isFilipino ? "Pangalan ng produkto" : "Product name",
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
                    onPressed: () {
                      // Handle adding product
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: backgroundModel.button,
                      foregroundColor:
                          Colors.white, // explicitly set text color
                    ),
                    child: Text(isFilipino ? "Idagdag" : "Add product"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
