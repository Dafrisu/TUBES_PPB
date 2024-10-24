// main.dart
import 'package:flutter/material.dart'; // Import the DashboardPage

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Navbar
      appBar: AppBar(
        title: const Text('Hello, Asep',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        actions: <Widget>[
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Handle search button press
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Handle profile button press
            },
          ),
          IconButton(
            icon: const Icon(Icons.mail),
            onPressed: () {
              // Handle inbox button press
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications button press
            },
          ),
        ],
      ),
    );
  }
}
