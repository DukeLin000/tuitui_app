// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
// [新增] 引入 RWD 容器
import '../../widgets/responsive_container.dart'; 
import 'signup_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // [新增] 控制輸入框與狀態
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // 用於表單驗證
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // [新增] 處理登入邏輯
  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      // 1. 顯示讀取圈圈
      setState(() => _isLoading = true);

      // 2. 呼叫 Provider 執行登入 (帶入帳號密碼)
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final success = await auth.login(
        _emailController.text, 
        _passwordController.text
      );

      // 3. 關閉讀取圈圈
      if (mounted) {
        setState(() => _isLoading = false);
      }

      // 4. 如果登入成功，關閉頁面並回傳 true
      if (success && mounted) {
        Navigator.pop(context, true); 
      } else if (mounted) {
        // 失敗提示 (這裡簡單用 SnackBar)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("登入失敗，請檢查帳號密碼"))
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("登入", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      // [關鍵修改] 使用 ResponsiveContainer 讓內容維持在中間
      body: ResponsiveContainer(
        child: Center(
          child: SingleChildScrollView( 
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch, 
                children: [
                  // 1. Logo 或標題區塊
                  const Icon(Icons.shopping_bag_outlined, size: 64, color: Colors.purple),
                  const SizedBox(height: 16),
                  const Text(
                    "歡迎來到 TuiTui", 
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "登入以繼續您的時尚旅程", 
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // 2. 輸入表單區塊
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      hintText: "請輸入您的電子信箱",
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Color(0xFFFAFAFA), // 微微的灰底，增加質感
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) return '請輸入 Email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: true, 
                    decoration: const InputDecoration(
                      labelText: "密碼",
                      hintText: "請輸入您的密碼",
                      prefixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Color(0xFFFAFAFA),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return '請輸入密碼';
                      return null;
                    },
                  ),

                  // 3. 忘記密碼連結
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (_) => const ForgotPasswordScreen())
                        );
                      },
                      child: const Text("忘記密碼？", style: TextStyle(color: Colors.grey)),
                    ),
                  ),
                  
                  const SizedBox(height: 24),

                  // 4. 登入按鈕
                  FilledButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.purple,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: _isLoading 
                      ? const SizedBox(
                          height: 24, width: 24, 
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                        )
                      : const Text("登入", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),

                  const SizedBox(height: 24),

                  // 5. 註冊引導區塊
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("還沒有帳號？", style: TextStyle(color: Colors.grey)),
                      GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const SignupScreen()),
                          );
                          
                          if (result == true && mounted) {
                            Navigator.pop(context, true);
                          }
                        },
                        child: const Text(
                          " 立即註冊", 
                          style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}