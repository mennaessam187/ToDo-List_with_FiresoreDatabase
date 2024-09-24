import 'package:flutter/material.dart';

TextFormField Addtext(String hint, TextEditingController controller,
    Widget icon, String? Function(String?) validate, Function()? onTap) {
  return TextFormField(
    onTap: onTap,
    validator: validate,
    controller: controller,
    decoration: InputDecoration(
      fillColor: Color.fromARGB(184, 150, 201, 241),
      filled: true,
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white),
      suffixIcon: icon,
      border: InputBorder.none, // No border
      enabledBorder: InputBorder.none, // No border when not focused
      focusedBorder: InputBorder.none, // No border when focused
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    ),
    style: const TextStyle(fontSize: 15),
  );
}
