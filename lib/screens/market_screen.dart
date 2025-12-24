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

  // --- 1. 原本的快捷功能按鈕 (For You 專用) ---
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
    // 這裡放一個空的佔位符，確保排版對齊
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
      {'label': '運動T恤', 'icon': Icons.directions_run}, {'label': '運動背心', 'icon': Icons.style},
      {'label': '運動鞋', 'icon': Icons.hiking}, {'label': '運動褲', 'icon': Icons.roller_skating},
      {'label': '運動包配', 'icon': Icons.backpack}, {'label': '游泳', 'icon': Icons.pool},
      {'label': '徒步溯溪', 'icon': Icons.terrain}, {'label': '瑜珈健身', 'icon': Icons.self_improvement},
      {'label': '跑步', 'icon': Icons.timer}, {'label': '露營', 'icon': Icons.deck},
    ],
    'Food': [
      {'label': '麵包蛋糕', 'icon': Icons.bakery_dining}, {'label': '快樂甜水', 'icon': Icons.local_drink},
      {'label': '冰淇淋', 'icon': Icons.icecream}, {'label': '滷味肉干', 'icon': Icons.set_meal},
      {'label': '減糖甜品', 'icon': Icons.cake}, {'label': '餅乾膨化', 'icon': Icons.cookie},
      {'label': '堅果果乾', 'icon': Icons.grass}, {'label': '養生茶飲', 'icon': Icons.emoji_food_beverage},
      {'label': '氣血滋補', 'icon': Icons.favorite}, {'label': '一人食', 'icon': Icons.person},
    ],
    'Fresh': [
      {'label': '時令水果', 'icon': Icons.eco}, {'label': '海鮮水產', 'icon': Icons.water},
      {'label': '刺身', 'icon': Icons.phishing}, {'label': '肉禽', 'icon': Icons.restaurant},
      {'label': '蛋奶', 'icon': Icons.egg}, {'label': '和牛', 'icon': Icons.lunch_dining},
      {'label': '精選蔬菜', 'icon': Icons.eco}, {'label': '野生菌', 'icon': Icons.umbrella},
      {'label': '凍品速食', 'icon': Icons.ac_unit}, {'label': '櫻花', 'icon': Icons.local_florist},
    ],
    'Tech': [
      {'label': '充電寶', 'icon': Icons.battery_charging_full}, {'label': '耳機殼', 'icon': Icons.headphones},
      {'label': '耳機音箱', 'icon': Icons.speaker}, {'label': '鍵盤鍵帽', 'icon': Icons.keyboard},
      {'label': '手機殼', 'icon': Icons.phone_android}, {'label': '手機支架', 'icon': Icons.smartphone},
      {'label': '數據線', 'icon': Icons.cable}, {'label': '相機膠片', 'icon': Icons.camera_alt},
      {'label': '智能手錶', 'icon': Icons.watch}, {'label': 'vlog裝備', 'icon': Icons.videocam},
    ],
    'Beauty': [
      {'label': '美容工具', 'icon': Icons.face_retouching_natural}, {'label': '祛痘', 'icon': Icons.healing},
      {'label': '抗衰', 'icon': Icons.access_time}, {'label': '保濕', 'icon': Icons.water_drop},
      {'label': '防曬', 'icon': Icons.wb_sunny}, {'label': '口腔護理', 'icon': Icons.clean_hands},
      {'label': '底妝', 'icon': Icons.brush}, {'label': '美髮養髮', 'icon': Icons.content_cut},
      {'label': '美甲美睫', 'icon': Icons.front_hand}, {'label': '美白', 'icon': Icons.brightness_high},
    ],
    'Toy': [
      {'label': '盲盒', 'icon': Icons.card_giftcard}, {'label': '積木', 'icon': Icons.extension},
      {'label': '手辦', 'icon': Icons.person_pin}, {'label': '桌遊', 'icon': Icons.casino},
      {'label': '玩偶', 'icon': Icons.smart_toy},
    ],
    'Crafts': [
      {'label': '編織', 'icon': Icons.gesture}, {'label': '陶藝', 'icon': Icons.coffee},
      {'label': '繪畫', 'icon': Icons.palette}, {'label': '手帳', 'icon': Icons.book},
      {'label': 'DIY', 'icon': Icons.build},
    ],
  };

  // --- 3. 關鍵升級：分類推薦資料庫 (Waterfall Data Map) ---
  final Map<String, List<WaterfallItem>> _recommendationMap = {
    // 1. For You: 綜合推薦
    'For You': [
      const WaterfallItem(id: '1', image: 'https://images.unsplash.com/photo-1737214475335-8ed64d91f473?w=600', title: '2024 最新法式指甲設計', authorName: 'Nail Studio', authorAvatar: 'https://images.unsplash.com/photo-1589553009868-c7b2bb474531?w=100', likes: 1234, aspectRatio: 1.3),
      const WaterfallItem(id: '2', image: 'https://images.unsplash.com/photo-1544580353-4a24b9074137?w=600', title: '韓系穿搭分享', authorName: 'Amy', authorAvatar: 'https://images.unsplash.com/photo-1589553009868-c7b2bb474531?w=100', likes: 2341, aspectRatio: 1.5),
      const WaterfallItem(id: '3', image: 'https://images.unsplash.com/photo-1634850034923-31cda5d080f5?w=600', title: '中山站咖啡廳推薦', authorName: 'Cafe Lover', authorAvatar: 'https://images.unsplash.com/photo-1589553009868-c7b2bb474531?w=100', likes: 892, aspectRatio: 1.2),
      const WaterfallItem(id: '4', image: 'https://images.unsplash.com/photo-1725782657580-11fc4f78113e?w=600', title: '台灣小吃必吃清單', authorName: 'Foodie', authorAvatar: 'https://images.unsplash.com/photo-1589553009868-c7b2bb474531?w=100', likes: 3456, aspectRatio: 1.1),
    ],
    // 2. Fashion: 衣服、鞋子
    'Fashion': [
      const WaterfallItem(id: 'f1', image: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=600', title: '秋冬必備風衣外套', authorName: 'Fashionista', authorAvatar: '', likes: 520, aspectRatio: 1.6),
      const WaterfallItem(id: 'f2', image: 'https://images.unsplash.com/photo-1529139574466-a302c2d36214?w=600', title: '街頭潮流穿搭指南', authorName: 'StreetStyle', authorAvatar: '', likes: 330, aspectRatio: 1.2),
      const WaterfallItem(id: 'f3', image: 'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=600', title: '時尚單品推薦', authorName: 'Vogue', authorAvatar: '', likes: 1100, aspectRatio: 1.4),
      const WaterfallItem(id: 'f4', image: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=600', title: '模特日常OOTD', authorName: 'ModelLife', authorAvatar: '', likes: 789, aspectRatio: 1.0),
    ],
    // 3. Food: 美食、飲料
    'Food': [
      const WaterfallItem(id: 'fd1', image: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=600', title: '精緻牛排晚餐', authorName: 'Chef Master', authorAvatar: '', likes: 999, aspectRatio: 1.3),
      const WaterfallItem(id: 'fd2', image: 'https://images.unsplash.com/photo-1563729784474-d77dbb933a9e?w=600', title: '手工甜點：草莓塔', authorName: 'SweetTooth', authorAvatar: '', likes: 450, aspectRatio: 1.0),
      const WaterfallItem(id: 'fd3', image: 'https://images.unsplash.com/photo-1476224203421-9ac39bcb3327?w=600', title: '巷弄美食：牛肉麵', authorName: 'LocalEats', authorAvatar: '', likes: 210, aspectRatio: 1.5),
      const WaterfallItem(id: 'fd4', image: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=600', title: '健康蔬食沙拉', authorName: 'HealthyLife', authorAvatar: '', likes: 300, aspectRatio: 1.2),
    ],
    // 4. Tech: 3C、科技
    'Tech': [
      const WaterfallItem(id: 't1', image: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=600', title: '最新旗艦手機開箱', authorName: 'TechReview', authorAvatar: '', likes: 888, aspectRatio: 1.4),
      const WaterfallItem(id: 't2', image: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600', title: '無線降噪耳機', authorName: 'AudioPro', authorAvatar: '', likes: 654, aspectRatio: 1.1),
      const WaterfallItem(id: 't3', image: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600', title: '智能手錶功能實測', authorName: 'GadgetGuy', authorAvatar: '', likes: 321, aspectRatio: 1.0),
      const WaterfallItem(id: 't4', image: 'https://images.unsplash.com/photo-1550009158-9ebf69173e03?w=600', title: '電競筆電極致效能', authorName: 'GamerZone', authorAvatar: '', likes: 1024, aspectRatio: 1.5),
    ],
    // 5. Home: 家居
    'Home': [
      const WaterfallItem(id: 'h1', image: 'https://images.unsplash.com/photo-1513694203232-719a280e022f?w=600', title: '北歐風客廳設計', authorName: 'HomeDecor', authorAvatar: '', likes: 777, aspectRatio: 1.5),
      const WaterfallItem(id: 'h2', image: 'https://images.unsplash.com/photo-1522758971460-1d21eed7dc1d?w=600', title: '舒適臥室改造', authorName: 'CozyHome', authorAvatar: '', likes: 555, aspectRatio: 1.2),
    ]
  };

  // 處理 Quick Action 點擊
  void _handleQuickAction(String id) {
    if (id == 'cart') {
      widget.onOpenCart();
    } else if (id == 'service') {
      widget.onOpenMap();
    }
  }

  // --- 關鍵修改：統一的項目建構方法 ---
  // 這個方法會被 For You 和 其他子分類 共用，確保外觀 100% 一致
  Widget _buildGridItem({
    required String label, 
    required IconData? icon, 
    required Color iconColor, 
    required Color bgColor, 
    String? id, 
    bool showBadge = false
  }) {
    if (id == 'empty' || icon == null) return const SizedBox(width: 48); // 保持佔位大小

    return GestureDetector(
      onTap: () => id != null ? _handleQuickAction(id) : null,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 48, height: 48, // 統一大小：48
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(16), // 統一圓角：16
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
          // 使用 SizedBox 限制文字寬度，避免過長折行破壞排版
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
    // 4. 動態獲取當前分類的推薦商品 (如果找不到就顯示 For You 的預設列表)
    final List<WaterfallItem> currentItems = _recommendationMap[_activeCategory] ?? _recommendationMap['For You']!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        title: Container(
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
      body: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: [
          // 1. 分類 Tabs
          Container(
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

          // 2. 內容區：動態內容
          Padding(
            padding: const EdgeInsets.all(16),
            child: Builder(
              builder: (context) {
                // 準備要顯示的項目列表
                List<Widget> row1Items = [];
                List<Widget> row2Items = [];

                if (_activeCategory == 'For You') {
                  // === A. For You 頁面 (彩色按鈕) ===
                  row1Items = _quickActions.sublist(0, 5).map((item) => _buildGridItem(
                    label: item['label'],
                    icon: item['icon'],
                    iconColor: item['color'],
                    bgColor: item['bg'],
                    id: item['id'],
                    showBadge: item['badge'] ?? false,
                  )).toList();
                  
                  row2Items = _quickActions.sublist(5, 10).map((item) => _buildGridItem(
                    label: item['label'],
                    icon: item['icon'],
                    iconColor: item['color'],
                    bgColor: item['bg'],
                    id: item['id'],
                  )).toList();

                } else {
                  // === B. 其他分類 (灰色子分類) ===
                  final List<Map<String, dynamic>> subCats = _subCategoryMap[_activeCategory] ?? [];
                  
                  if (subCats.isNotEmpty) {
                    // 確保至少有 5 個元素來填滿第一行，不足補空
                    final firstFive = subCats.take(5).toList();
                    while (firstFive.length < 5) firstFive.add({'label': '', 'icon': null}); // 補位

                    row1Items = firstFive.map((item) => _buildGridItem(
                      label: item['label'] ?? '',
                      icon: item['icon'],
                      iconColor: Colors.grey[700]!, // 統一深灰色圖示
                      bgColor: Colors.grey[100]!,   // 統一淡灰色背景
                    )).toList();

                    // 處理第二行 (如果有超過5個)
                    if (subCats.length > 5) {
                       final secondFive = subCats.skip(5).take(5).toList();
                       while (secondFive.length < 5) secondFive.add({'label': '', 'icon': null}); // 補位

                       row2Items = secondFive.map((item) => _buildGridItem(
                        label: item['label'] ?? '',
                        icon: item['icon'],
                        iconColor: Colors.grey[700]!,
                        bgColor: Colors.grey[100]!,
                      )).toList();
                    }
                  }
                }

                if (row1Items.isEmpty) return const SizedBox.shrink();

                // 統一使用 Column + Row + SpaceBetween 佈局
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // 關鍵：讓每個元素均勻分布到邊緣
                      children: row1Items,
                    ),
                    if (row2Items.isNotEmpty) ...[
                      const SizedBox(height: 16), // 統一垂直間距
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

          // 3. 推薦標題
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("熱銷推薦", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                Text("查看全部", style: TextStyle(color: Colors.purple, fontSize: 14)),
              ],
            ),
          ),
          
          // 4. 瀑布流 (現在是動態數據了)
          WaterfallFeed(items: currentItems),
        ],
      ),
    );
  }
}