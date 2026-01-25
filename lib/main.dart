import 'package:flutter/material.dart';
import 'package:gorent/screens/accountownerscreens/home_account_owner_screen.dart';

import 'package:gorent/screens/testerscreens/tester_home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const AccountOwnerHome(),
    );
  }
}
