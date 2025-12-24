// lib/widgets/user_profile_modal.dart
import 'package:flutter/material.dart';
import '../screens/chat_room_screen.dart'; // 引入聊天室頁面
import 'waterfall_feed.dart';

// 改為 StatefulWidget 以處理關注狀態變化
class UserProfileModal extends StatefulWidget {
  final Map<String, dynamic> user;
  final VoidCallback onBack;

  const UserProfileModal({super.key, required this.user, required this.onBack});

  @override
  State<UserProfileModal> createState() => _UserProfileModalState();
}

class _UserProfileModalState extends State<UserProfileModal> {
  // 記錄是否已關注 (預設為 false)
  bool _isFollowing = false;

  // 模擬這個用戶的貼文數據
  List<WaterfallItem> get _userPosts => [
    WaterfallItem(id: '1', image: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=600', title: '暖暖的過冬 ❄️', authorName: widget.user['name'], authorAvatar: widget.user['avatar'], likes: 239, aspectRatio: 1.4),
    WaterfallItem(id: '2', image: 'https://images.unsplash.com/photo-1529139574466-a302c2d36214?w=600', title: '#被自己帥暈', authorName: widget.user['name'], authorAvatar: widget.user['avatar'], likes: 243, aspectRatio: 1.2),
    WaterfallItem(id: '3', image: 'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=600', title: '今日穿搭 OOTD', authorName: widget.user['name'], authorAvatar: widget.user['avatar'], likes: 1120, aspectRatio: 1.5),
    WaterfallItem(id: '4', image: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=600', title: '工作花絮', authorName: widget.user['name'], authorAvatar: widget.user['avatar'], likes: 89, aspectRatio: 1.0),
  ];

  // 處理關注點擊
  void _toggleFollow() {
    setState(() {
      _isFollowing = !_isFollowing;
    });
  }

  // 處理聊天點擊
  void _openChat() {
    // 使用 Navigator 推入聊天頁面
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatRoomScreen(
          chatId: widget.user['name'], // 暫時用名字當 ID
          onBack: () => Navigator.pop(context), // 返回時關閉聊天室
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. 背景漸層
          Container(
            height: 400,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF9C27B0), Color(0xFFFF4081)],
              ),
            ),
          ),

          // 2. 主要內容
          Column(
            children: [
              // 頂部導航列
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: widget.onBack,
                      ),
                      const Text("返回", style: TextStyle(color: Colors.white, fontSize: 16)),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.share, color: Colors.white),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),

              // 用戶資料區塊
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // 頭像
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(widget.user['avatar']),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // 文字資料
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.user['name'],
                                style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                "rednote ID: 42942190219",
                                style: TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                              const Text(
                                "IP Address: Beijing",
                                style: TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "歡迎來到我的試衣間 ✨ 分享日常穿搭與美好生活",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.email_outlined, color: Colors.white70, size: 16),
                        const SizedBox(width: 4),
                        const Text("1158126847@qq.com", style: TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // 數據統計
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _StatItem(count: "0", label: "Following"),
                        SizedBox(width: 24),
                        _StatItem(count: "2,589", label: "Followers"),
                        SizedBox(width: 24),
                        _StatItem(count: "15.3K", label: "Likes & Saves"),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // 按鈕區 (Follow + Chat)
                    Row(
                      children: [
                        // --- 關注按鈕 (互動功能) ---
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _toggleFollow, // 綁定點擊事件
                            style: ElevatedButton.styleFrom(
                              // 根據狀態改變顏色：未關注(紅) / 已關注(灰)
                              backgroundColor: _isFollowing ? Colors.transparent : const Color(0xFFFF1744),
                              foregroundColor: Colors.white,
                              side: _isFollowing ? const BorderSide(color: Colors.white) : null, // 已關注時顯示邊框
                              shape: const StadiumBorder(),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              elevation: _isFollowing ? 0 : 2,
                            ),
                            child: Text(
                              _isFollowing ? "Following" : "Follow", // 根據狀態改變文字
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        
                        // --- 聊天按鈕 (互動功能) ---
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 20),
                            onPressed: _openChat, // 綁定聊天事件
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),

              // 下方貼文區塊
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Column(
                    children: [
                      // Tab Bar
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
                        ),
                        child: const Center(
                          child: Text(
                            "Notes",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ),
                      // 瀑布流內容
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(8),
                          child: WaterfallFeed(items: _userPosts),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 內部小組件：數據統計
class _StatItem extends StatelessWidget {
  final String count;
  final String label;
  const _StatItem({required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(count, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }
}