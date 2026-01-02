// lib/screens/merchant/merchant_product_list_screen.dart
import 'package:flutter/material.dart';
import '../../widgets/responsive_container.dart';

class MerchantProductListScreen extends StatelessWidget {
  const MerchantProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("商品管理", style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          bottom: const TabBar(
            labelColor: Colors.purple,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.purple,
            tabs: [
              Tab(text: "出售中 (5)"),
              Tab(text: "已售完 (1)"),
              Tab(text: "草稿箱 (2)"),
            ],
          ),
        ),
        body: ResponsiveContainer(
          child: TabBarView(
            children: [
              _buildProductList(context), // 出售中
              const Center(child: Text("尚無已售完商品")),
              const Center(child: Text("尚無草稿")),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductList(BuildContext context) {
    // 模擬數據
    final products = [
      {'title': '韓系針織毛衣', 'price': 890, 'stock': 12, 'sales': 45, 'image': 'https://images.unsplash.com/photo-1544580353-4a24b9074137?w=100'},
      {'title': '高腰牛仔寬褲', 'price': 1280, 'stock': 5, 'sales': 28, 'image': 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=100'},
      {'title': '純銀愛心項鍊', 'price': 450, 'stock': 100, 'sales': 12, 'image': 'https://images.unsplash.com/photo-1596462502278-27bfdd403348?w=100'},
      // 測試長標題
      {'title': '這是一個標題非常長的測試商品用來測試排版是否會因為文字過多而跑版', 'price': 999, 'stock': 0, 'sales': 999, 'image': 'https://images.unsplash.com/photo-1596462502278-27bfdd403348?w=100'},
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final item = products[index];
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            // [修正1] 讓圖片與文字皆靠上對齊
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 商品圖
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item['image'] as String, 
                  width: 80, 
                  height: 80, 
                  fit: BoxFit.cover,
                  // [優化] 圖片讀取錯誤時顯示灰色方塊
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 80, height: 80, color: Colors.grey[200], child: const Icon(Icons.image, color: Colors.grey)
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              // 資訊區塊
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // [修正2] 標題限制行數，避免過長
                    Text(
                      item['title'] as String, 
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      maxLines: 2, 
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text("NT\$${item['price']}", style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    
                    // [修正3] 使用 Wrap 代替 Row，防止螢幕太窄時右側溢出 (Right Overflow)
                    Wrap(
                      spacing: 12, // 水平間距
                      runSpacing: 4, // 垂直間距 (換行後)
                      children: [
                        Text("庫存: ${item['stock']}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        Text("總銷量: ${item['sales']}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
              
              // 操作按鈕
              IconButton(
                onPressed: (){}, 
                icon: const Icon(Icons.more_vert, color: Colors.grey),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(), // 縮小按鈕點擊範圍，避免佔位太大
              ),
            ],
          ),
        );
      },
    );
  }
}