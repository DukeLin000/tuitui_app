import 'package:flutter/material.dart';
import '../../models/post.dart';
import '../../widgets/post_card.dart';
import '../../models/waterfall_item.dart';
import '../../widgets/waterfall_feed.dart';
import '../../widgets/responsive_container.dart';
// [注意] 請確保您已經依照上一步驟建立了 search_screen.dart，若尚未建立請先建立該檔案
import '../../screens/shop/search_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(Map<String, dynamic>)? onUserTap;

  const HomeScreen({super.key, this.onUserTap});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // 1. 追蹤頁資料 (Following) - 使用您原本的 Post 資料
  // 這邊模擬關注的人發的貼文列表
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
      timestamp: '2小時前'
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
      timestamp: '5小時前'
    ),
  ];

  // 2. 發現頁資料 (Discovery) - 使用 WaterfallItem
  // 這是給「探索」分頁用的瀑布流
  static const List<WaterfallItem> _discoveryItems = [
    WaterfallItem(id: '3', image: 'https://images.unsplash.com/photo-1737214475335-8ed64d91f473?w=600', title: '2024 最新法式指甲設計', authorName: 'Nail Studio', authorAvatar: 'https://images.unsplash.com/photo-1589553009868-c7b2bb474531?w=100', likes: 1234, aspectRatio: 1.3),
    WaterfallItem(id: '4', image: 'https://images.unsplash.com/photo-1544580353-4a24b9074137?w=600', title: '韓系穿搭分享', authorName: 'Amy', authorAvatar: 'https://images.unsplash.com/photo-1589553009868-c7b2bb474531?w=100', likes: 2341, aspectRatio: 1.5),
    WaterfallItem(id: '5', image: 'https://images.unsplash.com/photo-1634850034923-31cda5d080f5?w=600', title: '中山站咖啡廳推薦', authorName: 'Cafe Lover', authorAvatar: 'https://images.unsplash.com/photo-1589553009868-c7b2bb474531?w=100', likes: 892, aspectRatio: 1.2),
    // 增加一點假資料讓版面看起來豐富些
    WaterfallItem(id: '6', image: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=600', title: '春季穿搭靈感', authorName: 'Style Icon', authorAvatar: '', likes: 520, aspectRatio: 1.4),
  ];

  @override
  void initState() {
    super.initState();
    // 初始化 TabController，長度 2 代表有兩個分頁
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // 跳轉到搜尋頁 (點擊頂部搜尋框時觸發)
  void _onSearchTap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 改為白色背景比較清爽
      
      // 使用 NestedScrollView 讓搜尋框可以跟著滑動隱藏 (社群 App 標準體驗)
      body: ResponsiveContainer(
        child: NestedScrollView(
          floatHeaderSlivers: true, // 往下滑隱藏 AppBar，往上滑顯示
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                pinned: true, // TabBar 是否固定在頂部
                floating: true, // AppBar 是否隨手勢浮動
                snap: true,
                titleSpacing: 16, // 調整左右間距
                
                // 1. 頂部搜尋框 (偽裝成輸入框的按鈕)
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
                
                // 2. 分頁標籤 (發現 / 追蹤)
                bottom: TabBar(
                  controller: _tabController,
                  labelColor: Colors.purple, // 選中顏色
                  unselectedLabelColor: Colors.grey, // 未選中顏色
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  indicatorColor: Colors.purple,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorWeight: 3,
                  tabs: const [
                    Tab(text: "發現"), // 對應 WaterfallFeed
                    Tab(text: "追蹤"), // 對應 PostCard 列表
                  ],
                ),
              ),
            ];
          },
          
          // 3. 內容區域 (對應 Tab)
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
                    child: GestureDetector(
                      onTap: () {
                        if (widget.onUserTap != null) {
                          widget.onUserTap!({
                            'name': post.authorName,
                            'avatar': post.authorAvatar,
                            'verified': post.verified
                          });
                        }
                      },
                      child: PostCard(post: post),
                    ),
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