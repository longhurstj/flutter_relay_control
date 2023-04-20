import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PerformanceControlScreen extends StatefulWidget {
  const PerformanceControlScreen({super.key});

  @override
  _PerformanceControlScreenState createState() =>
      _PerformanceControlScreenState();
}

class _PerformanceControlScreenState extends State<PerformanceControlScreen> {
  String _cpuPercent = '0';
  String _memPercent = '0';
  String _batteryPercent = '0';
  String _powerPlugged = 'false';
  List<String> _topProcesses = [];

  void _fetchData() async {
    final response = await http.post(Uri.parse('http://192.168.4.1/data'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _cpuPercent = data['cpu_percent_total'].toStringAsFixed(1);
        _memPercent = data['mem_percent'].toStringAsFixed(1);
        _batteryPercent = data['battery_percent'].toStringAsFixed(1);
        _powerPlugged = data['power_plugged'].toString();
        _topProcesses = List<String>.from(data['cpu_top5_process']);
      });
    } else {
      throw Exception('Failed to fetch data from server');
    }
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (_) => _fetchData());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('System Monitor'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('CPU Usage: $_cpuPercent%'),
              Text('Memory Usage: $_memPercent%'),
              Text('Battery Level: $_batteryPercent%'),
              Text('Power Plugged: $_powerPlugged'),
              const SizedBox(height: 16),
              const Text('Top 5 CPU Usage Processes:'),
              for (var process in _topProcesses) Text(process),
            ],
          ),
        ),
      ),
    );
  }
}
