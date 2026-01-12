// lib/widgets/map_view_overlay.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

// 引入設定檔
import '../config/map_style.dart'; 
// [移除] 不需要引入 search_screen.dart，因為我們是在原地搜尋

class MapViewOverlay extends StatefulWidget {
  final VoidCallback onClose;

  const MapViewOverlay({super.key, required this.onClose});

  @override
  State<MapViewOverlay> createState() => _MapViewOverlayState();
}

class _MapViewOverlayState extends State<MapViewOverlay> {
  final Completer<GoogleMapController> _controller = Completer();
  
  // 搜尋文字控制器
  final TextEditingController _searchController = TextEditingController();

  // 台北車站作為預設中心點
  static const CameraPosition _kDefaultCenter = CameraPosition(
    target: LatLng(25.0478, 121.5170),
    zoom: 14.0,
  );

  // 篩選器選項
  final List<String> _filterTags = ["全部", "美食", "好物推薦", "型男穿搭", "週末去哪玩", "約會聖地", "高CP值"];
  String _selectedTag = "全部";

  // 模擬店家資料
  final List<Map<String, dynamic>> _mockBackendStores = [
    {
      "id": "s001",
      "name": "CAFE!N 硬咖啡 (中山店)",
      "lat": 25.0522,
      "lng": 121.5204,
      "category": "咖啡廳",
      "rating": 4.8,
      "pushCount": 156,
      "image": "https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=200",
      "tags": ["美食", "週末去哪玩", "好拍"],
    },
    {
      "id": "s002",
      "name": "誠品生活南西",
      "lat": 25.0520,
      "lng": 121.5215,
      "category": "百貨",
      "rating": 4.9,
      "pushCount": 342,
      "image": "https://images.unsplash.com/photo-1567401893414-76b7b1e5a7a5?w=200",
      "tags": ["好物推薦", "型男穿搭", "週末去哪玩"],
    },
    {
      "id": "s003",
      "name": "榕 ron 2.0",
      "lat": 25.0345,
      "lng": 121.5645,
      "category": "酒吧",
      "rating": 4.6,
      "pushCount": 89,
      "image": "https://images.unsplash.com/photo-1514362545857-3bc16c4c7d1b?w=200",
      "tags": ["美食", "約會聖地", "好拍"],
    },
    {
      "id": "s004",
      "name": "阿宗麵線",
      "lat": 25.0430,
      "lng": 121.5070,
      "category": "小吃",
      "rating": 4.2,
      "pushCount": 520,
      "image": "https://images.unsplash.com/photo-1555126634-323283e090fa?w=200",
      "tags": ["美食", "高CP值"],
    },
  ];

  Set<Marker> _markers = {};
  String? _selectedShopId;
  Map<String, dynamic>? _selectedShopData;

  @override
  void initState() {
    super.initState();
    _loadMarkers();
    _locateUser();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  double _getMarkerHue(List<String> tags) {
    if (tags.contains('美食')) return BitmapDescriptor.hueRed;
    if (tags.contains('好物推薦') || tags.contains('型男穿搭')) return BitmapDescriptor.hueBlue;
    if (tags.contains('週末去哪玩')) return BitmapDescriptor.hueGreen;
    if (tags.contains('約會聖地')) return BitmapDescriptor.hueViolet;
    if (tags.contains('高CP值')) return BitmapDescriptor.hueOrange;
    return BitmapDescriptor.hueAzure;
  }

  // ★★★ [核心邏輯] 雙重過濾：標籤 + 關鍵字 ★★★
  void _loadMarkers() {
    String query = _searchController.text.trim(); // 取得搜尋框文字

    final filteredStores = _mockBackendStores.where((store) {
      final List<String> tags = store['tags'] ?? [];
      final String name = store['name'] ?? "";
      final String category = store['category'] ?? "";

      // 1. 檢查標籤是否符合 (全部 或 包含選中標籤)
      bool matchTag = _selectedTag == "全部" || tags.contains(_selectedTag);

      // 2. 檢查關鍵字是否符合 (店名 或 類別 或 標籤)
      bool matchText = true;
      if (query.isNotEmpty) {
        matchText = name.contains(query) || 
                    category.contains(query) ||
                    tags.any((t) => t.contains(query));
      }

      // 必須同時符合兩個條件
      return matchTag && matchText;
    }).toList();

    setState(() {
      _markers = filteredStores.map((store) {
        bool isSelected = (store['id'] == _selectedShopId);
        final List<String> tags = store['tags'] ?? [];
        double markerHue = _getMarkerHue(tags);

        return Marker(
          markerId: MarkerId(store['id']),
          position: LatLng(store['lat'], store['lng']),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            isSelected ? BitmapDescriptor.hueYellow : markerHue
          ),
          zIndex: isSelected ? 10.0 : 1.0,
          onTap: () {
            setState(() {
              _selectedShopId = store['id'];
              _selectedShopData = store;
              _loadMarkers(); // 更新圖釘顏色 (選中變黃)
            });
            _moveCameraToShop(store['lat'], store['lng']);
          },
        );
      }).toSet();
    });
  }

