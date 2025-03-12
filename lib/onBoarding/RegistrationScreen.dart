import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../component/circular_progess_indecator.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _auth = FirebaseAuth.instance; // Firebase Auth instance

  bool _isLoading = false; // To handle loading state

  // Signup function
  Future<void> _signup() async {
    if (_passwordController.text == _confirmPasswordController.text) {
      try {
        setState(() {
          _isLoading = true; // Set loading to true when starting the signup
        });

        // Create a new user with email and password
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        setState(() {
          _isLoading = false; // Set loading to false when finished
        });

        // Navigate to login or home screen after successful signup
        Navigator.pushReplacementNamed(context, '/login');
      } on FirebaseAuthException catch (e) {
        setState(() {
          _isLoading = false; // Set loading to false on error
        });

        // Show an error message if signup fails
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? 'Error occurred')));
      }
    } else {
      // Show an error if passwords don't match
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf3f4f6),
      appBar: AppBar(
        title: Text(
          'Sign Up',
          style: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.teal,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/login-lo.jpg', // Make sure the image path is correct
                fit: BoxFit.cover, // Ensure it covers the entire screen
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
        
                children: [
        
                  // Add Logo or Icon
                  Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.deepPurple, Colors.purpleAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Icon(
                      Icons.person_add_alt_1_outlined,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Email Field
                  Container(
                    height: MediaQuery.of(context).size.height*0.65,
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
                      ],),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        _buildTextField(
                          controller: _emailController,
                          label: 'Email',
                          icon: Icons.email,
                          obscureText: false,
                        ),
                        const SizedBox(height: 20),
                        // Password Field
                        _buildTextField(
                          controller: _passwordController,
                          label: 'Password',
                          icon: Icons.lock,
                          obscureText: true,
                        ),
                        const SizedBox(height: 20),
                        // Confirm Password Field
                        _buildTextField(
                          controller: _confirmPasswordController,
                          label: 'Confirm Password',
                          icon: Icons.lock,
                          obscureText: true,
                        ),
                        const SizedBox(height: 30),
                        // Sign Up Button
                        _buildSignupButton(),
                        const SizedBox(height: 20),
                        // Already have an account
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Already have an account?'),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/login');
                              },
                              child: Text(
                                'Login',
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Custom method to build text fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool obscureText,
  }) {
    return Container(
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(icon),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: Colors.deepPurple, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: Colors.grey, width: 1),
          ),
        ),
      ),
    );
  }

  // Custom method for signup button
  Widget _buildSignupButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _signup, // Disable button if loading
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0066ff),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 100),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: _isLoading ? 0 : 5,
      ),
      child: _isLoading
          ? customCircleProgress() // Show progress when loading
          : Text(
        'Sign Up',
        style: GoogleFonts.poppins(fontSize: 18),
      ),
    );
  }
}
