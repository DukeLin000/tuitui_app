// lib/screens/shop/product_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../models/cart_item.dart';
import '../../widgets/responsive_container.dart';

class ProductDetailScreen extends StatefulWidget {
  final String id;
  final String title;
  final String imageUrl;
  final int price;

  const ProductDetailScreen({
    super.key,
    required this.id,
    required this.title,
    required this.imageUrl,
    this.price = 1280,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final List<String> _colors = ['米白', '奶茶', '黑色'];
  final List<String> _sizes = ['S', 'M', 'L'];
  
  String _selectedColor = '米白';
  String _selectedSize = 'M';

  void _addToCart() {
    final cartItem = CartItem(
      id: "${widget.id}_${DateTime.now().millisecondsSinceEpoch}",
      
      // [修正重點 1] 對應 CartItem 的 name 參數
      name: widget.title,      
      
      // [修正重點 2] 對應 CartItem 的 image 參數
      image: widget.imageUrl,  
      
      price: widget.price,
      quantity: 1,
      type: ItemType.product,
      // isSelected: true, // 您的 CartItem 預設已經是 true，這裡可以省略或保留
    );

    Provider.of<CartProvider>(context, listen: false).addItem(cartItem);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("已加入購物車: ${widget.title} ($_selectedColor/$_selectedSize)"),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
        action: SnackBarAction(
          label: "去結帳", 
          textColor: Colors.amber,
          onPressed: () => Navigator.pop(context), 
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ResponsiveContainer(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 400,
                    pinned: true,
                    backgroundColor: Colors.white,
                    leading: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: Colors.white54, shape: BoxShape.circle),
                      child: const BackButton(color: Colors.black),
                    ),
                    actions: [
                      Container(
                        margin: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(color: Colors.white54, shape: BoxShape.circle),
                        child: IconButton(onPressed: (){}, icon: const Icon(Icons.share_outlined, color: Colors.black)),
                      ),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: Image.network(widget.imageUrl, fit: BoxFit.cover),
                    ),
                  ),
                  
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text("NT\$${widget.price}", style: const TextStyle(fontSize: 22, color: Colors.redAccent, fontWeight: FontWeight.bold)),
                          
                          const SizedBox(height: 24),
                          const Divider(height: 1),
                          const SizedBox(height: 24),

                          const Text("顏色", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 10,
                            children: _colors.map((color) => ChoiceChip(
                              label: Text(color),
                              selected: _selectedColor == color,
                              onSelected: (val) => setState(() => _selectedColor = color),
                              selectedColor: Colors.purple.withOpacity(0.1),
                              backgroundColor: Colors.grey[100],
                              labelStyle: TextStyle(color: _selectedColor == color ? Colors.purple : Colors.black),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(color: _selectedColor == color ? Colors.purple : Colors.transparent)
                              ),
                            )).toList(),
                          ),
                          const SizedBox(height: 20),

                          const Text("尺寸", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 10,
                            children: _sizes.map((size) => ChoiceChip(
                              label: Text(size),
                              selected: _selectedSize == size,
                              onSelected: (val) => setState(() => _selectedSize = size),
                              selectedColor: Colors.purple.withOpacity(0.1),
                              backgroundColor: Colors.grey[100],
                              labelStyle: TextStyle(color: _selectedSize == size ? Colors.purple : Colors.black),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(color: _selectedSize == size ? Colors.purple : Colors.transparent)
                              ),
                            )).toList(),
                          ),
                          
                          const SizedBox(height: 30),
                          const Text("商品介紹", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 8),
                          const Text(
                            "這是一件非常舒適的百搭單品，適合各種場合穿著。採用高品質棉料製作，透氣親膚。\n\n- 材質：100% 棉\n- 產地：韓國\n- 洗滌方式：建議手洗",
                            style: TextStyle(color: Colors.black54, height: 1.6, fontSize: 15),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    IconButton(onPressed: (){}, icon: const Icon(Icons.storefront_outlined)),
                    IconButton(onPressed: (){}, icon: const Icon(Icons.favorite_border)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _addToCart,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("加入購物車", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
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