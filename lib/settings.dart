import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'background_model.dart';
import 'language_model.dart';

class SettingsScreen extends StatelessWidget {
  final List<String> languages = ["English", "Filipino"];

  @override
  Widget build(BuildContext context) {
    final backgroundModel = Provider.of<Backgroundmodel>(context);
    final languageModel = Provider.of<LanguageModel>(context);

    return Scaffold(
      backgroundColor: Colors.white, // Always white background
      appBar: AppBar(
        backgroundColor: backgroundModel.appBar,
        title: Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
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
                    borderSide: BorderSide(color: backgroundModel.accent),
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
              Text("Change app theme",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 12),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      backgroundModel.reset();
                    },
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.pinkAccent,
                      child: backgroundModel.theme == "default"
                          ? Icon(Icons.check, color: Colors.white, size: 16)
                          : null,
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      backgroundModel.applyPurpleTheme();
                    },
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Color.fromRGBO(240, 230, 255, 1),
                      child: backgroundModel.theme == "purple"
                          ? Icon(Icons.check, color: Colors.white, size: 16)
                          : null,
                    ),
                  ),
                ],
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
                        backgroundColor: const Color(0xFF00695C),
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
                        backgroundColor: backgroundModel.accent,
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
      ),
    );
  }
}
