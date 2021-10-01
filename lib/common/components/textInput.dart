import 'package:flutter/material.dart';

Widget textInput({
  required TextEditingController controller,
  required String hintText,
  required TextInputType keyboardType,
  required String label,
  required String? Function(String?) validate,
  bool isPassword = false,
  bool readOnly = false,
  ValueChanged<String>? onChange,
  ValueChanged<String>? onSubmit,
  int? maxLines,
  IconData? suffix,
  VoidCallback? suffixPressed,
  VoidCallback? onTap,
  TextCapitalization textCapitalization = TextCapitalization.sentences,
}) =>
    TextFormField(
      validator: validate,
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      textCapitalization: textCapitalization,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: label,
        border: OutlineInputBorder(),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: suffixPressed,
                icon: Icon(
                  suffix,
                ),
              )
            : null,
      ),
      onChanged: onChange,
      onFieldSubmitted: onSubmit,
      readOnly: readOnly,
      onTap: onTap,
    );
