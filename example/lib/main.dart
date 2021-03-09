import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_api_headers/google_api_headers.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, String>? _headers;

  @override
  void initState() {
    super.initState();
    getHeaders();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text(
            'Google API headers: ${_headers.toString()}',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Future<void> getHeaders() async {
    final headers = await GoogleApiHeaders().getHeaders();
    setState(() => _headers = headers);
  }
}
