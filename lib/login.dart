import 'package:flutter/material.dart';
import 'homescreen.dart';
import 'models/language_model.dart';
import 'models/background_model.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _testConnection();
  }

  void _testConnection() async {
    try {
      final response = await http.get(Uri.parse(AppConfig.baseUrl));
      debugPrint('Status: ${response.statusCode}');
      debugPrint('Body: ${response.body}');
    } catch (e) {
      debugPrint('Connection failed: $e');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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

                      // Email Field
                      Text(
                        "Email",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      TextField(
                        controller: _emailController, //TextController for email
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText:
                              isFilipino ? "Ilagay ang Email" : "Enter Email",
                          prefixIcon: Icon(Icons.email),
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
                        controller:
                            _passwordController, //TextController for password
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
                          onPressed: () async {
                            if (_emailController.text.isEmpty ||
                                _passwordController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(isFilipino
                                        ? "Pakitapos ang lahat ng fields."
                                        : "Please complete all fields.")),
                              );
                              return;
                            }

                            try {
                              final response = await http.post(
                                Uri.parse(
                                    '${AppConfig.baseUrl}/api/auth/login'),
                                headers: {
                                  'Content-Type':
                                      'application/json; charset=UTF-8',
                                },
                                body: jsonEncode({
                                  'email': _emailController.text,
                                  'password': _passwordController.text,
                                }),
                              );

                              if (response.statusCode == 200) {
                                final responseData = jsonDecode(response.body);
                                final userId = responseData['user']['id'];
                                final username =
                                    responseData['user']['username'];
                                final email = responseData['user']['email'];
                                final token = responseData['access_token'];

                                final prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setInt('user_id', userId);
                                await prefs.setString(
                                    'user_name', username ?? 'User Name');
                                await prefs.setString(
                                    'user_email', email ?? 'user@example.com');
                                await prefs.setString(
                                    'access_token', token ?? '');

                                if (!mounted) return;

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()),
                                );
                              } else if (response.statusCode == 422) {
                                // Validation error
                                final errorData = jsonDecode(response.body);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(errorData['message'] ??
                                        (isFilipino
                                            ? "May error sa input."
                                            : "Validation error.")),
                                  ),
                                );
                              } else if (response.statusCode == 401 ||
                                  response.statusCode == 403) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(isFilipino
                                        ? "Maling kredensyal."
                                        : "Invalid credentials."),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(isFilipino
                                        ? "May problema sa server."
                                        : "Server error."),
                                  ),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(isFilipino
                                      ? "May problema sa koneksyon."
                                      : "Connection error."),
                                ),
                              );
                            }
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
