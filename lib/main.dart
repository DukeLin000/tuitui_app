import 'package:flutter/material.dart';
import 'screens/main_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const TuituiApp());
}

class TuituiApp extends StatefulWidget {
  const TuituiApp({super.key});

  @override
  State<TuituiApp> createState() => _TuituiAppState();
}

class _TuituiAppState extends State<TuituiApp> {
  // 記錄登入狀態
  bool _isLoggedIn = false; 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TuiTui',
      debugShowCheckedModeBanner: false,
      
      // 1. 在這裡套用「隱藏卷軸」的設定
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
      // 根據狀態決定顯示哪個畫面
      home: _isLoggedIn 
          ? const MainScreen() 
          : LoginScreen(
              onLoginSuccess: () {
                setState(() {
                  _isLoggedIn = true;
                });
              },
            ),
    );
  }
}

// 2. 定義一個自訂的滾動行為：隱藏卷軸
// 把這個類別放在檔案最下方即可
class NoScrollbarBehavior extends MaterialScrollBehavior {
  @override
  Widget buildScrollbar(BuildContext context, Widget child, ScrollableDetails details) {
    return child; // 直接回傳內容，不包裝 Scrollbar
  }
}