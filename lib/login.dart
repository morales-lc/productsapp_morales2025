import 'package:flutter/material.dart';
import 'homescreen.dart';
import 'language_model.dart';
import 'background_model.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final isFilipino = Provider.of<LanguageModel>(context).isFilipino();
    final backgroundModel = Provider.of<Backgroundmodel>(context);
    return Scaffold(
      backgroundColor: backgroundModel.accent,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello.",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        isFilipino ? "Maligayang pagdating" : "Welcome back",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 20),

                      // Username Field
                      Text(
                        "User name",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      TextField(
                        decoration: InputDecoration(
                          hintText: isFilipino
                              ? "Ilagay ang User name"
                              : "Enter User name",
                          prefixIcon: Icon(Icons.person),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 15),

                      // Password Field
                      Text(
                        "Password",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      TextField(
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: isFilipino
                              ? "Ilagay ang Password"
                              : "Enter Password",
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),

                      // Forgot Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            isFilipino
                                ? "Nakalimutan ang password?"
                                : "Forgot password?",
                            style: TextStyle(color: Colors.teal),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: backgroundModel.button,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()),
                            );
                          },
                          child: Text(
                            isFilipino ? "Mag-sign In" : "Sign In",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),

                      // Sign Up
                      Center(
                        child: TextButton(
                          onPressed: () {},
                          child: RichText(
                            text: TextSpan(
                              text: isFilipino
                                  ? "Walang account?"
                                  : "Don't have an account? ",
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                  text: isFilipino ? "Mag-sign up" : "Sign up",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
