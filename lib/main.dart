import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'providers/recently_viewed_provider.dart';
import 'screens/root_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  // 1. Bắt buộc phải có dòng này để Flutter chuẩn bị nền tảng
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Khởi tạo Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 3. Chạy app của bạn (giữ nguyên MultiProvider)
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => RecentlyViewedProvider()),
      ],
      child: const AppleStoreApp(),
    ),
  );
}

class AppleStoreApp extends StatelessWidget {
  const AppleStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Apple Store Clone',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
        ),

        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          secondary: Colors.blueAccent,
          surface: Color(0xFF1C1C1E),
        ),

        textTheme: ThemeData.dark().textTheme.apply(
          fontFamily: '.SF Pro Display',
        ),

        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1C1C1E),
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
        ),
      ),
      home: const RootScreen(),
    );
  }
}