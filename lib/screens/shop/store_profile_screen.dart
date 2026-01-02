// lib/screens/shop/store_profile_screen.dart
import 'package:flutter/material.dart';
import '../../widgets/responsive_container.dart';
import '../../models/waterfall_item.dart';
import '../../widgets/waterfall_feed.dart';
// 確保能跳轉到商品詳情
import 'product_detail_screen.dart'; 

class StoreProfileScreen extends StatefulWidget {
  // 實際串接時傳入 ID
  final String merchantName;
  final String avatarUrl;

  const StoreProfileScreen({
    super.key,
    required this.merchantName,
    required this.avatarUrl,
  });

  @override
  State<StoreProfileScreen> createState() => _StoreProfileScreenState();
}

class _StoreProfileScreenState extends State<StoreProfileScreen> {
  bool _isFollowing = false;

  // 模擬商家櫥窗數據
  final List<WaterfallItem> _storeProducts = [
    WaterfallItem(id: 'p1', image: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=600', title: '高腰牛仔寬褲', authorName: '', authorAvatar: '', likes: 120, aspectRatio: 1.5),
    WaterfallItem(id: 'p2', image: 'https://images.unsplash.com/photo-1544580353-4a24b9074137?w=600', title: '韓系針織上衣', authorName: '', authorAvatar: '', likes: 85, aspectRatio: 1.2),
    WaterfallItem(id: 'p3', image: 'https://images.unsplash.com/photo-1596462502278-27bfdd403348?w=600', title: '純銀愛心項鍊', authorName: '', authorAvatar: '', likes: 200, aspectRatio: 1.0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        // 顯示商家名稱
        title: Text(widget.merchantName, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.share_outlined)),
          IconButton(onPressed: (){}, icon: const Icon(Icons.more_horiz)),
        ],
      ),
      body: ResponsiveContainer(
        // 使用 NestedScrollView 讓頭部資訊可以滑動收起，下方列表吸頂
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // 1. 商家資訊區
                      Row(
                        children: [
                          CircleAvatar(radius: 36, backgroundImage: NetworkImage(widget.avatarUrl)),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _statItem("128", "商品"),
                                _statItem("1.2k", "粉絲"),
                                _statItem("4.9", "評價"),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // 2. 商家簡介
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "我們專注於韓系簡約風格，每週二上新 ✨\n實體店面：台北市中山區...\n#韓系 #穿搭 #小資女", 
                          style: TextStyle(height: 1.4, color: Colors.black87)
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // 3. 操作按鈕 (追蹤、聊聊)
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton(
                              onPressed: () => setState(() => _isFollowing = !_isFollowing),
                              style: FilledButton.styleFrom(
                                backgroundColor: _isFollowing ? Colors.grey[200] : Colors.purple,
                                foregroundColor: _isFollowing ? Colors.black : Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                              child: Text(_isFollowing ? "已追蹤" : "追蹤店家"),
                            ),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton(
                            onPressed: () {
                                // 這裡可以跳轉到聊天室
                            }, 
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              side: BorderSide(color: Colors.grey[300]!),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            ),
                            child: const Icon(Icons.chat_bubble_outline, size: 20, color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          // 4. 下方商品與貼文列表
          body: Column(
            children: [
              const TabBar(
                tabs: [Tab(text: "熱銷櫥窗"), Tab(text: "最新上架")],
                labelColor: Colors.black,
                indicatorColor: Colors.purple,
                indicatorSize: TabBarIndicatorSize.label,
              ),
              Expanded(
                child: Container(
                  color: Colors.grey[50],
                  padding: const EdgeInsets.only(top: 8),
                  // 這裡複用 WaterfallFeed 顯示商品
                  child: WaterfallFeed(items: _storeProducts), 
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statItem(String count, String label) {
    return Column(
      children: [
        Text(count, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}