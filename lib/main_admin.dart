import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/banner_store.dart';
import 'data/product_store.dart';
import 'src/admin/presentation/admin_shell.dart';
import 'src/core/theme/admin_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
  ChangeNotifierProvider(create: (_) => ProductStore()),
  ChangeNotifierProvider(create: (_) => BannerStore()),
      ],
      child: const AdminApp(),
    ),
  );
}

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