  Future<void> _moveCameraToShop(double lat, double lng) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLng(LatLng(lat - 0.002, lng)));
  }

  Future<void> _locateUser() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition();
    final GoogleMapController controller = await _controller.future;
    
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 15.0,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 重要：設為 false 避免鍵盤彈出時把地圖擠上去
      resizeToAvoidBottomInset: false, 
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // A. 地圖層
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kDefaultCenter,
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              try {
                controller.setMapStyle(
                  TuiTuiMapStyles.getStyle(
                    showBusiness: true, 
                    showTransit: true, 
                  )
                );
              } catch (e) {
                print("Map style error: $e");
              }
            },
            // 點擊地圖空白處
            onTap: (_) {
              // 1. 收起鍵盤
              FocusScope.of(context).unfocus();
              
              // 2. 取消選中的店家
              if (_selectedShopId != null) {
                setState(() {
                  _selectedShopId = null;
                  _selectedShopData = null;
                  _loadMarkers(); // 還原圖釘顏色
                });
              }
            },
          ),

          // B. 頂部導航與篩選列
          Positioned(
            top: 50, left: 0, right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. 搜尋輸入框與關閉按鈕
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      // 關閉按鈕
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.black87),
                          onPressed: widget.onClose,
                        ),
                      ),
                      const SizedBox(width: 12),
                      
                      // ★★★ [搜尋框] 這是真正的 TextField ★★★
                      Expanded(
                        child: Container(
                          height: 45,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.search, color: Colors.grey),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  onChanged: (value) {
                                    // 當文字改變時，直接重新過濾地圖上的 Marker
                                    _loadMarkers();
                                  },
                                  decoration: const InputDecoration(
                                    hintText: "搜尋店名或標籤...",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                    isDense: true, 
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  style: const TextStyle(color: Colors.black87),
                                  textInputAction: TextInputAction.search,
                                ),
                              ),
                              // 清除按鈕 (有文字時才顯示)
                              if (_searchController.text.isNotEmpty)
                                GestureDetector(
                                  onTap: () {
                                    _searchController.clear(); // 清空文字
                                    _loadMarkers();            // 還原所有 Marker
                                    FocusScope.of(context).unfocus(); // 收鍵盤
                                  },
                                  child: const Icon(Icons.cancel, color: Colors.grey, size: 20),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 12),

                // 2. 標籤篩選器 (Filter Chips)
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filterTags.length,
                    itemBuilder: (context, index) {
                      final tag = _filterTags[index];
                      final isSelected = _selectedTag == tag;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text(tag),
                          selected: isSelected,
                          onSelected: (bool selected) {
                            setState(() {
                              if (isSelected && tag != "全部") {
                                _selectedTag = "全部"; // 取消選取則回歸全部
                              } else {
                                _selectedTag = tag;
                              }
                              _loadMarkers(); // 重新過濾 Marker
                            });
                          },
                          backgroundColor: Colors.white,
                          selectedColor: Colors.black, 
                          checkmarkColor: Colors.white,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: Colors.grey[300]!),
                          ),
                          elevation: 2,
                          shadowColor: Colors.black12,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // C. 定位按鈕
          Positioned(
            right: 16,
            bottom: _selectedShopId != null ? 180 : 32,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              foregroundColor: Colors.purple,
              onPressed: _locateUser,
              child: const Icon(Icons.my_location),
            ),
          ),

          // D. 店家資訊卡片
          if (_selectedShopData != null)
            Positioned(
              left: 16, right: 16, bottom: 32,
              child: _buildShopCard(_selectedShopData!),
            ),
        ],
      ),
    );
  }

  // 店家卡片 UI (保持不變)
  Widget _buildShopCard(Map<String, dynamic> shop) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(0, 5))],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              shop['image'], 
              width: 90, height: 90, 
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 90, height: 90, color: Colors.grey[200], child: const Icon(Icons.store),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(shop['name'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: Colors.purple[50], borderRadius: BorderRadius.circular(4)),
                      child: Text(shop['category'], style: const TextStyle(fontSize: 10, color: Colors.purple)),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.star, size: 12, color: Colors.amber),
                    Text(" ${shop['rating']}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.local_fire_department, size: 14, color: Colors.deepOrange),
                    Text(
                      " ${shop['pushCount']} 人推推", 
                      style: const TextStyle(fontSize: 12, color: Colors.deepOrange, fontWeight: FontWeight.bold)
                    ),
                  ],
                ),
              ],
            ),
          ),
          CircleAvatar(
            backgroundColor: Colors.purple,
            child: IconButton(
              icon: const Icon(Icons.directions, color: Colors.white),
              onPressed: () {
                // TODO: 開啟 Google Maps App 導航
              },
            ),
          )
        ],
      ),
    );
  }
}