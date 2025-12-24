// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import '../widgets/waterfall_feed.dart';
import 'edit_profile_screen.dart'; // 1. 引入編輯頁面

// 改為 StatefulWidget，以便更新資料
class ProfileScreen extends StatefulWidget {
  final VoidCallback onSettingsTap;

  const ProfileScreen({super.key, required this.onSettingsTap});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // 2. 定義狀態變數 (模擬用戶資料)
  String _name = "推推用戶";
  String _bio = "歡迎來到我的試衣間 ✨ 分享日常穿搭與美好生活";
  String _avatar = "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100";

  // 假資料：我的作品
  static const List<WaterfallItem> _userWorks = [
    WaterfallItem(id: '1', image: 'https://images.unsplash.com/photo-1737214475335-8ed64d91f473?w=600', title: '我的作品集', authorName: 'Me', authorAvatar: '', likes: 1234, aspectRatio: 1.3),
    WaterfallItem(id: '2', image: 'https://images.unsplash.com/photo-1544580353-4a24b9074137?w=600', title: '日常隨拍', authorName: 'Me', authorAvatar: '', likes: 2341, aspectRatio: 1.5),
  ];

  // 3. 跳轉到編輯頁面並接收回傳值
  void _navigateToEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          currentName: _name,
          currentBio: _bio,
          currentAvatar: _avatar,
        ),
      ),
    );

    // 如果有回傳資料，則更新畫面
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _name = result['name'];
        _bio = result['bio'];
        // _avatar = result['avatar']; // 暫時沒做換圖，保留原圖
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text("Me", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.qr_code, color: Colors.black)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined, color: Colors.black)),
          IconButton(onPressed: widget.onSettingsTap, icon: const Icon(Icons.settings_outlined, color: Colors.black)),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // 1. 用戶資料
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // 讓內容靠左對齊
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(radius: 40, backgroundImage: NetworkImage(_avatar)),
                    const SizedBox(width: 24),
                    const Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _ProfileStatItem(count: "18", label: "Following"),
                          _ProfileStatItem(count: "32", label: "Followers"),
                          _ProfileStatItem(count: "128", label: "Like & Save"),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                // 顯示名字
                Text(_name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                // 顯示簡介
                Text(_bio, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                
                const SizedBox(height: 20),
                
                // Edit Profile 按鈕
                SizedBox(
                  width: double.infinity, 
                  child: _ProfileActionButton(
                    text: "Edit Profile", 
                    onTap: _navigateToEditProfile, // 綁定點擊事件
                  ),
                ),
              ],
            ),
          ),
          
          // 3. 底部作品
          Container(
            color: Colors.white,
            child: Column(
              children: [
                 Container(
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[200]!))),
                   child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(onPressed: (){}, child: const Text("Notes", style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold))),
                      TextButton(onPressed: (){}, child: const Text("Collect", style: TextStyle(color: Colors.grey))),
                      TextButton(onPressed: (){}, child: const Text("Likes", style: TextStyle(color: Colors.grey))),
                    ],
                   ),
                 ),
                Padding(padding: const EdgeInsets.all(8.0), child: WaterfallFeed(items: _userWorks)),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// --- 私有輔助組件 ---
class _ProfileStatItem extends StatelessWidget {
  final String count;
  final String label;
  const _ProfileStatItem({required this.count, required this.label});
  @override
  Widget build(BuildContext context) => Column(children: [Text(count, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey))]);
}

class _ProfileActionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap; // 新增 onTap 參數
  const _ProfileActionButton({required this.text, this.onTap});
  
  @override
  Widget build(BuildContext context) => OutlinedButton(
    onPressed: onTap ?? () {}, 
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.black, 
      side: BorderSide(color: Colors.grey[300]!), 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), 
      padding: const EdgeInsets.symmetric(vertical: 12)
    ), 
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold))
  );
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});
  @override
  Widget build(BuildContext context) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), const Row(children: [Text("View All", style: TextStyle(fontSize: 12, color: Colors.grey)), Icon(Icons.chevron_right, size: 16, color: Colors.grey)])]);
}

class _OrderIconItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _OrderIconItem({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) => Column(children: [Icon(icon, size: 28, color: Colors.grey[700]), const SizedBox(height: 8), Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey))]);
}