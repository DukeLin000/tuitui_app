// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import '../widgets/waterfall_feed.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback onSettingsTap;

  const ProfileScreen({super.key, required this.onSettingsTap});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // 用戶資料狀態
  String _name = "推推用戶";
  String _bio = "歡迎來到我的試衣間 ✨ 分享日常穿搭與美好生活";
  String _avatar = "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100";

  // 假資料：我的作品
  static const List<WaterfallItem> _userWorks = [
    WaterfallItem(id: '1', image: 'https://images.unsplash.com/photo-1737214475335-8ed64d91f473?w=600', title: '我的作品集', authorName: 'Me', authorAvatar: '', likes: 1234, aspectRatio: 1.3),
    WaterfallItem(id: '2', image: 'https://images.unsplash.com/photo-1544580353-4a24b9074137?w=600', title: '日常隨拍', authorName: 'Me', authorAvatar: '', likes: 2341, aspectRatio: 1.5),
  ];

  // 編輯頁面跳轉
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

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _name = result['name'];
        _bio = result['bio'];
        // _avatar = result['avatar']; 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // [視覺一致性] 背景改為淺灰，與 Home/Market 一致
      backgroundColor: Colors.grey[50], 
      
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        // [RWD] 標題置中限制寬度
        title: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: const Text("Me", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ),
        actions: [
          // 這裡的按鈕可以保持在最右邊，或者如果您希望它們也跟著內容置中，可以用同樣的 Center 技巧包起來
          IconButton(onPressed: () {}, icon: const Icon(Icons.qr_code, color: Colors.black)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined, color: Colors.black)),
          IconButton(onPressed: widget.onSettingsTap, icon: const Icon(Icons.settings_outlined, color: Colors.black)),
        ],
      ),
      
      body: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: [
          // 1. 用戶資料區塊 (Profile Info)
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Container(
                color: Colors.white, // 卡片白色背景
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    Text(_name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(_bio, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                    
                    const SizedBox(height: 20),
                    
                    // Edit Profile 按鈕
                    SizedBox(
                      width: double.infinity, 
                      child: _ProfileActionButton(
                        text: "Edit Profile", 
                        onTap: _navigateToEditProfile, 
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // 2. 底部作品區 (Works Tab & Feed)
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    // Tabs
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
                    
                    // 瀑布流作品集
                    // [RWD] 這裡也要限制 padding，與上面對齊
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0), 
                      child: WaterfallFeed(items: _userWorks),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// --- 私有輔助組件 (保持不變) ---
class _ProfileStatItem extends StatelessWidget {
  final String count;
  final String label;
  const _ProfileStatItem({required this.count, required this.label});
  @override
  Widget build(BuildContext context) => Column(children: [Text(count, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey))]);
}

class _ProfileActionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
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