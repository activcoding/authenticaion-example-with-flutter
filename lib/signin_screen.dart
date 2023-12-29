import 'package:auth_example/helper_views/big_button.dart';
import 'package:auth_example/helper_views/error_view.dart';
import 'package:auth_example/helper_views/text_field.dart';
import 'package:auth_example/helpers/api_exception.dart';
import 'package:auth_example/signup_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String _email = "";
  String _password = "";

  bool _showError = false;
  String _errorTitle = "";
  String _errorMessage = "";
  String _errorMessageButtonTitle = "";
  VoidCallback? _onErrorButtonPressed;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome!',
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Please login to continue',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 50.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CommonTextField(
                labelText: "Email",
                hintText: "Enter your email",
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CommonTextField(
                labelText: "Password",
                hintText: "Enter your password",
                onChanged: (value) {
                  setState(() {
                    _password = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 16.0),
            BigButton(
              text: "Sign In",
              onPressed: () async {
                try {
                  await authProvider.signIn(_email, _password);
                } catch (error) {
                  if (error is APIException) {
                    setState(() {
                      _errorTitle = error.code.toString();
                      _errorMessage = error.message;

                      // This error message can be changed in the GO API where it is defined;
                      if (error.message == 'Account not activated') {
                        _errorMessageButtonTitle = "Activate Account";
                        _onErrorButtonPressed = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpView(),
                            ),
                          );
                        };
                      }
                      _showError = true;
                    });
                  }
                }
              },
            ),
            if (_showError)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ErrorView(
                  errorMessage: _errorMessage,
                  errorTitle: _errorTitle,
                  buttonText: _errorMessageButtonTitle,
                  onPress: _onErrorButtonPressed,
                ),
              ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account?",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpView(),
                      ),
                    );
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
