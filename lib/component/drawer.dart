import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Drawer customDrawer(BuildContext context, Function logout, User? user) {
  // Get the current logged-in user
  user = FirebaseAuth.instance.currentUser;

  return Drawer(
    backgroundColor: Colors.deepPurpleAccent,
    child: Column(
      children: <Widget>[
        // Custom Drawer Header with Gradient Background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.transparent),
            accountName: Text(
              user?.displayName ?? 'Guest',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            accountEmail: Text(
              user?.email ?? 'Not logged in',
              style: TextStyle(color: Colors.white60),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: user?.photoURL != null
                  ? NetworkImage(user!.photoURL!) // Show user photo URL if available
                  : AssetImage('assets/default_avatar.png') as ImageProvider, // Default image if no photo URL
              radius: 40.0,
            ),
          ),
        ),
        SizedBox(height: 20),

        // Profile Section with Elevated Card
        Card(
          elevation: 4,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListTile(
            leading: Icon(Icons.account_circle, color: Colors.deepPurple),
            title: Text('Profile', style: TextStyle(color: Colors.deepPurple)),
            onTap: () {
              // Add your profile navigation code here
            },
          ),
        ),
        const Divider(),

        // About Section with Custom Styling
        Card(
          elevation: 4,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListTile(
            leading: Icon(Icons.info, color: Colors.deepPurple),
            title: Text('About', style: TextStyle(color: Colors.deepPurple)),
            onTap: () {
              // Add your about section code here
            },
          ),
        ),
        const Divider(),

        // Logout Section with Gradient Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              )),
              padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 14)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.exit_to_app, color: Colors.white),
                SizedBox(width: 10),
                Text('Logout', style: TextStyle(color: Colors.white)),
              ],
            ),
            onPressed: () {
              logout(); // Perform logout
            },
          ),
        ),
      ],
    ),
  );
}
