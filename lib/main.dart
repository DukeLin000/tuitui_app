import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'providers/auth_provider.dart'; // [新增]
import 'screens/main_screen.dart';
// import 'screens/login_screen.dart'; // [移除] 這裡不需要了

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()), // [新增] 註冊 AuthProvider
      ],
      child: const TuituiApp(),
    ),
  );
}

class TuituiApp extends StatelessWidget {
  const TuituiApp({super.key});

  // [移除] _isLoggedIn 狀態變數，改由 Provider 管理

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TuiTui',
      debugShowCheckedModeBanner: false,
      scrollBehavior: NoScrollbarBehavior(),
      theme: ThemeData(
        // ... (保持原本的主題設定)
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
      // [關鍵修改] 無論是否登入，一律先進入主畫面
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