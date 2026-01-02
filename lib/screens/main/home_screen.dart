// lib/screens/main/home_screen.dart
import 'package:flutter/material.dart';
import '../../models/post.dart';
import '../../widgets/post_card.dart';
import '../../models/waterfall_item.dart';
import '../../widgets/waterfall_feed.dart';
import '../../widgets/responsive_container.dart';
// 引入搜尋頁面
import '../shop/search_screen.dart';

class HomeScreen extends StatefulWidget {
  // [修改] 移除 onUserTap，因為現在點擊邏輯已經下放到各個組件內部
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // 1. 追蹤頁資料 (Following) - 使用 Post 模型
  // 注意：這裡的 isMerchant 設定會影響 PostCard 點擊頭像後的去處
  static const List<Post> _followingPosts = [
    Post(
      id: '1',
      authorName: '美食探險家小雅',
      authorAvatar: 'https://images.unsplash.com/photo-1589553009868-c7b2bb474531?w=100',
      verified: true,
      content: '今天發現了一家超讚的台灣小吃店！滷肉飯香氣撲鼻 😋',
      image: 'https://images.unsplash.com/photo-1617422725360-45b7671f980b?w=800',
      likes: 342,
      comments: 28,
      timestamp: '2小時前',
      isMerchant: false, // 個人 -> 去 ProfileScreen
    ),
    Post(
      id: '2',
      authorName: '時尚達人 Amy',
      authorAvatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100',
      verified: true,
      content: '新入手的秋冬穿搭分享 ✨ 這件針織外套質感真的超好！',
      image: 'https://images.unsplash.com/photo-1532453288672-3a27e9be9efd?w=800',
      likes: 856,
      comments: 124,
      timestamp: '5小時前',
      isMerchant: false, // 個人
    ),
    // 可以加一個商家的例子
    Post(
      id: '3',
      authorName: 'Nail Studio',
      authorAvatar: 'https://images.unsplash.com/photo-1596462502278-27bfdd403348?w=100',
      verified: true,
      content: '本週新款指甲彩繪，預約請私訊！💅',
      image: 'https://images.unsplash.com/photo-1632515949706-e74736173042?w=800',
      likes: 120,
      comments: 5,
      timestamp: '1天前',
      isMerchant: true, // 商家 -> 去 StoreProfileScreen
    ),
    // [新增] 個人測試帳號 (在追蹤列表)
    Post(
      id: 'test_user_1',
      authorName: '測試人員小明', 
      authorAvatar: 'https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=100', 
      verified: false, 
      content: '這是一則個人帳號的測試貼文，點擊我的頭像應該會跳轉到 ProfileScreen (看別人模式)！🚀', 
      image: 'https://images.unsplash.com/photo-1516762689617-e1cffcef479d?w=800', 
      likes: 10, 
      comments: 2, 
      timestamp: '剛剛',
      isMerchant: false, // [關鍵] 設定為 false，代表是個人
    ),
  ];

  // 2. 發現頁資料 (Discovery) - 使用 WaterfallItem 模型
  static const List<WaterfallItem> _discoveryItems = [
    // [商家範例] 點擊頭像 -> StoreProfileScreen
    WaterfallItem(
      id: '3', 
      image: 'https://images.unsplash.com/photo-1737214475335-8ed64d91f473?w=600', 
      title: '2024 最新法式指甲設計', 
      authorName: 'Nail Studio', 
      authorAvatar: 'https://images.unsplash.com/photo-1589553009868-c7b2bb474531?w=100', 
      likes: 1234, 
      aspectRatio: 1.3,
      isMerchant: true // 設定為商家
    ),
    // [個人範例] 點擊頭像 -> ProfileScreen
    WaterfallItem(
      id: '4', 
      image: 'https://images.unsplash.com/photo-1544580353-4a24b9074137?w=600', 
      title: '韓系穿搭分享', 
      authorName: 'Amy', 
      authorAvatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100', 
      likes: 2341, 
      aspectRatio: 1.5,
      isMerchant: false // 設定為個人
    ),
    WaterfallItem(
      id: '5', 
      image: 'https://images.unsplash.com/photo-1634850034923-31cda5d080f5?w=600', 
      title: '中山站咖啡廳推薦', 
      authorName: 'Cafe Lover', 
      authorAvatar: 'https://images.unsplash.com/photo-1589553009868-c7b2bb474531?w=100', 
      likes: 892, 
      aspectRatio: 1.2,
      isMerchant: false
    ),
    WaterfallItem(
      id: '6', 
      image: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=600', 
      title: '春季穿搭靈感', 
      authorName: 'Style Icon', 
      authorAvatar: '', 
      likes: 520, 
      aspectRatio: 1.4,
      isMerchant: false
    ),
    // [新增] 個人測試帳號 (在瀑布流)
    WaterfallItem(
      id: 'test_user_2', 
      image: 'https://images.unsplash.com/photo-1503342217505-b0815a046baf?w=600', 
      title: '週末去哪玩？', 
      authorName: '愛旅遊的 Cathy', 
      authorAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100', 
      likes: 88, 
      aspectRatio: 1.2,
      isMerchant: false // [關鍵] 設定為 false，點擊頭像會去 ProfileScreen
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // 跳轉到搜尋頁
  void _onSearchTap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      // 使用 NestedScrollView 讓搜尋框可以跟著滑動隱藏
      body: ResponsiveContainer(
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                pinned: true,
                floating: true,
                snap: true,
                titleSpacing: 16,
                
                // 1. 頂部搜尋框
                title: GestureDetector(
                  onTap: _onSearchTap,
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, size: 20, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          "搜尋好店、穿搭靈感...", 
                          style: TextStyle(color: Colors.grey[400], fontSize: 14)
                        ),
                      ],
                    ),
                  ),
                ),
                
                // 2. 分頁標籤
                bottom: TabBar(
                  controller: _tabController,
                  labelColor: Colors.purple,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  indicatorColor: Colors.purple,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorWeight: 3,
                  tabs: const [
                    Tab(text: "發現"),
                    Tab(text: "追蹤"),
                  ],
                ),
              ),
            ];
          },
          
          // 3. 內容區域
          body: TabBarView(
            controller: _tabController,
            children: [
              // 分頁 A：發現頁 (Discovery) - 瀑布流
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: WaterfallFeed(items: _discoveryItems),
              ),
              
              // 分頁 B：追蹤頁 (Following) - 貼文列表
              ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                itemCount: _followingPosts.length,
                itemBuilder: (context, index) {
                  final post = _followingPosts[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    // [修改] 這裡不需要再包 GestureDetector 去觸發 onUserTap
                    // 因為 PostCard 內部應該要處理好點擊邏輯
                    child: PostCard(post: post),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}