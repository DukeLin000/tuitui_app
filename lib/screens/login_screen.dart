import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart'; // [新增]

class LoginScreen extends StatelessWidget {
  // [修改] 不再需要 onLoginSuccess callback
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("登入")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("歡迎來到 TuiTui", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: () {
                  // 1. 更新全域登入狀態
                  Provider.of<AuthProvider>(context, listen: false).login();
                  
                  // 2. 回傳 "true" 表示登入成功，並關閉頁面
                  Navigator.pop(context, true); 
                },
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("登入 / 註冊"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}