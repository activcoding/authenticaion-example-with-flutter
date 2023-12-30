import 'package:auth_example/auth_provider.dart';
import 'package:auth_example/helper_views/big_button.dart';
import 'package:auth_example/helper_views/error_view.dart';
import 'package:auth_example/helpers/api_exception.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class ActivateAccount extends StatefulWidget {
  const ActivateAccount({super.key});

  @override
  ActivateAccountState createState() => ActivateAccountState();
}

class ActivateAccountState extends State<ActivateAccount> {
  String authCode = '';
  bool _showError = false;
  String _errorTitle = "";
  String _errorMessage = "";

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activate Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/activate_account.png',
              height: 350,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: PinCodeTextField(
                beforeTextPaste: (text) {
                  if (text == null) {
                    return false;
                  }
                  // check if the text is a 4 digit number
                  if (text.length != 4) {
                    return false;
                  }
                  if (int.tryParse(text) == null) {
                    return false;
                  }
                  return true;
                },
                pinTheme: PinTheme(inactiveColor: Colors.grey),
                animationType: AnimationType.scale,
                keyboardType: TextInputType.number,
                appContext: context,
                length: 4,
                onChanged: (value) {
                  setState(() {
                    authCode = value;
                  });
                },
              ),
            ),
            const Text(
              'Check your emails and paste the activation code above. Long press the text field to paste.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.blueGrey,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Did not receive code?',
                  style: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    authProvider.sendActivationEmail();
                  },
                  child: const Text(
                    "Resend Code",
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            BigButton(
              text: 'Activate Account',
              onPressed: () async {
                try {
                  await authProvider.activateAccount(authCode);
                  displaySuccessAlert('Account Activated',
                      'Your account has been activated. You can now log in.');
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
            if (_showError)
              ErrorView(
                errorTitle: _errorTitle,
                errorMessage: _errorMessage,
              )
          ],
        ),
      ),
    );
  }

  void displayErrorAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void displaySuccessAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              // We need to pop twice because the first pop will pop the dialog and the second pop will pop the ActivateAccount screen
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text(
              'LogIn',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
