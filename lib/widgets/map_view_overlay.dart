// lib/widgets/map_view_overlay.dart
import 'package:flutter/material.dart';

class MapViewOverlay extends StatelessWidget {
  final VoidCallback onClose; // 讓外部傳入「關閉」的動作

  const MapViewOverlay({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54, // 半透明黑色背景
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              // 1. 標題列
              AppBar(
                title: const Text("附近店家"),
                backgroundColor: Colors.white,
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: onClose, // 點擊叉叉時執行關閉
                  )
                ],
              ),
              
              // 2. 地圖內容 (這裡先用灰色區塊模擬)
              Expanded(
                child: Container(
                  color: Colors.grey[100],
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.map_outlined, size: 64, color: Colors.purple),
                      const SizedBox(height: 16),
                      const Text(
                        "目前位置: 中山站",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text("地圖模組載入中...", style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: onClose,
                        icon: const Icon(Icons.arrow_back),
                        label: const Text("返回列表"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}