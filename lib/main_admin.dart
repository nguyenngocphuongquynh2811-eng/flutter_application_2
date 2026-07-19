import 'package:flutter/material.dart';

import 'src/admin/presentation/admin_shell.dart';
import 'src/core/theme/admin_theme.dart';

void main() => runApp(const AdminApp());

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin',
      debugShowCheckedModeBanner: false,
      theme: buildAdminTheme(),
      home: const AdminShell(),
    );
  }
}