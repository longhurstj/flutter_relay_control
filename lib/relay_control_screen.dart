import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RelayControlScreen extends StatefulWidget {
  const RelayControlScreen({super.key});

  @override
  _RelayControlScreenState createState() => _RelayControlScreenState();
}

class _RelayControlScreenState extends State<RelayControlScreen> {
  // IP address and port of the ESP32 board
  final String ip = '192.168.4.49';
  final int port = 80;

  bool _isSwitchedOn26 = false;
  bool _isSwitchedOn27 = false;

  void _sendRequest26(bool isSwitchedOn26) async {
    try {
      // Send a POST request to the ESP32 board
      final response = await http.post(
        Uri.http('$ip:$port', _isSwitchedOn26 ? '/26/on' : '/26/off'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, bool>{'isSwitchedOn': isSwitchedOn26}),
      );

      if (response.statusCode == 200) {
        // Update the UI with the new switch state
        setState(() {
          _isSwitchedOn26 = isSwitchedOn26;
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _sendRequest27(bool isSwitchedOn27) async {
    try {
      // Send a POST request to the ESP32 board
      final response = await http.post(
        Uri.http('$ip:$port', _isSwitchedOn27 ? '/27/on' : '/27/off'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, bool>{'isSwitchedOn': isSwitchedOn27}),
      );

      if (response.statusCode == 200) {
        // Update the UI with the new switch state
        setState(() {
          _isSwitchedOn27 = isSwitchedOn27;
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'ESP32 Relay Switch',
        home: Scaffold(
          appBar: AppBar(
            title: const Text("Relay Control"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          body: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Switch(
                      value: _isSwitchedOn26,
                      onChanged: (value) {
                        _sendRequest26(value);
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                        _isSwitchedOn26 ? 'Switch 1 is ON' : 'Switch 1 is OFF'),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Switch(
                      value: _isSwitchedOn27,
                      onChanged: (value) {
                        _sendRequest27(value);
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                        _isSwitchedOn27 ? 'Switch 2 is ON' : 'Switch 2 is OFF'),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
