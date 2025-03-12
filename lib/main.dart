import 'package:flutter/material.dart';
import 'component/fcm_messaging_service.dart';
import 'component/notifications_screen.dart';
import 'firebase_options.dart'; // Import the generated Firebase options
import 'home_screen.dart'; // Your Home Screen import
import 'onBoarding/RegistrationScreen.dart';
import 'onBoarding/loginScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  // Ensure Firebase is initialized before the app starts
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Use the generated Firebase options
  );
  await FcmMessageService().initialize();
  NotificationService().initNotification();
  runApp(const GoogleMapsApp());
}

class GoogleMapsApp extends StatelessWidget {
  const GoogleMapsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Maps App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Initial Route is determined based on Firebase Authentication status
      home: AuthWrapper(),
      routes: {
        // Home screen route
        '/login': (context) => const LoginScreen(), // Login screen route
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const HomeScreen(), // Home screen route
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      // This checks if a user is logged in
      future: FirebaseAuth.instance.authStateChanges().first,
      builder: (context, snapshot) {
        // If the user is logged in, navigate to the home screen
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()), // Show loading while checking authentication status
          );
        }

        if (snapshot.hasData) {
          // User is signed in
          return const HomeScreen();
        } else {
          // User is not signed in
          return const LoginScreen();
        }
      },
    );
  }
}
