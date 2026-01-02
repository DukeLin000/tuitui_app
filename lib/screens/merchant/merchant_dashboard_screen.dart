// lib/screens/merchant/merchant_dashboard_screen.dart
import 'package:flutter/material.dart';
import '../../widgets/responsive_container.dart';
import 'create_product_screen.dart'; // 引入發布頁面
import 'merchant_product_list_screen.dart'; // [新增] 商品管理
import 'merchant_order_list_screen.dart';   // [新增] 訂單管理

class MerchantDashboardScreen extends StatelessWidget {
  const MerchantDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("商家中心", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.notifications_outlined))
        ],
      ),
      body: ResponsiveContainer(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. 數據概覽卡片
              _buildStatCard(),
              const SizedBox(height: 24),
              
              // 2. 常用功能菜單 (Grid)
              const Text("常用功能", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: [
                   _MenuCard(
                    icon: Icons.inventory_2_outlined, 
                    label: "商品管理", 
                    subLabel: "庫存與上架",
                    color: Colors.blue,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MerchantProductListScreen())),
                  ),
                  _MenuCard(
                    icon: Icons.receipt_long_outlined, 
                    label: "訂單管理", 
                    subLabel: "待出貨 3 筆",
                    color: Colors.orange,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MerchantOrderListScreen())),
                  ),
                  _MenuCard(
                    icon: Icons.analytics_outlined, 
                    label: "數據分析", 
                    subLabel: "營收報表",
                    color: Colors.purple,
                    onTap: () {},
                  ),
                  _MenuCard(
                    icon: Icons.store_outlined, 
                    label: "店鋪設置", 
                    subLabel: "裝修與資訊",
                    color: Colors.teal,
                    onTap: () {},
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // 3. 快捷發布按鈕
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateProductScreen()));
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text("發布新商品", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF2E3192), Color(0xFF1BFFFF)]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: const Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatItem(label: "今日訂單", value: "12", isLight: true),
              _StatItem(label: "今日營收", value: "\$8,500", isLight: true),
              _StatItem(label: "訪客數", value: "128", isLight: true),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final bool isLight;
  const _StatItem({required this.label, required this.value, this.isLight = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isLight ? Colors.white : Colors.black)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: isLight ? Colors.white70 : Colors.grey)),
      ],
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subLabel;
  final Color color;
  final VoidCallback onTap;

  const _MenuCard({required this.icon, required this.label, required this.subLabel, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 24),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text(subLabel, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            )
          ],
        ),
      ),
    );
  }
}