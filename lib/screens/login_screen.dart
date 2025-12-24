// lib/screens/login_screen.dart
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess; // 登入成功後的回調

  const LoginScreen({super.key, required this.onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 1. 新增 FormKey，這把鑰匙是用來控制整個表單驗證的
  final _formKey = GlobalKey<FormState>();

  bool _isLogin = true; // true = 登入, false = 註冊
  bool _showPassword = false;
  bool _rememberMe = false; // <--- 2. 新增這個變數來控制 Checkbox 狀態
  String _loginMethod = 'phone'; // 'phone' | 'email'
  
  // Form Controllers
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    // 2. 在送出時檢查表單是否有效
    if (_formKey.currentState!.validate()) { // <--- 關鍵：觸發驗證
      // 驗證通過，執行登入邏輯
      widget.onLoginSuccess();
    } else {
      // 驗證失敗，Flutter 會自動在輸入框下方顯示紅字錯誤
      print("表單驗證失敗");
    }
  }

  void _handleSocialLogin(String provider) {
    print("使用 $provider 登入");
    widget.onLoginSuccess();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 背景漸層
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFAF5FF), Color(0xFFFDF2F8), Color(0xFFFAF5FF)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // --- 1. Logo 區域 ---
                  Container(
                    width: 80, height: 80,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: [Colors.purple, Colors.pink]),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
                    ),
                    child: const Icon(Icons.favorite, color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 16),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(colors: [Colors.purple, Colors.pink]).createShader(bounds),
                    child: const Text("推推", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                  const SizedBox(height: 8),
                  const Text("發現生活，分享美好", style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 32),

                  // --- 2. 登入卡片 ---
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))],
                    ),
                    child: Form( // 用 Form 包住輸入框區域
                      key: _formKey, // 綁定鑰匙
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 切換標籤 (登入/註冊)
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(30)),
                            child: Row(
                              children: [
                                _TabButton(text: "登入", isActive: _isLogin, onTap: () => setState(() => _isLogin = true)),
                                _TabButton(text: "註冊", isActive: !_isLogin, onTap: () => setState(() => _isLogin = false)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // --- 姓名 (僅註冊顯示) ---
                          if (!_isLogin) ...[
                            const Text("姓名", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                            const SizedBox(height: 8),
                            _InputField(
                              controller: _nameController, 
                              hintText: "請輸入您的姓名",
                              validator: (value) {
                                if (!_isLogin && (value == null || value.isEmpty)) {
                                  return '請輸入姓名';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                          ],

                          if (_isLogin) ...[
                            Row(
                              children: [
                                Expanded(child: _MethodButton(icon: Icons.smartphone, text: "手機號碼", isSelected: _loginMethod == 'phone', onTap: () => setState(() => _loginMethod = 'phone'))),
                                const SizedBox(width: 8),
                                Expanded(child: _MethodButton(icon: Icons.email_outlined, text: "Email", isSelected: _loginMethod == 'email', onTap: () => setState(() => _loginMethod = 'email'))),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],

                          // --- 帳號 (手機/Email) ---
                          Text(_loginMethod == 'phone' && _isLogin ? "手機號碼" : "Email", style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          _InputField(
                            controller: (_loginMethod == 'phone' && _isLogin) ? _phoneController : _emailController,
                            hintText: (_loginMethod == 'phone' && _isLogin) ? "09xx-xxx-xxx" : "your@email.com",
                            prefixIcon: (_loginMethod == 'phone' && _isLogin) ? Icons.smartphone : Icons.email_outlined,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '此欄位必填';
                              }
                              if (_loginMethod == 'email' && !value.contains('@')) {
                                return '請輸入有效的 Email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // --- 密碼 ---
                          const Text("密碼", style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          _InputField(
                            controller: _passwordController,
                            hintText: "請輸入密碼",
                            prefixIcon: Icons.lock_outline,
                            obscureText: !_showPassword,
                            suffixIcon: IconButton(
                              icon: Icon(_showPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.grey),
                              onPressed: () => setState(() => _showPassword = !_showPassword),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '請輸入密碼';
                              }
                              if (value.length < 6) {
                                return '密碼長度至少需 6 碼';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // --- 記住我 & 忘記密碼 ---
                          if (_isLogin)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    // 3. 修改 Checkbox 邏輯
                                    Checkbox(
                                      value: _rememberMe, // 使用變數
                                      onChanged: (value) {
                                        setState(() {
                                          _rememberMe = value!; // 更新變數並重繪畫面
                                        });
                                      },
                                      activeColor: Colors.purple,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                    ),
                                    const Text("記住我", style: TextStyle(color: Colors.grey, fontSize: 13)),
                                  ],
                                ),
                                TextButton(onPressed: () {}, child: const Text("忘記密碼？", style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 13))),
                              ],
                            ),

                          // 註冊協議
                          if (!_isLogin)
                            const Padding(
                              padding: EdgeInsets.only(bottom: 16),
                              child: Text("註冊即表示您同意我們的服務條款和隱私政策", style: TextStyle(color: Colors.grey, fontSize: 12), textAlign: TextAlign.center),
                            ),

                          const SizedBox(height: 8),
                          
                          // 送出按鈕
                          ElevatedButton(
                            onPressed: _handleSubmit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              shadowColor: Colors.purple.withOpacity(0.3),
                              elevation: 8,
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: [Colors.purple, Colors.pink]),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                constraints: const BoxConstraints(minHeight: 50),
                                child: Text(_isLogin ? "登入" : "註冊", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),
                          const Row(children: [Expanded(child: Divider()), Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text("或使用以下方式", style: TextStyle(color: Colors.grey, fontSize: 12))), Expanded(child: Divider())]),
                          const SizedBox(height: 24),

                          // 社交登入按鈕
                          _SocialButton(text: "使用 Facebook 繼續", color: const Color(0xFF1877F2), textColor: Colors.white, icon: Icons.facebook, onTap: () => _handleSocialLogin('Facebook')),
                          const SizedBox(height: 12),
                          _SocialButton(text: "使用 Google 繼續", color: Colors.white, textColor: Colors.black87, icon: Icons.g_mobiledata, isBorder: true, onTap: () => _handleSocialLogin('Google')),
                          const SizedBox(height: 12),
                          _SocialButton(text: "使用 LINE 繼續", color: const Color(0xFF00B900), textColor: Colors.white, icon: Icons.chat_bubble, onTap: () => _handleSocialLogin('LINE')),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                  const Text("© 2024 推推 TuiTui · 讓分享更美好", style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- 輔助小組件 (Sub-Widgets) ---

class _TabButton extends StatelessWidget {
  final String text;
  final bool isActive;
  final VoidCallback onTap;
  const _TabButton({required this.text, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: isActive ? const LinearGradient(colors: [Colors.purple, Colors.pink]) : null,
            color: isActive ? null : Colors.transparent,
          ),
          alignment: Alignment.center,
          child: Text(text, style: TextStyle(color: isActive ? Colors.white : Colors.grey, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

class _MethodButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  const _MethodButton({required this.icon, required this.text, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.purple[50] : Colors.white,
          border: Border.all(color: isSelected ? Colors.purple : Colors.grey[200]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: isSelected ? Colors.purple : Colors.grey),
            const SizedBox(width: 4),
            Text(text, style: TextStyle(fontSize: 13, color: isSelected ? Colors.purple : Colors.grey, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final String? Function(String?)? validator;

  const _InputField({
    required this.controller, 
    required this.hintText, 
    this.prefixIcon, 
    this.suffixIcon, 
    this.obscureText = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField( 
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction, 
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.grey[400], size: 20) : null,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[200]!)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[200]!)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.purple)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red)),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final IconData icon;
  final bool isBorder;
  final VoidCallback onTap;

  const _SocialButton({required this.text, required this.color, required this.textColor, required this.icon, this.isBorder = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color,
          border: isBorder ? Border.all(color: Colors.grey[300]!) : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: 20),
            const SizedBox(width: 8),
            Text(text, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
