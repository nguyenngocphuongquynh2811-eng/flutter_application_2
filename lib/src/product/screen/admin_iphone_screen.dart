import 'package:flutter/material.dart';
import 'package:flutter_application_2/screens/shop/iphone_page.dart';

class AdminIphoneScreen extends StatelessWidget {
  const AdminIphoneScreen({super.key});

  @override
  Widget build(BuildContext context) => const IphonePage(isAdmin: true);
}