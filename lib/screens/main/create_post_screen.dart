// lib/screens/main/create_post_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // [新增]
import '../../widgets/responsive_container.dart';
import '../../providers/post_provider.dart'; // [新增]
import '../../models/post.dart'; // [新增]

// ---------------------------------------------------------------------------
// 第一階段：素材選擇 (Media Picker) - 保持不變
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context), // 修正：取消應該返回上一頁
        ),
        title: const Text("最近項目", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _goToEditor,
            child: const Text("下一步", style: TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: ResponsiveContainer(
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                width: double.infinity,
                color: Colors.grey[100],
                child: _selectedIndex != -1 
                  ? Container(color: _mockGallery[_selectedIndex], child: const Center(child: Text("預覽圖片", style: TextStyle(color: Colors.white))))
                  : const Center(child: Icon(Icons.camera_alt, color: Colors.grey, size: 64)),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("最近項目", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                        IconButton(icon: const Icon(Icons.camera_alt_outlined, color: Colors.black), onPressed: (){}),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(2),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 2, mainAxisSpacing: 2),
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
                  Container(
                    color: Colors.white,
                    height: 50,
                    child: TabBar(
                      controller: _tabController,
                      indicatorColor: Colors.black,
                      indicatorSize: TabBarIndicatorSize.label,
                      labelColor: Colors.black,
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
// 第二階段：美化與編輯 (Photo Editor) - 保持不變
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
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
      body: ResponsiveContainer(
        child: Column(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: imageColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Stack(
                  children: [
                    const Center(child: Text("圖片編輯預覽", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, shadows: [Shadow(blurRadius: 4, color: Colors.black54)]))),
                    Positioned(
                      top: 100, left: 100,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.black.withOpacity(0.7), borderRadius: BorderRadius.circular(4)),
                        child: const Row(children: [Icon(Icons.location_on, color: Colors.white, size: 12), SizedBox(width: 4), Text("標籤: OOTD", style: TextStyle(color: Colors.white, fontSize: 12))]),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              color: Colors.white,
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
        Icon(icon, color: Colors.black87),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.black87, fontSize: 11)),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 第三階段：發布設定 (Publish Form) - 新增 Provider 連接
// ---------------------------------------------------------------------------
class PostPublishScreen extends StatefulWidget {
  final Color imageColor;
  const PostPublishScreen({super.key, required this.imageColor});

  @override
  State<PostPublishScreen> createState() => _PostPublishScreenState();
}

class _PostPublishScreenState extends State<PostPublishScreen> {
  // [新增] 文字控制器，以便獲取用戶輸入
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  @override
  void dispose() {
    _contentController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  // [新增] 提交發布方法
  void _submitPost() {
    if (_titleController.text.isEmpty && _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("請至少輸入標題或內容")));
      return;
    }

    // 1. 建立新貼文物件
    final newPost = Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // 產生唯一 ID
      authorName: '我 (Me)', // 這裡暫時寫死，之後接 AuthProvider
      authorAvatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100', // 預設頭像
      verified: false,
      // 這裡先只存標題+內容，實際專案可能分開存
      content: "${_titleController.text}\n${_contentController.text}", 
      // 由於我們選的是顏色，這裡用假圖代替，實際專案會上傳圖片取得 URL
      image: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=800', 
      likes: 0,
      comments: 0,
      timestamp: '剛剛',
      isMerchant: false,
    );

    // 2. 呼叫 Provider 新增貼文
    // listen: false 是因為我們只是呼叫方法，不需要監聽變化重繪此頁面
    Provider.of<PostProvider>(context, listen: false).addPost(newPost);

    // 3. 提示並返回首頁
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("發布成功！")));
    
    // popUntil 回到最上層 (首頁)
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("保存草稿？"),
        content: const Text("如果不保存，剛才的編輯將會丟失"),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text("不保存", style: TextStyle(color: Colors.grey))),
          TextButton(onPressed: () { Navigator.of(context).pop(true); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("已保存至草稿箱"))); }, child: const Text("保存", style: TextStyle(color: Colors.redAccent))),
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
              if (await _onWillPop() && context.mounted) Navigator.pop(context);
            },
          ),
          title: const Text("發布筆記", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: ElevatedButton(
                onPressed: _submitPost, // [修改] 綁定提交方法
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF1744), shape: const StadiumBorder(), elevation: 0),
                child: const Text("發布", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
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
                      decoration: BoxDecoration(color: widget.imageColor, borderRadius: BorderRadius.circular(8)),
                      child: const Center(child: Icon(Icons.image, color: Colors.white)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _titleController, // [新增]
                        maxLength: 20, maxLines: 3,
                        decoration: const InputDecoration(
                          hintText: "填寫標題 會吸引更多人喔～",
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),
                          border: InputBorder.none, counterText: "",
                        ),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 30),
                TextField(
                  controller: _contentController, // [新增]
                  maxLength: 1000, maxLines: 8,
                  decoration: const InputDecoration(
                    hintText: "添加正文\n#話題 #穿搭",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 10),
                // (其餘 Chip 代碼保持不變...)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const _ActionChip(icon: Icons.grid_3x3, label: "話題"),
                      const SizedBox(width: 8),
                      const _ActionChip(icon: Icons.alternate_email, label: "用戶"),
                      const SizedBox(width: 8),
                      const _ActionChip(icon: Icons.location_on_outlined, label: "添加地點"),
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
      child: Row(children: [Icon(icon, size: 16, color: Colors.black87), const SizedBox(width: 4), Text(label, style: const TextStyle(fontSize: 13, color: Colors.black87))]),
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
            const SizedBox(height: 24, width: 40, child: Switch(value: true, onChanged: null, activeColor: Colors.redAccent))
          else 
            Row(children: [Text(value, style: const TextStyle(fontSize: 13, color: Colors.grey)), const Icon(Icons.chevron_right, color: Colors.grey, size: 20)]),
        ],
      ),
    );
  }
}