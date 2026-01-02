// lib/screens/main/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // [新增] 引入 Provider
import '../../models/post.dart';
import '../../widgets/post_card.dart';
import '../../models/waterfall_item.dart';
import '../../widgets/waterfall_feed.dart';
import '../../widgets/responsive_container.dart';
import '../../providers/post_provider.dart'; // [新增] 引入 PostProvider
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

  // [刪除] 原本的 static const _followingPosts 與 _discoveryItems
  // 現在資料都統一交給 PostProvider 管理

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
              // ---------------------------------------------------------------
              // 分頁 A：發現頁 (Discovery) - 使用 Provider 的 discoveryItems
              // ---------------------------------------------------------------
              Consumer<PostProvider>(
                builder: (context, postProvider, child) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: WaterfallFeed(items: postProvider.discoveryItems),
                  );
                },
              ),
              
              // ---------------------------------------------------------------
              // 分頁 B：追蹤頁 (Following) - 使用 Provider 的 items
              // ---------------------------------------------------------------
              Consumer<PostProvider>(
                builder: (context, postProvider, child) {
                  final posts = postProvider.items;
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        // PostCard 已經內建點擊跳轉邏輯
                        child: PostCard(post: post),
                      );
                    },
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