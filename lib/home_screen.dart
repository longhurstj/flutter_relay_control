import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PC Smart Hub'),
      ),
      body: Column(
        children: [
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            padding: const EdgeInsets.all(16),
            children: [
              _buildCard(context, 'Power', Icons.devices, Colors.blueGrey,
                  '/relayControl'),
              _buildCard(context, 'Performance', Icons.display_settings,
                  Colors.blueGrey, '/performanceControl'),
              _buildCard(context, 'Applications', Icons.device_hub,
                  Colors.blueGrey, '/applicationsControl'),
              _buildCard(context, 'Log File', Icons.file_open, Colors.blueGrey,
                  '/logfileControl'),
            ],
          ),
          Center(
            child: ElevatedButton(
              child: const Text('Go to WebCam'),
              onPressed: () {
                Navigator.of(context).pushNamed('/camControl');
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.logout),
        onPressed: () async {
          try {
            await _auth.signOut();

            Navigator.of(context).pushNamedAndRemoveUntil(
              '/login',
              (route) => false,
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.toString()),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    String title,
    IconData pic,
    Color color,
    String route,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(route);
      },
      child: Card(
        color: color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.3,
                child: Icon(
                  pic,
                  color: Colors.white,
                  size: 60,
                ),
              ),
            ),
            Center(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
