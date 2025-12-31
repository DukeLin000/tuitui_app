// lib/widgets/waterfall_feed.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // 確保 pubspec.yaml 已加入 intl 套件
import '../models/waterfall_item.dart';
import '../models/cart_item.dart';
import '../providers/cart_provider.dart';

class WaterfallFeed extends StatelessWidget {
  final List<WaterfallItem> items;

  const WaterfallFeed({super.key, required this.items});

  // [修正] 預約選擇彈窗方法
  void _showBookingPicker(BuildContext context, WaterfallItem item) {
    // 1. 在彈窗外定義初始值
    DateTime localSelectedDate = DateTime.now().add(const Duration(days: 1));
    String localSelectedTime = "";
    int localPeopleCount = 2;

    // 模擬已滿時段 (Key: yyyy-MM-dd)
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
                        child: Text(
                          "預約 ${item.title}", 
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                    ],
                  ),
                  const Divider(),

                  // 1. 日期選擇
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
                          localSelectedTime = ""; // 日期改變後需重選時段
                        });
                      }
                    },
                  ),

                  // 2. 時段選擇 (ChoiceChips)
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
                        labelStyle: TextStyle(
                          color: isFull ? Colors.grey : (isSelected ? Colors.purple : Colors.black87),
                        ),
                      );
                    }).toList(),
                  ),

                  // 3. 人數選擇
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("預預人數", style: TextStyle(fontWeight: FontWeight.bold)),
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

                  // 4. 確認按鈕
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: localSelectedTime.isEmpty ? null : () {
                        final bookingStr = "${DateFormat('yyyy-MM-dd').format(localSelectedDate)} $localSelectedTime";
                        
                        // [關鍵] 確保與 CartProvider 的 addToCart 參數一致
                        Provider.of<CartProvider>(context, listen: false).addToCart(
                          item.id,
                          item.title,
                          item.price ?? 0,
                          item.image,
                          type: ItemType.reservation,
                          bookingDate: bookingStr,
                          peopleCount: localPeopleCount,
                        );
                        
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("已預約 $bookingStr ($localPeopleCount位) 已加入購物車")),
                        );
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: const EdgeInsets.all(16),
                      ),
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
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 260,
            childAspectRatio: 0.75,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final isProduct = item.price != null;

            return Container(
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
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                      child: Image.network(
                        item.image,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[200],
                          child: const Center(child: Icon(Icons.image_not_supported, color: Colors.grey)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis, 
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 6),
                        
                        if (isProduct)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('NT\$ ${item.price}', 
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red)),
                              
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
                                    Provider.of<CartProvider>(context, listen: false).addToCart(
                                      item.id, item.title, item.price!, item.image,
                                      type: ItemType.product,
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("已加入購物車")));
                                  },
                                ),
                            ],
                          )
                        else
                          Row(
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
                          )
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}