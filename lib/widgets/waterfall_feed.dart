import 'package:flutter/material.dart';

// 定義 WaterfallItem，並加上 const 建構子
class WaterfallItem {
  final String id;
  final String image;
  final String title;
  final String authorName;
  final String authorAvatar;
  final int likes;
  final double aspectRatio;

  const WaterfallItem({
    required this.id,
    required this.image,
    required this.title,
    required this.authorName,
    required this.authorAvatar,
    required this.likes,
    required this.aspectRatio,
  });
}

class WaterfallFeed extends StatelessWidget {
  final List<WaterfallItem> items;

  const WaterfallFeed({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.7,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!),
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
                    errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[300]),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        CircleAvatar(radius: 8, backgroundImage: item.authorAvatar.isNotEmpty ? NetworkImage(item.authorAvatar) : null, backgroundColor: Colors.grey[300]),
                        const SizedBox(width: 4),
                        Expanded(child: Text(item.authorName, style: const TextStyle(fontSize: 11, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis)),
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
    );
  }
}