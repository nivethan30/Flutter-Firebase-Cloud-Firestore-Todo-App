import 'package:flutter/material.dart';

class AppTheme {
  /// A light theme.
  //
  /// This is the same as [ThemeData.light], but provided as a convenience for
  /// users of this class.
  static ThemeData lightTheme = ThemeData.light().copyWith(
      textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Poppins'));

  /// A dark theme.
  ///
  /// This is the same as [ThemeData.dark], but provided as a convenience for
  /// users of this class.
  static ThemeData darkTheme = ThemeData.dark().copyWith(
      textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'Poppins'));
}
