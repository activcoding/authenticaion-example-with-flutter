import 'package:auth_example/activate_account.dart';
import 'package:auth_example/helper_views/big_button.dart';
import 'package:auth_example/helper_views/error_view.dart';
import 'package:auth_example/helpers/api_exception.dart';
import 'package:auth_example/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_provider.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  String _name = '';
  String _email = '';
  String _password = '';

  bool _showError = false;
  String _errorTitle = "";
  String _errorMessage = "";
  final String _errorMessageButtonTitle = "";
  VoidCallback? _onErrorButtonPressed;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Enter your name',
                  labelText: 'Name',
                ),
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Enter your email',
                  labelText: 'Email',
                ),
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Enter your password',
                  labelText: 'Password',
                ),
                onChanged: (value) {
                  setState(() {
                    _password = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 16.0),
            BigButton(
              text: "Sign Up",
              onPressed: () async {
                // TODO: Check if name, email, and password are not empty
                UserModel user = UserModel(
                  name: _name,
                  email: _email,
                  password: _password,
                );
                try {
                  await authProvider.signUp(user);
                  authProvider.updateEmailAndPassword(
                    user.email,
                    user.password,
                  );
                  navigateForward();
                } catch (error) {
                  if (error is APIException) {
                    setState(() {
                      _errorTitle = error.code.toString();
                      _errorMessage = error.message;
                      _showError = true;
                    });
                  }
                }
              },
            ),
            const SizedBox(height: 16.0),
            if (_showError)
              ErrorView(
                errorTitle: _errorTitle,
                errorMessage: _errorMessage,
                buttonText: _errorMessageButtonTitle,
                onPress: _onErrorButtonPressed,
              ),
          ],
        ),
      ),
    );
  }

  void navigateForward() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => WillPopScope(
          onWillPop: () async => false,
          child: const ActivateAccount(),
        ),
      ),
    );
  }
}
