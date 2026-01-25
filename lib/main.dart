import 'package:flutter/material.dart';
import 'package:gorent/screens/accountownerscreens/home_account_owner_screen.dart';
import 'package:gorent/screens/publisherscreens/publisher_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const PublisherHome(),
    );
  }
}
