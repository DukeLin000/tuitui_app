import 'package:flutter/material.dart';

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
    // 1. [關鍵修改] 外層包這兩個 Widget，模擬 React 的 layout 效果
    return Center( // 讓內容在 Web 大螢幕上置中
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500), // 限制最大寬度，避免在電腦上拉太寬
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          
          padding: EdgeInsets.zero, 

          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            // 2. [斷點調整] 改為 260。
            // 在手機 (寬~390) 是 2 欄。
            // 在 Web (限寬 500) 500/2 = 250 < 260，所以也會保持「2 欄」，不會變太小。
            maxCrossAxisExtent: 260, 
            
            // 3. [比例] 0.8 讓卡片不會太瘦長，視覺較舒適
            childAspectRatio: 0.8,  
            
            crossAxisSpacing: 12,    
            mainAxisSpacing: 12,     
          ),
          
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Container(
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