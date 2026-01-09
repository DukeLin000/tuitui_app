// lib/screens/main/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import '../../models/post.dart';
import '../../widgets/post_card.dart';
import '../../models/waterfall_item.dart';
import '../../widgets/waterfall_feed.dart';
import '../../widgets/responsive_container.dart';
import '../../providers/post_provider.dart'; 
import '../shop/search_screen.dart';

class HomeScreen extends StatefulWidget {
  // 接收外部傳入的「打開地圖」方法
  final VoidCallback? onOpenMap;

  const HomeScreen({
    super.key, 
    this.onOpenMap 
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
                        
                        // ★★★ [修正點 1] 加入 Expanded 解決文字溢位崩潰問題 ★★★
                        Expanded(
                          child: Text(
                            "搜尋好店、穿搭靈感...", 
                            style: TextStyle(color: Colors.grey[400], fontSize: 14),
                            overflow: TextOverflow.ellipsis, // 多餘文字顯示 ...
                            maxLines: 1, // 限制一行
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 右上角動作區：加入地圖按鈕
                actions: [
                  if (widget.onOpenMap != null)
                    IconButton(
                      icon: const Icon(Icons.map_outlined, color: Colors.black87),
                      tooltip: "附近店家",
                      onPressed: widget.onOpenMap,
                    ),
                  const SizedBox(width: 8), 
                ],
                
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
              // 分頁 A：發現頁 (Discovery)
              // ---------------------------------------------------------------
              Consumer<PostProvider>(
                builder: (context, postProvider, child) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    // 這裡保留您原本的 WaterfallFeed
                    // 如果 WaterfallFeed 內部是用 GridView，建議確認它是否支援 NestedScrollView 的滑動
                    child: WaterfallFeed(items: postProvider.discoveryItems),
                  );
                },
              ),
              
              // ---------------------------------------------------------------
              // 分頁 B：追蹤頁 (Following)
              // ★★★ [修正點 2] 改用 CustomScrollView + SliverOverlapInjector 優化滑動體驗 ★★★
              // ---------------------------------------------------------------
              Consumer<PostProvider>(
                builder: (context, postProvider, child) {
                  final posts = postProvider.items;
                  
                  // 使用 Builder 取得正確的 context
                  return Builder(
                    builder: (BuildContext context) {
                      return CustomScrollView(
                        // 保持滑動位置的 key
                        key: const PageStorageKey<String>('following'),
                        slivers: <Widget>[
                          // 這個 Injector 會確保內容不被上方的 AppBar 擋住
                          SliverOverlapInjector(
                            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                          ),
                          
                          // 將原本的 ListView 改為 SliverList
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                final post = posts[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                  child: PostCard(post: post),
                                );
                              },
                              childCount: posts.length,
                            ),
                          ),
                        ],
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