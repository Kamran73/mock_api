import 'package:flutter/material.dart';

extension ContextX on BuildContext {
  TextTheme get textTheme => theme.textTheme;
  ThemeData get theme => Theme.of(this);
}
