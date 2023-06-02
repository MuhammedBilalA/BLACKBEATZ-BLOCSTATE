import 'package:black_beatz/core/colors/colors.dart';
import 'package:flutter/material.dart';

snackbarAdding({
  required String text,
  required BuildContext context,
}) {
  return ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        width: 250,
        duration: const Duration(seconds: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: snackbarBagroundColorDark,
        content: Center(child: Text(text))));
}

snackbarRemoving({
  required String text,
  required BuildContext context,
}) {
  return ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        width: 250,
        duration: const Duration(seconds: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: snackbarBagroundColorLight,
        content: Center(
            child: Text(
          text,
          style: const TextStyle(color: snackbarBagroundColorDark),
        ))));
}
