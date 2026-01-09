// lib/screens/profile/edit_profile_screen.dart
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  final String currentName;
  final String currentBio;
  final String currentAvatar;
  final String? currentGender; 
  final DateTime? currentBirthday;
  final String? currentRegion; 

  const EditProfileScreen({
    super.key,
    required this.currentName,
    required this.currentBio,
    required this.currentAvatar,
    this.currentGender,
    this.currentBirthday,
    this.currentRegion,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  
  // 狀態變數
  String _gender = "保密";
  DateTime? _birthday;
  String _region = "台灣 台北"; 

  // [新增] 模擬全球化資料結構：國家 -> 城市 -> 行政區
  final Map<String, Map<String, List<String>>> _globalLocations = {
    'Taiwan (台灣)': {
      '台北市': ['中正區', '信義區', '大安區', '士林區', '北投區'],
      '新北市': ['板橋區', '新莊區', '淡水區', '林口區'],
      '台中市': ['西屯區', '北屯區', '南屯區'],
      '高雄市': ['左營區', '苓雅區', '鼓山區'],
    },
    'Japan (日本)': {
      'Tokyo (東京)': ['Shinjuku (新宿)', 'Shibuya (澀谷)', 'Minato (港區)'],
      'Osaka (大阪)': ['Kita (北區)', 'Chuo (中央區)'],
      'Kyoto (京都)': ['Nakagyo (中京區)', 'Shimogyo (下京區)'],
    },
    'USA (美國)': {
      'California': ['Los Angeles', 'San Francisco', 'San Diego'],
      'New York': ['Manhattan', 'Brooklyn', 'Queens'],
      'Texas': ['Houston', 'Austin'],
    },
  };

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _bioController = TextEditingController(text: widget.currentBio);
    
    // 初始化數值
    if (widget.currentGender != null) _gender = widget.currentGender!;
    if (widget.currentBirthday != null) _birthday = widget.currentBirthday;
    if (widget.currentRegion != null) _region = widget.currentRegion!;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  // --- 選擇器邏輯 (RWD Bottom Sheet) ---
  
  Future<void> _showResponsiveBottomSheet({
    required Widget child,
    bool isScrollControlled = false,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: isScrollControlled,
      builder: (context) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500), 
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // 1. 性別選擇
  void _selectGender() {
    _showResponsiveBottomSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          _buildDragHandle(),
          const SizedBox(height: 16),
          const Text("選擇性別", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          _buildSimpleOption("男性", (val) => setState(() => _gender = val)),
          _buildSimpleOption("女性", (val) => setState(() => _gender = val)),
          _buildSimpleOption("保密", (val) => setState(() => _gender = val)),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // 2. 生日選擇 (DatePicker)
  void _selectBirthday() async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthday ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: now,
      locale: const Locale('zh', 'TW'), 
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Colors.purple), 
            // [修正] 原本寫成 dialogThemeData (錯誤)，改為 dialogTheme (正確)
            dialogTheme: const DialogThemeData(
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16)))
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _birthday) {
      setState(() {
        _birthday = picked;
      });
    }
  }

  // 3. 地區選擇 (選國家 -> 城市 -> 區域)
  void _selectCountry() {
    _showResponsiveBottomSheet(
      isScrollControlled: true,
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              const SizedBox(height: 12),
              _buildDragHandle(),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("選擇國家 / 地區", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: _globalLocations.keys.length,
                  itemBuilder: (context, index) {
                    final country = _globalLocations.keys.elementAt(index);
                    return ListTile(
                      title: Text(country, textAlign: TextAlign.center),
                      onTap: () {
                        Navigator.pop(context); 
                        _selectCity(country);   
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _selectCity(String country) {
    final citiesMap = _globalLocations[country] ?? {};
    
    _showResponsiveBottomSheet(
      isScrollControlled: true,
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              const SizedBox(height: 12),
              _buildDragHandle(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("$country - 選擇城市", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: citiesMap.keys.length,
                  itemBuilder: (context, index) {
                    final city = citiesMap.keys.elementAt(index);
                    return ListTile(
                      title: Text(city, textAlign: TextAlign.center),
                      onTap: () {
                        Navigator.pop(context);
                        _selectDistrict(country, city);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _selectDistrict(String country, String city) {
    final districts = _globalLocations[country]?[city] ?? [];

    _showResponsiveBottomSheet(
      isScrollControlled: true,
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              const SizedBox(height: 12),
              _buildDragHandle(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("$city - 選擇區域", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: districts.length,
                  itemBuilder: (context, index) {
                    final district = districts[index];
                    return ListTile(
                      title: Text(district, textAlign: TextAlign.center),
                      onTap: () {
                        setState(() {
                          _region = "$country $city $district";
                          if (_region.startsWith("Taiwan")) {
                             _region = _region.replaceAll("Taiwan (台灣) ", "台灣 ");
                          }
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDragHandle() {
    return Container(
      width: 40, height: 4, 
      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))
    );
  }

  Widget _buildSimpleOption(String value, Function(String) onSelect) {
    return ListTile(
      title: Text(value, textAlign: TextAlign.center),
      onTap: () {
        onSelect(value);
        Navigator.pop(context);
      },
    );
  }

  String get _formattedBirthday {
    if (_birthday == null) return "選擇生日";
    return "${_birthday!.year}-${_birthday!.month.toString().padLeft(2, '0')}-${_birthday!.day.toString().padLeft(2, '0')}";
  }

  void _saveProfile() {
    Navigator.pop(context, {
      'name': _nameController.text,
      'bio': _bioController.text,
      'avatar': widget.currentAvatar,
      'gender': _gender,     
      'birthday': _birthday, 
      'region': _region, 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("編輯個人資料", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: const Text("完成", style: TextStyle(color: Colors.purple, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            // [關鍵] 限制最大寬度，比照 home_screen.dart 長型排版
            constraints: const BoxConstraints(maxWidth: 500), 
            child: Column(
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(widget.currentAvatar),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.purple,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text("更換頭像", style: TextStyle(color: Colors.grey, fontSize: 12)),
                
                const SizedBox(height: 30),

                _buildTextField(label: "名字", controller: _nameController),
                const SizedBox(height: 20),
                _buildTextField(label: "推推號", hint: "42942190219 (不可修改)", enabled: false),
                const SizedBox(height: 20),
                _buildTextField(label: "簡介", controller: _bioController, maxLines: 3),
                const SizedBox(height: 20),
                
                _ProfileOptionTile(
                  title: "性別", 
                  value: _gender,
                  onTap: _selectGender,
                ),
                const Divider(height: 1),
                
                _ProfileOptionTile(
                  title: "生日", 
                  value: _formattedBirthday,
                  onTap: _selectBirthday,
                ),
                const Divider(height: 1),
                
                _ProfileOptionTile(
                  title: "地區", 
                  value: _region,
                  onTap: _selectCountry,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, TextEditingController? controller, String? hint, int maxLines = 1, bool enabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          enabled: enabled,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            isDense: true,
            border: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.purple)),
          ),
          style: TextStyle(color: enabled ? Colors.black : Colors.grey[600]),
        ),
      ],
    );
  }
}

class _ProfileOptionTile extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback? onTap;

  const _ProfileOptionTile({
    required this.title, 
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Text(title, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 16),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end, 
                children: [
                  Flexible(
                    child: Text(
                      value, 
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right, color: Colors.grey, size: 18),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}