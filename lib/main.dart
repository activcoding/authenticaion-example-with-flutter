import 'package:auth_example/profile_view.dart';
import 'package:auth_example/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return MaterialApp(
      title: 'Auth Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: authProvider.email != null && authProvider.password != ''
            ? const ProfileView()
            : const SignInScreen(),
      ),
    );
  }
}
