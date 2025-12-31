import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../widgets/waterfall_feed.dart';

class MarketScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  final VoidCallback onOpenCart;
  final VoidCallback onOpenMap;

  const MarketScreen({
    super.key,
    required this.cartItems,
    required this.onOpenCart,
    required this.onOpenMap,
  });

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  // 預設選中 'For You'
  String _activeCategory = 'For You';

  // 主分類列表
  final List<String> _categories = [
    'For You', 'Fashion', 'Home', 'Sports', 'Food', 'Fresh', 'Tech', 'Beauty', 'Toy', 'Crafts'
  ];

  // --- 1. 快捷功能按鈕 (For You 專用) ---
  final List<Map<String, dynamic>> _quickActions = [
    {'id': 'like', 'label': 'Like', 'icon': Icons.favorite_outline, 'color': Colors.red, 'bg': Colors.red.withOpacity(0.1)},
    {'id': 'storyful', 'label': 'Storyful', 'icon': Icons.auto_awesome_outlined, 'color': Colors.purple, 'bg': Colors.purple.withOpacity(0.1)},
    {'id': 'wishlist', 'label': 'Wishlist', 'icon': Icons.star_outline, 'color': Colors.amber, 'bg': Colors.amber.withOpacity(0.1)},
    {'id': 'cart', 'label': 'Cart', 'icon': Icons.shopping_cart_outlined, 'color': Colors.pink, 'bg': Colors.pink.withOpacity(0.1), 'badge': true},
    {'id': 'call', 'label': 'Call', 'icon': Icons.phone_outlined, 'color': Colors.green, 'bg': Colors.green.withOpacity(0.1)},
    {'id': 'coin', 'label': 'Coin', 'icon': Icons.monetization_on_outlined, 'color': Colors.orange, 'bg': Colors.orange.withOpacity(0.1)},
    {'id': 'deal', 'label': 'Deal', 'icon': Icons.local_shipping_outlined, 'color': Colors.blue, 'bg': Colors.blue.withOpacity(0.1)},
    {'id': 'service', 'label': 'Service', 'icon': Icons.map_outlined, 'color': Colors.teal, 'bg': Colors.teal.withOpacity(0.1)},
    {'id': 'history', 'label': 'History', 'icon': Icons.history, 'color': Colors.grey, 'bg': Colors.grey.withOpacity(0.1)},
    {'id': 'empty', 'label': '', 'icon': null, 'color': Colors.transparent, 'bg': Colors.transparent}, 
  ];

  // --- 2. 其他分類的子分類圖標 ---
  final Map<String, List<Map<String, dynamic>>> _subCategoryMap = {
    'Home': [
      {'label': '兒童房', 'icon': Icons.child_care}, {'label': '寵物', 'icon': Icons.pets},
      {'label': '氛圍燈影', 'icon': Icons.lightbulb}, {'label': '空間收納', 'icon': Icons.inventory_2_outlined},
      {'label': '餐廳', 'icon': Icons.dining_outlined}, {'label': '廚房', 'icon': Icons.kitchen},
      {'label': '地毯', 'icon': Icons.layers}, {'label': '花花草草', 'icon': Icons.local_florist},
      {'label': '靠墊抱枕', 'icon': Icons.chair}, {'label': '客廳', 'icon': Icons.weekend},
    ],
    'Fashion': [
      {'label': 'T恤', 'icon': Icons.checkroom}, {'label': '牛仔褲', 'icon': Icons.kebab_dining},
      {'label': '外套', 'icon': Icons.dry_cleaning}, {'label': '毛衣', 'icon': Icons.texture},
      {'label': '馬甲', 'icon': Icons.layers}, {'label': '大衣', 'icon': Icons.accessibility_new},
      {'label': '連衣裙', 'icon': Icons.woman}, {'label': '半身裙', 'icon': Icons.surfing}, 
      {'label': '襯衫', 'icon': Icons.business_center}, {'label': '衛衣', 'icon': Icons.fitness_center},
    ],
    'Sports': [
      {'label': '跑鞋', 'icon': Icons.directions_run}, {'label': '瑜珈', 'icon': Icons.self_improvement},
      {'label': '健身器材', 'icon': Icons.fitness_center}, {'label': '露營', 'icon': Icons.terrain},
      {'label': '游泳', 'icon': Icons.pool}, {'label': '球類', 'icon': Icons.sports_basketball},
    ],
    'Food': [
      {'label': '零食', 'icon': Icons.cookie}, {'label': '飲料', 'icon': Icons.local_drink},
      {'label': '生鮮', 'icon': Icons.restaurant}, {'label': '甜點', 'icon': Icons.cake},
      {'label': '咖啡', 'icon': Icons.coffee}, {'label': '速食', 'icon': Icons.fastfood},
    ],
    // 其他分類可依需求增加...
  };

  // --- 3. 分類推薦資料庫 ---
  final Map<String, List<WaterfallItem>> _recommendationMap = {
    'For You': [
      const WaterfallItem(id: '1', image: 'https://images.unsplash.com/photo-1737214475335-8ed64d91f473?w=600', title: '2024 最新法式指甲設計', authorName: 'Nail Studio', authorAvatar: 'https://images.unsplash.com/photo-1589553009868-c7b2bb474531?w=100', likes: 1234, aspectRatio: 1.3),
      const WaterfallItem(id: '2', image: 'https://images.unsplash.com/photo-1544580353-4a24b9074137?w=600', title: '韓系穿搭分享', authorName: 'Amy', authorAvatar: 'https://images.unsplash.com/photo-1589553009868-c7b2bb474531?w=100', likes: 2341, aspectRatio: 1.5),
      const WaterfallItem(id: '3', image: 'https://images.unsplash.com/photo-1634850034923-31cda5d080f5?w=600', title: '中山站咖啡廳推薦', authorName: 'Cafe Lover', authorAvatar: 'https://images.unsplash.com/photo-1589553009868-c7b2bb474531?w=100', likes: 892, aspectRatio: 1.2),
      const WaterfallItem(id: '4', image: 'https://images.unsplash.com/photo-1725782657580-11fc4f78113e?w=600', title: '台灣小吃必吃清單', authorName: 'Foodie', authorAvatar: 'https://images.unsplash.com/photo-1589553009868-c7b2bb474531?w=100', likes: 3456, aspectRatio: 1.1),
    ],
    'Fashion': [
      const WaterfallItem(id: 'f1', image: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=600', title: '秋冬必備風衣外套', authorName: 'Fashionista', authorAvatar: '', likes: 520, aspectRatio: 1.6),
      const WaterfallItem(id: 'f2', image: 'https://images.unsplash.com/photo-1529139574466-a302c2d36214?w=600', title: '街頭潮流穿搭指南', authorName: 'StreetStyle', authorAvatar: '', likes: 330, aspectRatio: 1.2),
      const WaterfallItem(id: 'f3', image: 'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=600', title: '時尚單品推薦', authorName: 'Vogue', authorAvatar: '', likes: 1100, aspectRatio: 1.4),
      const WaterfallItem(id: 'f4', image: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=600', title: '模特日常OOTD', authorName: 'ModelLife', authorAvatar: '', likes: 789, aspectRatio: 1.0),
    ],
    'Home': [
      const WaterfallItem(id: 'h1', image: 'https://images.unsplash.com/photo-1513694203232-719a280e022f?w=600', title: '北歐風客廳設計', authorName: 'HomeDecor', authorAvatar: '', likes: 777, aspectRatio: 1.5),
      const WaterfallItem(id: 'h2', image: 'https://images.unsplash.com/photo-1522758971460-1d21eed7dc1d?w=600', title: '舒適臥室改造', authorName: 'CozyHome', authorAvatar: '', likes: 555, aspectRatio: 1.2),
    ],
    // 其他分類預設為空列表，避免報錯
  };

  void _handleQuickAction(String id) {
    if (id == 'cart') {
      widget.onOpenCart();
    } else if (id == 'service') {
      widget.onOpenMap();
    }
  }

  Widget _buildGridItem({
    required String label, 
    required IconData? icon, 
    required Color iconColor, 
    required Color bgColor, 
    String? id, 
    bool showBadge = false
  }) {
    if (id == 'empty' || icon == null) return const SizedBox(width: 48);

    return GestureDetector(
      onTap: () => id != null ? _handleQuickAction(id) : null,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              if (showBadge && widget.cartItems.isNotEmpty)
                Positioned(
                  right: -4, top: -4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.white, width: 2)),
                    child: Text('${widget.cartItems.length}', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                )
            ],
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 60, 
            child: Text(
              label, 
              style: const TextStyle(fontSize: 11, color: Colors.grey),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 取得當前分類的資料，若無則預設為空 (或可以改回傳 For You)
    final List<WaterfallItem> currentItems = _recommendationMap[_activeCategory] ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        // [AppBar 優化] 限制搜尋框在 Web 版的寬度
        title: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Container(
              height: 40,
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(20)),
              child: const TextField(
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: "搜尋商品、店家...",
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  suffixIcon: Icon(Icons.camera_alt_outlined, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: [
          // 1. 分類 Tabs
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Container(
                height: 50,
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[100]!))),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 24),
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    final isActive = _activeCategory == cat;
                    return GestureDetector(
                      onTap: () => setState(() => _activeCategory = cat),
                      child: Center(
                        child: Text(
                          cat,
                          style: TextStyle(
                            color: isActive ? Colors.purple : Colors.grey[600],
                            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // 2. 內容區：快速功能按鈕 (Quick Actions)
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Builder(
                  builder: (context) {
                    List<Widget> row1Items = [];
                    List<Widget> row2Items = [];

                    if (_activeCategory == 'For You') {
                      row1Items = _quickActions.sublist(0, 5).map((item) => _buildGridItem(
                        label: item['label'], icon: item['icon'], iconColor: item['color'], bgColor: item['bg'], id: item['id'], showBadge: item['badge'] ?? false,
                      )).toList();
                      row2Items = _quickActions.sublist(5, 10).map((item) => _buildGridItem(
                        label: item['label'], icon: item['icon'], iconColor: item['color'], bgColor: item['bg'], id: item['id'],
                      )).toList();
                    } else {
                      final List<Map<String, dynamic>> subCats = _subCategoryMap[_activeCategory] ?? [];
                      if (subCats.isNotEmpty) {
                        final firstFive = subCats.take(5).toList();
                        while (firstFive.length < 5) firstFive.add({'label': '', 'icon': null});
                        row1Items = firstFive.map((item) => _buildGridItem(
                          label: item['label'] ?? '', icon: item['icon'], iconColor: Colors.grey[700]!, bgColor: Colors.grey[100]!,
                        )).toList();

                        if (subCats.length > 5) {
                           final secondFive = subCats.skip(5).take(5).toList();
                           while (secondFive.length < 5) secondFive.add({'label': '', 'icon': null});
                           row2Items = secondFive.map((item) => _buildGridItem(
                            label: item['label'] ?? '', icon: item['icon'], iconColor: Colors.grey[700]!, bgColor: Colors.grey[100]!,
                          )).toList();
                        }
                      }
                    }

                    if (row1Items.isEmpty) return const SizedBox.shrink();

                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: row1Items,
                        ),
                        if (row2Items.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: row2Items,
                          ),
                        ]
                      ],
                    );
                  },
                ),
              ),
            ),
          ),

          // 3. 推薦標題
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("熱銷推薦", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                    Text("查看全部", style: TextStyle(color: Colors.purple, fontSize: 14)),
                  ],
                ),
              ),
            ),
          ),
          
          // 4. 瀑布流 (WaterfallFeed)
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0), // 統一左右 16px 內縮
                child: WaterfallFeed(items: currentItems),
              ),
            ),
          ),
        ],
      ),
    );
  }
}