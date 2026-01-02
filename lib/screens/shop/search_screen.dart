// lib/screens/main/search_screen.dart
import 'package:flutter/material.dart';
import '../../widgets/responsive_container.dart';
import '../../widgets/waterfall_feed.dart';
import '../../models/waterfall_item.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  
  // 模擬搜尋結果數據
  final List<WaterfallItem> _mockResults = [
    WaterfallItem(id: 's1', image: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=600', title: '搜尋到的韓系穿搭', authorName: 'Nana', authorAvatar: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=100', likes: 520, aspectRatio: 1.5),
    WaterfallItem(id: 's2', image: 'https://images.unsplash.com/photo-1529139574466-a302d2d3f524?w=600', title: '中山區咖啡廳推薦', authorName: 'Foodie', authorAvatar: 'https://images.unsplash.com/photo-1529139574466-a302d2d3f524?w=100', likes: 88, aspectRatio: 1.2),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      // [修改] 改用 NestedScrollView 讓 AppBar 隨滑動隱藏/顯示
      body: ResponsiveContainer(
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                pinned: true, // TabBar 固定
                floating: true, // AppBar 浮動
                snap: true,
                leading: const BackButton(color: Colors.black),
                titleSpacing: 0, // 讓搜尋框緊接在返回鍵後
                
                // 1. 搜尋輸入框
                title: Container(
                  height: 40,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    style: const TextStyle(fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: "搜尋商品、商家...",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 10), // 垂直置中
                      suffixIcon: Icon(Icons.mic_none, color: Colors.grey, size: 20),
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
                    Tab(text: "全部"),
                    Tab(text: "商品"),
                    Tab(text: "用戶"), 
                  ],
                ),
              ),
            ];
          },
          
          // 3. 內容區域
          body: TabBarView(
            controller: _tabController,
            children: [
              // Tab 1: 全部結果 (顯示瀑布流)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: WaterfallFeed(items: _mockResults),
              ),
              
              // Tab 2: 商品結果 (空狀態)
              _buildEmptyState("找不到相關商品", Icons.shopping_bag_outlined),
              
              // Tab 3: 用戶/商家結果 (空狀態)
              _buildEmptyState("找不到相關用戶", Icons.person_search),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String text, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey[200]),
          const SizedBox(height: 16),
          Text(text, style: TextStyle(color: Colors.grey[400])),
        ],
      ),
    );
  }
}