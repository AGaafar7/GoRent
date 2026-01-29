import 'package:flutter/material.dart';
import 'package:gorent/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gorent/screens/auth/auth_wrapper_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const AuthWrapper(),
    );
  }
}
