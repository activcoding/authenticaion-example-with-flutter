import 'package:flutter/material.dart';

// Usage:
// ONLY in Stateful Widget
/*
String _textValue = "";
CommonTextField(
  hintText: 'Enter your email',
  labelText: 'Email',
  onChanged: (value) {
    setState(() {
      _textValue = value;
    });
  },
)
 */
class CommonTextField extends StatefulWidget {
  const CommonTextField(
      {super.key,
      required this.labelText,
      required this.hintText,
      required this.onChanged});

  final String labelText;
  final String hintText;
  final ValueChanged<String> onChanged;

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textEditingController,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.labelText,
      ),
    );
  }
}
