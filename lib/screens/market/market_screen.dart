import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/waterfall_feed.dart';
import '../../models/waterfall_item.dart'; 
import '../../widgets/responsive_container.dart';
import '../../models/cart_item.dart'; // [新增] 為了使用 ItemType

class MarketScreen extends StatefulWidget {
  final VoidCallback onOpenCart;
  final VoidCallback onOpenMap;

  const MarketScreen({
    super.key,
    required this.onOpenCart,
    required this.onOpenMap,
  });

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  String _activeCategory = 'For You';

  final List<String> _categories = [
    'For You', 'Fashion', 'Home', 'Sports', 'Food', 'Fresh', 'Tech', 'Beauty', 'Toy', 'Crafts'
  ];

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
  };

  // --- 3. 分類推薦資料庫 (更新：加入 price 與 type) ---
  final Map<String, List<WaterfallItem>> _recommendationMap = {
    'For You': [
      // 一般商品
      const WaterfallItem(id: '1', image: 'https://images.unsplash.com/photo-1596462502278-27bfdd403348?w=600', title: '雅詩蘭黛 小棕瓶精華', authorName: '', authorAvatar: '', likes: 1234, aspectRatio: 1.0, price: 2800, type: ItemType.product),
      
      // [新增] 預約服務範例：咖啡廳預定
      const WaterfallItem(
        id: 'cafe1', 
        image: 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=600', 
        title: '精品咖啡廳 - 雙人下午茶預約', 
        authorName: '', authorAvatar: '', likes: 567, aspectRatio: 1.2, 
        price: 500, // 訂金
        type: ItemType.reservation // 標記為預約
      ),

      // 貼文
      const WaterfallItem(id: '2', image: 'https://images.unsplash.com/photo-1544580353-4a24b9074137?w=600', title: '韓系穿搭分享 (純心得)', authorName: 'Amy', authorAvatar: 'https://images.unsplash.com/photo-1589553009868-c7b2bb474531?w=100', likes: 2341, aspectRatio: 1.5), 
      
      const WaterfallItem(id: '3', image: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600', title: 'Sony WH-1000XM5 耳機', authorName: '', authorAvatar: '', likes: 892, aspectRatio: 1.0, price: 9900, type: ItemType.product),
    ],
    'Fashion': [
      const WaterfallItem(id: 'f1', image: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=600', title: '秋冬必備風衣外套', authorName: '', authorAvatar: '', likes: 520, aspectRatio: 1.6, price: 1280, type: ItemType.product),
      const WaterfallItem(id: 'f2', image: 'https://images.unsplash.com/photo-1529139574466-a302c2d36214?w=600', title: '街頭潮流大學 T', authorName: '', authorAvatar: '', likes: 330, aspectRatio: 1.2, price: 890, type: ItemType.product),
    ],
    'Home': [
      const WaterfallItem(id: 'h1', image: 'https://images.unsplash.com/photo-1513694203232-719a280e022f?w=600', title: '北歐風客廳地毯', authorName: '', authorAvatar: '', likes: 777, aspectRatio: 1.5, price: 650, type: ItemType.product),
    ],
  };

  Widget _buildGridItem({
    required String label, 
    required IconData? icon, 
    required Color iconColor, 
    required Color bgColor, 
    String? id, 
  }) {
    if (icon == null) return const SizedBox(width: 48);
    return GestureDetector(
      child: Column(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: iconColor, size: 24),
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
    final List<WaterfallItem> currentItems = _recommendationMap[_activeCategory] ?? _recommendationMap['For You'] ?? [];

    return Scaffold(
      backgroundColor: Colors.grey[50], 
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: ResponsiveContainer(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: const TextField(
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: "搜尋商品、店家...",
                      hintStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black54),
                    onPressed: widget.onOpenCart,
                  ),
                  Consumer<CartProvider>(
                    builder: (context, cart, child) {
                      if (cart.itemCount == 0) return const SizedBox.shrink();
                      return Positioned(
                        right: 8, top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                          child: Text(
                            '${cart.itemCount}', 
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.map_outlined, color: Colors.black54),
                onPressed: widget.onOpenMap,
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: [
          ResponsiveContainer(
            child: Container(
              height: 50,
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[200]!))),
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
          const SizedBox(height: 10),
          if (_activeCategory != 'For You' && _subCategoryMap.containsKey(_activeCategory))
            ResponsiveContainer(
              padding: const EdgeInsets.all(16),
              child: Builder(
                builder: (context) {
                  final subCats = _subCategoryMap[_activeCategory]!;
                  final displayCats = subCats.take(10).toList();
                  if (displayCats.isEmpty) return const SizedBox.shrink();
                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.start,
                    children: displayCats.map((item) => _buildGridItem(
                      label: item['label'] ?? '',
                      icon: item['icon'],
                      iconColor: Colors.grey[700]!,
                      bgColor: Colors.white,
                    )).toList(),
                  );
                },
              ),
            ),
          const ResponsiveContainer(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("熱銷推薦", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                Icon(Icons.filter_list, size: 20, color: Colors.grey),
              ],
            ),
          ),
          ResponsiveContainer(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: WaterfallFeed(items: currentItems),
          ),
        ],
      ),
    );
  }
}