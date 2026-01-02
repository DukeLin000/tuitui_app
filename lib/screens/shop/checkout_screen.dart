// lib/screens/shop/checkout_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/responsive_container.dart';
import 'buyer_order_list_screen.dart'; // 確保下一步會建立此檔案

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  int _paymentMethod = 0; 

  void _submitOrder() {
    if (_formKey.currentState!.validate()) {
      // 1. 清空購物車
      Provider.of<CartProvider>(context, listen: false).clear();

      // 2. 顯示成功
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("訂單建立成功！")));

      // 3. 跳轉到訂單頁 (使用 pushReplacement 避免回到結帳頁)
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => const BuyerOrderListScreen())
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 監聽 CartProvider
    final cart = Provider.of<CartProvider>(context);
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("確認訂單", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ResponsiveContainer(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionHeader(title: "收件資訊"),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(labelText: "收件人姓名", border: OutlineInputBorder()),
                              validator: (v) => v!.isEmpty ? "請輸入姓名" : null,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _phoneController,
                              decoration: const InputDecoration(labelText: "手機號碼", border: OutlineInputBorder()),
                              keyboardType: TextInputType.phone,
                              validator: (v) => v!.isEmpty ? "請輸入手機" : null,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _addressController,
                              decoration: const InputDecoration(labelText: "收件地址", border: OutlineInputBorder()),
                              validator: (v) => v!.isEmpty ? "請輸入地址" : null,
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      // 顯示購買項目數量
                      _SectionHeader(title: "購買商品 (${cart.itemCount})"),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          // [修正重點] 因為 items 是 List，直接使用 map 即可，不需要 .values
                          children: cart.items.map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                // 商品圖
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6), 
                                  child: Image.network(
                                    item.image, // [注意] 確保 CartItem 用的是 image
                                    width: 50, 
                                    height: 50, 
                                    fit: BoxFit.cover,
                                    errorBuilder: (ctx, err, stack) => Container(width: 50, height: 50, color: Colors.grey[200], child: const Icon(Icons.broken_image)),
                                  )
                                ),
                                const SizedBox(width: 12),
                                // 商品名稱與數量
                                Expanded(child: Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis)),
                                Text("x${item.quantity}", style: const TextStyle(color: Colors.grey)),
                                const SizedBox(width: 12),
                                // 價格 (單價 x 數量)
                                Text("NT\$${item.price * item.quantity}", style: const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          )).toList(),
                        ),
                      ),

                      const SizedBox(height: 24),
                      _SectionHeader(title: "付款方式"),
                      Container(
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          children: [
                            RadioListTile(
                              value: 0, groupValue: _paymentMethod, onChanged: (v) => setState(() => _paymentMethod = v!),
                              title: const Text("信用卡"), secondary: const Icon(Icons.credit_card), activeColor: Colors.purple,
                            ),
                            RadioListTile(
                              value: 1, groupValue: _paymentMethod, onChanged: (v) => setState(() => _paymentMethod = v!),
                              title: const Text("Line Pay"), secondary: const Icon(Icons.payment, color: Colors.green), activeColor: Colors.purple,
                            ),
                            RadioListTile(
                              value: 2, groupValue: _paymentMethod, onChanged: (v) => setState(() => _paymentMethod = v!),
                              title: const Text("貨到付款"), secondary: const Icon(Icons.local_shipping_outlined), activeColor: Colors.purple,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // 底部結帳區
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, -2))]),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("總金額", style: TextStyle(color: Colors.grey)),
                        // [修正重點] 使用 totalAmount 對應您的 CartProvider
                        Text("NT\$${cart.totalAmount}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: _submitOrder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                      child: const Text("送出訂單", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
    );
  }
}