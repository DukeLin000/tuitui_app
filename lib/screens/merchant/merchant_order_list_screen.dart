// lib/screens/merchant/merchant_order_list_screen.dart
import 'package:flutter/material.dart';
import '../../widgets/responsive_container.dart';

class MerchantOrderListScreen extends StatelessWidget {
  const MerchantOrderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text("訂單管理", style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          bottom: const TabBar(
            labelColor: Colors.purple,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.purple,
            tabs: [
              Tab(text: "待出貨 (3)"),
              Tab(text: "運送中 (5)"),
              Tab(text: "已完成"),
            ],
          ),
        ),
        body: ResponsiveContainer(
          child: TabBarView(
            children: [
              _buildOrderList(context, status: "pending"),
              const Center(child: Text("運送中訂單列表")),
              const Center(child: Text("歷史訂單列表")),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderList(BuildContext context, {required String status}) {
    // 模擬訂單數據
    final orders = [
      {'id': '231027001', 'user': 'UserA', 'item': '韓系針織毛衣', 'total': 890, 'time': '10:30'},
      {'id': '231027005', 'user': 'UserB', 'item': '高腰牛仔寬褲', 'total': 1280, 'time': '09:15'},
      {'id': '231027008', 'user': 'UserC', 'item': 'Sony 耳機', 'total': 8900, 'time': 'Yesterday'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))],
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("訂單編號 #${order['id']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(order['time'] as String, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Body
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(width: 50, height: 50, color: Colors.grey[200], child: const Icon(Icons.image, color: Colors.grey)), // 圖片 Placeholder
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(order['item'] as String, style: const TextStyle(fontSize: 16)),
                          const SizedBox(height: 4),
                          const Text("規格: 單一尺寸", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                    Text("\$${order['total']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Footer / Actions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("買家: ${order['user']}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text("立即出貨"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}