import 'dart:convert';

import 'package:auth_example/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  ProfileViewState createState() => ProfileViewState();
}

class ProfileViewState extends State<ProfileView> {
  String _ID = '';
  String _username = '';
  String _email = '';
  String _password = '';
  String _lastAuthCode = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    const requestURL = 'http://localhost:8081/exampleRestricted/getUser';
    final request = http.Request('POST', Uri.parse(requestURL));
    request.headers.addAll({
      'Content-Type': 'application/json',
      'Authorization':
          '${Provider.of<AuthProvider>(context, listen: false).jwt}',
    });
    request.body = json.encode({
      'email': '${Provider.of<AuthProvider>(context, listen: false).email}',
      'password':
          '${Provider.of<AuthProvider>(context, listen: false).password}',
    });
    final response = await request.send();
    if (response.statusCode == 200) {
      final responseString = await response.stream.bytesToString();
      final responseJSON = json.decode(responseString);
      setState(() {
        _ID = responseJSON['ID'];
        _username = responseJSON['Username'];
        _email = responseJSON['Email'];
        _password = responseJSON['Password'];
        _lastAuthCode = responseJSON['ActivationCode'];
      });
    } else {
      final responseBody = await response.stream.bytesToString();
      throw Exception(responseBody);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'UUID: $_ID',
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              'Email: $_email',
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              'Username: $_username',
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              'Password: $_password',
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              'Last Auth Code: $_lastAuthCode',
              style: const TextStyle(fontSize: 20),
            ),
            ElevatedButton(
              onPressed: () {
                authProvider.signOut();
              },
              child: const Text('Sign Out'),
            )
          ],
        ),
      ),
    );
  }
}
