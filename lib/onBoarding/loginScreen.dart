import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../component/circular_progess_indecator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance; // Firebase Auth instance

  bool _isLoading = false; // To handle loading state

  // Login function
  Future<void> _login() async {
    try {
      setState(() {
        _isLoading = true; // Set loading to true when starting the login
      });

      // Sign in user with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      setState(() {
        _isLoading = false; // Set loading to false when finished
      });

      // Navigate to home screen or dashboard after successful login
      Navigator.pushReplacementNamed(context, '/home'); // Replace with your home screen route
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false; // Set loading to false on error
      });

      // Show an error message if login fails
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? 'Error occurred')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf3f4f6),
      appBar: AppBar(
        title: Text(
          'Login',
          style: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.teal,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                'assets/images/login-lo.jpg', // Make sure the image path is correct
                fit: BoxFit.cover, // Ensure it covers the entire screen
              ),
            ),
            // Content (form and buttons)
            Padding(
              padding: const EdgeInsets.all(16.0), // Add padding around the form
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height*0.6,
                    // Adjust container height for better alignment
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade600, Colors.teal.shade300], // Gradient for container background
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // Shadow direction
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 60),
                        // Email TextField
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: GoogleFonts.poppins(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: const Icon(Icons.email),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Password TextField
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: GoogleFonts.poppins(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: const Icon(Icons.lock),
                          ),
                        ),
                        const SizedBox(height: 30),
                        // Login Button
                        ElevatedButton(
                          onPressed: _isLoading ? null : _login, // Disable button if loading
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0066ff),
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isLoading
                              ? customCircleProgress() // Show progress when loading
                              : Text(
                            'Login',
                            style: GoogleFonts.poppins(fontSize: 24,color: Colors.white,fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Sign Up Redirect
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Don\'t have an account?'),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/signup');
                              },
                              child: Text(
                                'Sign Up',
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFF0066ff),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
