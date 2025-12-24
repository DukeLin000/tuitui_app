// lib/screens/edit_profile_screen.dart
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  final String currentName;
  final String currentBio;
  final String currentAvatar;

  const EditProfileScreen({
    super.key,
    required this.currentName,
    required this.currentBio,
    required this.currentAvatar,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _bioController = TextEditingController(text: widget.currentBio);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    // 將修改後的資料打包回傳給上一頁
    Navigator.pop(context, {
      'name': _nameController.text,
      'bio': _bioController.text,
      // 實際專案中這裡會包含上傳圖片的邏輯，現在先回傳原圖
      'avatar': widget.currentAvatar, 
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
        child: Column(
          children: [
            // 1. 頭像編輯區
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

            // 2. 表單區
            _buildTextField(label: "名字", controller: _nameController),
            const SizedBox(height: 20),
            _buildTextField(label: "小紅書號", hint: "42942190219 (不可修改)", enabled: false),
            const SizedBox(height: 20),
            _buildTextField(label: "簡介", controller: _bioController, maxLines: 3),
            const SizedBox(height: 20),
            
            // 性別/生日等選項 (視覺展示)
            const _ProfileOptionTile(title: "性別", value: "保密"),
            const Divider(height: 1),
            const _ProfileOptionTile(title: "生日", value: "選擇生日"),
            const Divider(height: 1),
            const _ProfileOptionTile(title: "地區", value: "台灣 台北"),
          ],
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
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
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
  const _ProfileOptionTile({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          Row(
            children: [
              Text(value, style: const TextStyle(color: Colors.grey, fontSize: 14)),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: Colors.grey, size: 18),
            ],
          )
        ],
      ),
    );
  }
}