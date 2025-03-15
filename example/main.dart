import 'package:assets_file_generator/assets.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Asset Generator Example")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Assets Example"),
              Image.asset("${AssetsPaths.images}/example.png"),
            ],
          ),
        ),
      ),
    );
  }
}
