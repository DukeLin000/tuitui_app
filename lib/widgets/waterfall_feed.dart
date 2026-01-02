// lib/widgets/waterfall_feed.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; 
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart'; // 確保您有安裝此套件
import '../models/waterfall_item.dart';
import '../models/cart_item.dart';
import '../providers/cart_provider.dart';
// [新增] 引入跳轉頁面
import '../screens/shop/product_detail_screen.dart';
import '../screens/shop/store_profile_screen.dart';

class WaterfallFeed extends StatelessWidget {
  final List<WaterfallItem> items;

  const WaterfallFeed({super.key, required this.items});

  // [保留] 預約選擇彈窗方法 (邏輯不變)
  void _showBookingPicker(BuildContext context, WaterfallItem item) {
    DateTime localSelectedDate = DateTime.now().add(const Duration(days: 1));
    String localSelectedTime = "";
    int localPeopleCount = 2;

    final Map<String, List<String>> fullSlotsData = {
      DateFormat('yyyy-MM-dd').format(DateTime.now().add(const Duration(days: 1))): ["14:00", "15:00"],
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            String dateKey = DateFormat('yyyy-MM-dd').format(localSelectedDate);
            List<String> currentFullSlots = fullSlotsData[dateKey] ?? [];

            return Padding(
              padding: EdgeInsets.only(
                left: 20, right: 20, top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text("預約 ${item.title}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                      ),
                      IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                    ],
                  ),
                  const Divider(),
                  const Text("選擇預約日期", style: TextStyle(fontWeight: FontWeight.bold)),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.calendar_month, color: Colors.orange),
                    title: Text(DateFormat('yyyy年MM月dd日').format(localSelectedDate)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: localSelectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 90)),
                      );
                      if (picked != null) {
                        setModalState(() {
                          localSelectedDate = picked;
                          localSelectedTime = "";
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text("選擇時段", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10,
                    children: ["11:00", "13:00", "15:00", "17:00", "19:00"].map((time) {
                      bool isFull = currentFullSlots.contains(time);
                      bool isSelected = localSelectedTime == time;
                      return ChoiceChip(
                        label: Text(isFull ? "$time (已滿)" : time),
                        selected: isSelected,
                        onSelected: isFull ? null : (selected) {
                          setModalState(() => localSelectedTime = time);
                        },
                        selectedColor: Colors.purple.withOpacity(0.2),
                        labelStyle: TextStyle(color: isFull ? Colors.grey : (isSelected ? Colors.purple : Colors.black87)),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("預約人數", style: TextStyle(fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          IconButton(
                            onPressed: localPeopleCount > 1 ? () => setModalState(() => localPeopleCount--) : null,
                            icon: const Icon(Icons.remove_circle_outline),
                          ),
                          Text("$localPeopleCount 位", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          IconButton(
                            onPressed: () => setModalState(() => localPeopleCount++),
                            icon: const Icon(Icons.add_circle_outline),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: localSelectedTime.isEmpty ? null : () {
                        final bookingStr = "${DateFormat('yyyy-MM-dd').format(localSelectedDate)} $localSelectedTime";
                        // [修改] 使用 addItem 配合新的 CartItem 結構
                        Provider.of<CartProvider>(context, listen: false).addItem(
                          CartItem(
                            id: "${item.id}_${DateTime.now().millisecondsSinceEpoch}",
                            name: item.title,
                            price: item.price ?? 0,
                            image: item.image,
                            type: ItemType.reservation,
                            bookingDate: bookingStr,
                            peopleCount: localPeopleCount,
                            isSelected: true,
                          )
                        );
                        
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("已預約 $bookingStr ($localPeopleCount位) 已加入購物車")),
                        );
                      },
                      style: FilledButton.styleFrom(backgroundColor: Colors.purple, padding: const EdgeInsets.all(16)),
                      child: Text(localSelectedTime.isEmpty ? "請選擇時段" : "確認預約並加入購物車"),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isProduct = item.price != null;

        return GestureDetector(
          // [新增] 點擊卡片跳轉到商品詳情
          onTap: () {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (_) => ProductDetailScreen(
                id: item.id,
                title: item.title,
                imageUrl: item.image,
                price: item.price ?? 1280, // 若沒價格則用預設值
              ))
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 圖片區
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  child: Image.network(
                    item.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 150, // 給個固定高度避免版面跑掉
                      color: Colors.grey[200],
                      child: const Center(child: Icon(Icons.image_not_supported, color: Colors.grey)),
                    ),
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 標題
                      Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis, 
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 6),
                      
                      // 價格與購物車按鈕 (僅商品顯示)
                      if (isProduct)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('NT\$ ${item.price}', 
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red)),
                            
                            // 根據類型顯示不同按鈕
                            if (item.type == ItemType.reservation)
                              IconButton(
                                icon: const Icon(Icons.calendar_month, size: 20, color: Colors.orange),
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.zero,
                                onPressed: () => _showBookingPicker(context, item),
                              )
                            else
                              IconButton(
                                icon: const Icon(Icons.add_shopping_cart, size: 20, color: Colors.purple),
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  // [修改] 使用 addItem
                                  Provider.of<CartProvider>(context, listen: false).addItem(
                                    CartItem(
                                      id: "${item.id}_${DateTime.now().millisecondsSinceEpoch}",
                                      name: item.title,
                                      price: item.price!,
                                      image: item.image,
                                      type: ItemType.product,
                                      isSelected: true,
                                    )
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("已加入購物車")));
                                },
                              ),
                          ],
                        )
                      else
                        // 作者資訊 (非商品模式，或是底部資訊列)
                        // [新增] 點擊作者跳轉到店鋪主頁
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => StoreProfileScreen(
                                  merchantName: item.authorName,
                                  avatarUrl: item.authorAvatar,
                                ),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 8, 
                                backgroundImage: item.authorAvatar.isNotEmpty ? NetworkImage(item.authorAvatar) : null, 
                                backgroundColor: Colors.grey[300]
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(item.authorName, 
                                  style: const TextStyle(fontSize: 11, color: Colors.grey), 
                                  maxLines: 1, overflow: TextOverflow.ellipsis)
                              ),
                              const Icon(Icons.favorite_border, size: 12, color: Colors.grey),
                              const SizedBox(width: 2),
                              Text('${item.likes}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                            ],
                          ),
                        )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}