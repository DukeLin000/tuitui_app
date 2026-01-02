import 'package:flutter/material.dart';
import '../../widgets/responsive_container.dart'; // [新增] 引入 RWD 容器

// ---------------------------------------------------------------------------
// 第一階段：素材選擇 (Media Picker) - 改為淺色模式
// ---------------------------------------------------------------------------
class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Color> _mockGallery = List.generate(20, (index) => Colors.primaries[index % Colors.primaries.length].withOpacity(0.5));
  int _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
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
      backgroundColor: Colors.white, // [修改] 背景改為白色
      appBar: AppBar(
        backgroundColor: Colors.white, // [修改] AppBar 改為白色
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black), // [修改] 圖示改為黑色
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("取消發布"))),
        ),
        title: const Text("最近項目", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)), // [修改] 文字改為黑色
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _goToEditor,
            child: const Text("下一步", style: TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold)),
          )
        ],
      ),
      // [RWD 優化] 使用 ResponsiveContainer
      body: ResponsiveContainer(
        child: Column(
          children: [
            // 1. 預覽區域
            Expanded(
              flex: 5,
              child: Container(
                width: double.infinity,
                color: Colors.grey[100], // [修改] 預覽底色改為淺灰
                child: _selectedIndex != -1 
                  ? Container(color: _mockGallery[_selectedIndex], child: const Center(child: Text("預覽圖片", style: TextStyle(color: Colors.white))))
                  : const Center(child: Icon(Icons.camera_alt, color: Colors.grey, size: 64)),
              ),
            ),
            
            // 2. 底部功能區
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  // 工具列 (最近項目)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: Colors.white, // [修改]
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("最近項目", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)), // [修改]
                        IconButton(icon: const Icon(Icons.camera_alt_outlined, color: Colors.black), onPressed: (){}), // [修改]
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
                    color: Colors.white, // [修改]
                    height: 50,
                    child: TabBar(
                      controller: _tabController,
                      indicatorColor: Colors.black, // [修改] 指示器改為黑色 (更簡約)
                      indicatorSize: TabBarIndicatorSize.label,
                      labelColor: Colors.black, // [修改] 選中文字黑色
                      unselectedLabelColor: Colors.grey,
                      tabs: const [Tab(text: "圖片"), Tab(text: "視頻"), Tab(text: "文字")],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 第二階段：美化與編輯 (Photo Editor) - 改為淺色模式
// ---------------------------------------------------------------------------
class PhotoEditorScreen extends StatelessWidget {
  final Color imageColor;

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
      backgroundColor: Colors.white, // [修改]
      appBar: AppBar(
        backgroundColor: Colors.white, // [修改]
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black), // [修改]
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
      // [RWD 優化] 使用 ResponsiveContainer
      body: ResponsiveContainer(
        child: Column(
          children: [
            // 圖片編輯區
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: imageColor,
                  borderRadius: BorderRadius.circular(12),
                  // [視覺優化] 加一點陰影讓圖片浮起來
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))
                  ],
                ),
                child: Stack(
                  children: [
                    const Center(child: Text("圖片編輯預覽", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, shadows: [Shadow(blurRadius: 4, color: Colors.black54)]))),
                    Positioned(
                      top: 100, left: 100,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.black.withOpacity(0.7), borderRadius: BorderRadius.circular(4)),
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
            
            // 底部工具列 (配樂、貼紙、文字...)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              color: Colors.white, // [修改]
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
        Icon(icon, color: Colors.black87), // [修改] 改為深色
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.black87, fontSize: 11)), // [修改] 改為深色
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 第三階段：發布設定 (Publish Form) - 保持淺色模式
// ---------------------------------------------------------------------------
class PostPublishScreen extends StatefulWidget {
  final Color imageColor;
  const PostPublishScreen({super.key, required this.imageColor});

  @override
  State<PostPublishScreen> createState() => _PostPublishScreenState();
}

class _PostPublishScreenState extends State<PostPublishScreen> {
  Future<bool> _onWillPop() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text("保存草稿？"),
        content: const Text("如果不保存，剛才的編輯將會丟失"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), 
            child: const Text("不保存", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
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
          title: const Text("發布筆記", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("發布成功！")));
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF1744), 
                  shape: const StadiumBorder(),
                  elevation: 0,
                ),
                child: const Text("發布", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
        // [RWD 優化] 使用 ResponsiveContainer
        body: ResponsiveContainer(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100, height: 100,
                      decoration: BoxDecoration(
                        color: widget.imageColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(child: Icon(Icons.image, color: Colors.white)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        maxLength: 20,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          hintText: "填寫標題 會吸引更多人喔～",
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),
                          border: InputBorder.none,
                          counterText: "", 
                        ),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 30),
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
                const _OptionTile(icon: Icons.public, title: "權限設定", value: "公開"),
                const _OptionTile(icon: Icons.download, title: "保存到相冊", value: "", isSwitch: true),
                const _OptionTile(icon: Icons.settings, title: "高級設定", value: ""),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ActionChip({required this.icon, required this.label});

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