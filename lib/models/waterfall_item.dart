// lib/models/waterfall_item.dart
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