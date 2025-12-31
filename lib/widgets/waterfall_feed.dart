// lib/widgets/waterfall_feed.dart
import 'package:flutter/material.dart';
import '../models/waterfall_item.dart'; // [新增] 匯入 Model

// [已刪除] WaterfallItem 類別定義

class WaterfallFeed extends StatelessWidget {
  final List<WaterfallItem> items;

  const WaterfallFeed({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    // ... (原本的 build 內容保持不變，不用動)
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 260,
            childAspectRatio: 0.8,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Container(
              // ... (保持不變)
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
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
                          child: const Center(
                            child: Icon(Icons.image_not_supported, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title, 
                          maxLines: 2, 
                          overflow: TextOverflow.ellipsis, 
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 8, 
                              backgroundImage: item.authorAvatar.isNotEmpty ? NetworkImage(item.authorAvatar) : null, 
                              backgroundColor: Colors.grey[300]
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                item.authorName, 
                                style: const TextStyle(fontSize: 11, color: Colors.grey), 
                                maxLines: 1, 
                                overflow: TextOverflow.ellipsis
                              )
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