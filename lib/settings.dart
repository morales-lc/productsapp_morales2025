import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'background_model.dart';
import 'language_model.dart';

class SettingsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> colorOptions = [
    {
      "name": "Default",
      "rgb": [255, 255, 255]
    },
    {
      "name": "Light Purple",
      "rgb": [230, 220, 255]
    },
  ];

  final List<String> languages = ["English", "Filipino"];

  @override
  Widget build(BuildContext context) {
    final backgroundModel = Provider.of<Backgroundmodel>(context);
    final languageModel = Provider.of<LanguageModel>(context);
    final currentColor = backgroundModel.getBkg();

    int selectedColorIndex = colorOptions.indexWhere((opt) =>
        currentColor ==
        Color.fromRGBO(opt["rgb"][0], opt["rgb"][1], opt["rgb"][2], 1));

    return Scaffold(
      backgroundColor: currentColor,
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Change language",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: languageModel.language,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.pinkAccent),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: languages
                  .map((lang) => DropdownMenuItem(
                        value: lang,
                        child: Text(lang),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  languageModel.setLanguage(value);
                }
              },
            ),
            SizedBox(height: 30),
            Text("Change page color",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 12),
            Row(
              children: List.generate(colorOptions.length, (i) {
                final rgb = colorOptions[i]["rgb"];
                final color = Color.fromRGBO(rgb[0], rgb[1], rgb[2], 1);
                final isSelected = i == selectedColorIndex;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () {
                      backgroundModel.changeBkg(rgb[0], rgb[1], rgb[2]);
                    },
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: color,
                      child: isSelected
                          ? Icon(Icons.check, color: Colors.white, size: 16)
                          : null,
                    ),
                  ),
                );
              }),
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
                      backgroundColor: Color(0xFF00695C),
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text("Cancel"),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text("Save"),
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
