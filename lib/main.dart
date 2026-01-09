// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // [新增] 引入多語言套件
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'providers/auth_provider.dart'; 
import 'providers/post_provider.dart';
import 'screens/main/main_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PostProvider()),
      ],
      child: const TuituiApp(),
    ),
  );
}

class TuituiApp extends StatelessWidget {
  const TuituiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TuiTui',
      debugShowCheckedModeBanner: false,
      scrollBehavior: NoScrollbarBehavior(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF9FAFB),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black87),
          titleTextStyle: TextStyle(
            color: Colors.black87, 
            fontWeight: FontWeight.bold, 
            fontSize: 18
          ),
        ),
      ),
      // [新增] 語系設定，讓 DatePicker 支援中文介面，否則會報錯
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('zh', 'TW'), // 繁體中文
        Locale('en', 'US'), // 英文
      ],
      home: const MainScreen(),
    );
  }
}

class NoScrollbarBehavior extends MaterialScrollBehavior {
  @override
  Widget buildScrollbar(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}