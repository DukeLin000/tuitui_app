import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// 第一階段：素材選擇 (Media Picker)
// 對應需求：選擇素材 (相冊/拍攝)、切換模式
// ---------------------------------------------------------------------------
class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // 模擬相冊圖片 (使用顏色區塊代替)
  final List<Color> _mockGallery = List.generate(20, (index) => Colors.primaries[index % Colors.primaries.length].withOpacity(0.5));
  int _selectedIndex = -1; // 記錄選中的圖片索引

  @override
  void initState() {
    super.initState();
    // 底部三個模式：圖片、視頻、文字
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _goToEditor() {
    if (_selectedIndex == -1) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("請先選擇一張照片")));
      return;
    }
    // 跳轉到第二階段：編輯頁面
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoEditorScreen(imageColor: _mockGallery[_selectedIndex]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // 相冊選擇通常是深色背景
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            // 切換回首頁 (MainScreen 的 Index 0)
            // 這裡簡單處理：如果是 push 過來的就 pop，如果是 Tab 切換的可能需要 callback
            // 由於我們在 MainScreen 是用 body 切換，這裡暫時留空或顯示提示
             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("取消發布")));
          },
        ),
        title: const Text("最近項目", style: TextStyle(color: Colors.white, fontSize: 16)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _goToEditor,
            child: const Text("下一步", style: TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: Column(
        children: [
          // 1. 預覽區域 (模擬相機取景或大圖預覽)
          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              color: Colors.grey[900],
              child: _selectedIndex != -1 
                ? Container(color: _mockGallery[_selectedIndex], child: const Center(child: Text("預覽圖片", style: TextStyle(color: Colors.white))))
                : const Center(child: Icon(Icons.camera_alt, color: Colors.grey, size: 64)),
            ),
          ),
          
          // 2. 底部功能區 (模式切換 + 相冊網格)
          Expanded(
            flex: 4,
            child: Column(
              children: [
                // 工具列
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Colors.black,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("最近項目", style: TextStyle(color: Colors.white)),
                      IconButton(icon: const Icon(Icons.camera_alt_outlined, color: Colors.white), onPressed: (){}),
                    ],
                  ),
                ),
                // 相冊網格
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(2),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                    ),
                    itemCount: _mockGallery.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => setState(() => _selectedIndex = index),
                        child: Container(
                          color: _mockGallery[index],
                          child: _selectedIndex == index 
                            ? Container(color: Colors.black54, child: const Icon(Icons.check, color: Colors.white))
                            : null,
                        ),
                      );
                    },
                  ),
                ),
                // 底部模式切換 (圖片/視頻/文字)
                Container(
                  color: Colors.black,
                  height: 50,
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.redAccent,
                    indicatorSize: TabBarIndicatorSize.label,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey,
                    tabs: const [
                      Tab(text: "圖片"),
                      Tab(text: "視頻"),
                      Tab(text: "文字"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 第二階段：美化與編輯 (Photo Editor)
// 對應需求：濾鏡/調節、標籤、配樂/貼紙/文字
// ---------------------------------------------------------------------------
class PhotoEditorScreen extends StatelessWidget {
  final Color imageColor; // 接收上一頁選的顏色當作圖片

  const PhotoEditorScreen({super.key, required this.imageColor});

  void _goToPublish(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostPublishScreen(imageColor: imageColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () => _goToPublish(context),
            style: TextButton.styleFrom(
              backgroundColor: Colors.redAccent,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text("下一步", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          // 圖片編輯區
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: imageColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  const Center(child: Text("圖片編輯預覽", style: TextStyle(color: Colors.white, fontSize: 20))),
                  // 模擬標籤 (Tag)
                  Positioned(
                    top: 100, left: 100,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(4)),
                      child: const Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.white, size: 12),
                          SizedBox(width: 4),
                          Text("標籤: OOTD", style: TextStyle(color: Colors.white, fontSize: 12)),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          // 底部工具列 (配樂、貼紙、文字、濾鏡)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            color: Colors.black,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _EditorTool(icon: Icons.music_note, label: "配樂"),
                _EditorTool(icon: Icons.text_fields, label: "文字"),
                _EditorTool(icon: Icons.emoji_emotions_outlined, label: "貼紙"),
                _EditorTool(icon: Icons.filter_vintage, label: "濾鏡"),
                _EditorTool(icon: Icons.tune, label: "調節"),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _EditorTool extends StatelessWidget {
  final IconData icon;
  final String label;
  const _EditorTool({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 10)),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 第三階段：發布設定 (Publish Form)
// 對應需求：標題(20字)、正文(1000字)、話題、地點、存草稿
// ---------------------------------------------------------------------------
class PostPublishScreen extends StatefulWidget {
  final Color imageColor;
  const PostPublishScreen({super.key, required this.imageColor});

  @override
  State<PostPublishScreen> createState() => _PostPublishScreenState();
}

class _PostPublishScreenState extends State<PostPublishScreen> {
  // 處理返回鍵存草稿邏輯
  Future<bool> _onWillPop() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("保存草稿？"),
        content: const Text("如果不保存，剛才的編輯將會丟失"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // 不保存，直接離開
            child: const Text("不保存", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              // 這裡執行存草稿邏輯
              Navigator.of(context).pop(true);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("已保存至草稿箱")));
            },
            child: const Text("保存", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () async {
              if (await _onWillPop() && context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("發布成功！")));
                  // 回到首頁 (移除所有路由直到首頁)
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF1744), // 紅色按鈕
                  shape: const StadiumBorder(),
                  elevation: 0,
                ),
                child: const Text("發布筆記", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. 圖片與標題區
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 縮圖
                  Container(
                    width: 100, height: 100,
                    decoration: BoxDecoration(
                      color: widget.imageColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(child: Icon(Icons.image, color: Colors.white)),
                  ),
                  const SizedBox(width: 12),
                  // 標題輸入 (SEO: 20字內)
                  Expanded(
                    child: TextField(
                      maxLength: 20,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: "填寫標題 會吸引更多人喔～",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),
                        border: InputBorder.none,
                        counterText: "", // 隱藏計數器，或自定義顯示
                      ),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const Divider(height: 30),
              
              // 2. 正文輸入 (SEO: 1000字內)
              TextField(
                maxLength: 1000,
                maxLines: 8,
                decoration: const InputDecoration(
                  hintText: "添加正文\n#話題 #穿搭",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
              
              const SizedBox(height: 10),
              
              // 3. 快捷選項 (話題、@、地點)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _ActionChip(icon: Icons.grid_3x3, label: "話題"),
                    const SizedBox(width: 8),
                    _ActionChip(icon: Icons.alternate_email, label: "用戶"),
                    const SizedBox(width: 8),
                    _ActionChip(icon: Icons.location_on_outlined, label: "添加地點"),
                  ],
                ),
              ),
              
              const Divider(height: 30),
              
              // 4. 其他選項
              const _OptionTile(icon: Icons.public, title: "權限設定", value: "公開"),
              const _OptionTile(icon: Icons.download, title: "保存到相冊", value: "", isSwitch: true),
              const _OptionTile(icon: Icons.settings, title: "高級設定", value: ""),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  _ActionChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.black87),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.black87)),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool isSwitch;
  const _OptionTile({required this.icon, required this.title, required this.value, this.isSwitch = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.black54, size: 20),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontSize: 15)),
          const Spacer(),
          if (isSwitch) 
            const SizedBox(
              height: 24, width: 40,
              child: Switch(value: true, onChanged: null, activeColor: Colors.redAccent),
            )
          else 
            Row(
              children: [
                Text(value, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
              ],
            )
        ],
      ),
    );
  }
}