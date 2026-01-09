// lib/widgets/map_view_overlay.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class MapViewOverlay extends StatefulWidget {
  final VoidCallback onClose;

  const MapViewOverlay({super.key, required this.onClose});

  @override
  State<MapViewOverlay> createState() => _MapViewOverlayState();
}

class _MapViewOverlayState extends State<MapViewOverlay> {
  final Completer<GoogleMapController> _controller = Completer();
  
  // 台北車站作為預設中心點 (如果抓不到定位)
  static const CameraPosition _kDefaultCenter = CameraPosition(
    target: LatLng(25.0478, 121.5170),
    zoom: 14.0,
  );

  // 模擬後端回傳的店家資料 (混合模式：優先顯示這些)
  final List<Map<String, dynamic>> _mockBackendStores = [
    {
      "id": "s001",
      "name": "CAFE!N 硬咖啡 (中山店)",
      "lat": 25.0522,
      "lng": 121.5204,
      "category": "咖啡廳",
      "rating": 4.8,
      "image": "https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=200",
    },
    {
      "id": "s002",
      "name": "誠品生活南西",
      "lat": 25.0520,
      "lng": 121.5215,
      "category": "百貨",
      "rating": 4.9,
      "image": "https://images.unsplash.com/photo-1567401893414-76b7b1e5a7a5?w=200",
    },
    {
      "id": "s003",
      "name": "榕 ron 2.0",
      "lat": 25.0345,
      "lng": 121.5645,
      "category": "酒吧",
      "rating": 4.6,
      "image": "https://images.unsplash.com/photo-1514362545857-3bc16c4c7d1b?w=200",
    },
  ];

  Set<Marker> _markers = {};
  String? _selectedShopId;
  Map<String, dynamic>? _selectedShopData;

  @override
  void initState() {
    super.initState();
    _loadMarkers();
    _locateUser(); // 嘗試抓取目前位置
  }

  // 1. 建立地標
  void _loadMarkers() {
    setState(() {
      _markers = _mockBackendStores.map((store) {
        return Marker(
          markerId: MarkerId(store['id']),
          position: LatLng(store['lat'], store['lng']),
          infoWindow: InfoWindow(title: store['name']), // 點擊顯示名稱
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet), // 推推專屬紫色
          onTap: () {
            setState(() {
              _selectedShopId = store['id'];
              _selectedShopData = store;
            });
          },
        );
      }).toSet();
    });
  }

  // 2. 定位使用者
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

    // 取得位置
    Position position = await Geolocator.getCurrentPosition();
    final GoogleMapController controller = await _controller.future;
    
    // 移動鏡頭
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
      backgroundColor: Colors.transparent, // 背景透明，疊加在首頁上
      body: Stack(
        children: [
          // A. 地圖層
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kDefaultCenter,
            markers: _markers,
            myLocationEnabled: true, // 顯示藍點
            myLocationButtonEnabled: false, // 自訂按鈕比較漂亮
            zoomControlsEnabled: false, // 隱藏醜醜的縮放按鈕
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            onTap: (_) {
              // 點擊地圖空白處，關閉卡片
              if (_selectedShopId != null) {
                setState(() {
                  _selectedShopId = null;
                  _selectedShopData = null;
                });
              }
            },
          ),

          // B. 頂部導航列 (浮動)
          Positioned(
            top: 50, left: 16, right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 搜尋或篩選按鈕
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.filter_list, color: Colors.black87),
                    onPressed: () {}, // TODO: 篩選類別
                  ),
                ),
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
              ],
            ),
          ),

          // C. 底部定位按鈕
          Positioned(
            right: 16,
            bottom: _selectedShopId != null ? 180 : 32, // 如果有卡片，按鈕往上移
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              foregroundColor: Colors.purple,
              child: const Icon(Icons.my_location),
              onPressed: _locateUser,
            ),
          ),

          // D. 店家資訊卡片 (選中時滑出)
          if (_selectedShopData != null)
            Positioned(
              left: 16, right: 16, bottom: 32,
              child: _buildShopCard(_selectedShopData!),
            ),
        ],
      ),
    );
  }

  // 店家卡片 UI
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
          // 圖片
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
          // 資訊
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
                const SizedBox(height: 8),
                Text("點擊查看詳情 >", style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              ],
            ),
          ),
          // 導航按鈕
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