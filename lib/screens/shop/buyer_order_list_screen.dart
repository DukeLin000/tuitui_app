// lib/screens/shop/buyer_order_list_screen.dart
import 'package:flutter/material.dart';
import '../../widgets/responsive_container.dart';

class BuyerOrderListScreen extends StatelessWidget {
  const BuyerOrderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // 三個分頁：待出貨、運送中、已完成
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text("我的訂單", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          bottom: const TabBar(
            labelColor: Colors.purple,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.purple,
            tabs: [
              Tab(text: "待出貨"),
              Tab(text: "運送中"),
              Tab(text: "已完成"),
            ],
          ),
        ),
        body: ResponsiveContainer(
          child: TabBarView(
            children: [
              _buildOrderList(status: "Pending"),
              _buildOrderList(status: "Shipped"),
              _buildOrderList(status: "Completed"), // [新增] 已完成分頁
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderList({required String status}) {
    // 模擬訂單數據 (之後可改為從 API 獲取)
    final orders = [
      if (status == "Pending")
        {'id': '2023102801', 'total': 1280, 'items': '高腰牛仔寬褲 x1', 'date': '2023/10/28'},
      if (status == "Shipped")
        {'id': '2023102505', 'total': 2560, 'items': '韓系針織毛衣 x2', 'date': '2023/10/25'},
      if (status == "Completed")
        {'id': '2023102099', 'total': 590, 'items': '純銀耳環 x1', 'date': '2023/10/20'},
    ];

    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text("尚無${status == "Pending" ? "待出貨" : status == "Shipped" ? "運送中" : "歷史"}訂單", style: TextStyle(color: Colors.grey[400])),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 訂單頭部
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("訂單編號 #${order['id']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                  _buildStatusBadge(status),
                ],
              ),
              const SizedBox(height: 8),
              Text("下單日期：${order['date']}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
              const Divider(height: 24),
              
              // 訂單內容摘要
              Row(
                children: [
                  Container(
                    width: 50, height: 50, 
                    decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.shopping_bag_outlined, color: Colors.grey),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(order['items'] as String, style: const TextStyle(fontSize: 15))),
                ],
              ),
              const SizedBox(height: 12),
              
              // 總金額與按鈕
              Align(
                alignment: Alignment.centerRight,
                child: Text("訂單金額 NT\$${order['total']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: (){}, // 未來可連接到「訂單詳細頁」
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey[300]!),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text("查看詳情", style: TextStyle(color: Colors.black)),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  // 狀態標籤小元件
  Widget _buildStatusBadge(String status) {
    Color color;
    String text;
    switch (status) {
      case "Pending": color = Colors.orange; text = "待出貨"; break;
      case "Shipped": color = Colors.blue; text = "運送中"; break;
      default: color = Colors.green; text = "已完成"; break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
      child: Text(text, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}