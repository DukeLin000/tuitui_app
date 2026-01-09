// lib/config/map_style.dart

class TuiTuiMapStyles {
  // ==========================================
  // 🎨 推推品牌色系定義 (集中管理)
  // ==========================================
  static const String _colorBackground = "#f5f5f5";
  static const String _colorText      = "#616161";
  static const String _colorPark      = "#e6ebe3"; // 護眼綠
  static const String _colorWater     = "#e9e5f9"; // 推推淡紫
  static const String _colorRoad      = "#ffffff";
  static const String _colorHighway   = "#dadada";

  // ==========================================
  // 🛠️ 動態樣式產生器
  // ==========================================
  // features:
  // 1. [showBusiness] : true=顯示商家(方便找店), false=極簡(強調推推店家)
  // 2. [showTransit]  : true=顯示捷運/公車線, false=隱藏
  static String getStyle({
    bool showBusiness = false, 
    bool showTransit = true,
  }) {
    return '''
    [
      {
        "elementType": "geometry",
        "stylers": [
          {"color": "$_colorBackground"},
          {"saturation": -10} 
        ]
      },
      {
        "elementType": "labels.icon",
        "stylers": [{"visibility": "${showBusiness ? 'on' : 'off'}"}]
      },
      {
        "elementType": "labels.text.fill",
        "stylers": [{"color": "$_colorText"}]
      },
      {
        "elementType": "labels.text.stroke",
        "stylers": [{"color": "$_colorBackground"}]
      },
      {
        "featureType": "administrative.land_parcel",
        "elementType": "labels.text.fill",
        "stylers": [{"visibility": "off"}]
      },
      {
        "featureType": "poi",
        "elementType": "geometry",
        "stylers": [{"color": "#eeeeee"}]
      },
      {
        "featureType": "poi",
        "elementType": "labels.text.fill",
        "stylers": [{"color": "#757575"}]
      },
      {
        "featureType": "poi.park",
        "elementType": "geometry",
        "stylers": [{"color": "$_colorPark"}]
      },
      {
        "featureType": "poi.business",
        "stylers": [{"visibility": "${showBusiness ? 'on' : 'off'}"}]
      },
      {
        "featureType": "road",
        "elementType": "geometry",
        "stylers": [{"color": "$_colorRoad"}]
      },
      {
        "featureType": "road.arterial",
        "elementType": "labels.text.fill",
        "stylers": [{"color": "#757575"}]
      },
      {
        "featureType": "road.highway",
        "elementType": "geometry",
        "stylers": [{"color": "$_colorHighway"}]
      },
      {
        "featureType": "road.highway",
        "elementType": "labels.text.fill",
        "stylers": [{"color": "$_colorText"}]
      },
      {
        "featureType": "road.local",
        "elementType": "labels.text.fill",
        "stylers": [{"color": "#9e9e9e"}]
      },
      {
        "featureType": "transit.line",
        "elementType": "geometry",
        "stylers": [
          {"color": "#e5e5e5"},
          {"visibility": "${showTransit ? 'on' : 'off'}"}
        ]
      },
      {
        "featureType": "transit.station",
        "elementType": "geometry",
        "stylers": [{"color": "#eeeeee"}]
      },
      {
        "featureType": "water",
        "elementType": "geometry",
        "stylers": [{"color": "$_colorWater"}]
      },
      {
        "featureType": "water",
        "elementType": "labels.text.fill",
        "stylers": [{"color": "#9e9e9e"}]
      }
    ]
    ''';
  }
}