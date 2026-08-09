import 'package:flutter/material.dart';
import 'package:flutter_application_2/screens/shop/watch_page.dart';

class AdminWatchScreen extends StatelessWidget {
  const AdminWatchScreen({super.key});

  @override
  Widget build(BuildContext context) => const WatchPage(isAdmin: true);
}