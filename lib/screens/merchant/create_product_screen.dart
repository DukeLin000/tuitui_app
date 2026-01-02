// lib/screens/merchant/create_product_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 用於限制價格只能輸入數字
import '../../widgets/responsive_container.dart'; 

// ---------------------------------------------------------------------------
// 第一階段：商品圖片選擇 (Product Media Picker)
// 邏輯與 CreatePostScreen 相同，複用 UI 讓體驗一致
// ---------------------------------------------------------------------------
class CreateProductScreen extends StatefulWidget {
  const CreateProductScreen({super.key});

  @override
  State<CreateProductScreen> createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // 模擬相簿資料
  final List<Color> _mockGallery = List.generate(20, (index) => Colors.primaries[index % Colors.primaries.length].withOpacity(0.5));
  int _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // 商品通常只有圖片或視頻
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _goToEditor() {
    if (_selectedIndex == -1) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("請先選擇一張商品主圖")));
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        // 跳轉到商品圖片編輯器
        builder: (context) => ProductMediaEditorScreen(imageColor: _mockGallery[_selectedIndex]),
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
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("選擇商品圖片", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _goToEditor,
            child: const Text("下一步", style: TextStyle(color: Colors.purple, fontSize: 16, fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: ResponsiveContainer(
        child: Column(
          children: [
            // 預覽區
            Expanded(
              flex: 5,
              child: Container(
                width: double.infinity,
                color: Colors.grey[100],
                child: _selectedIndex != -1 
                  ? Container(color: _mockGallery[_selectedIndex], child: const Center(child: Text("商品主圖預覽", style: TextStyle(color: Colors.white))))
                  : const Center(child: Icon(Icons.add_photo_alternate, color: Colors.grey, size: 64)),
              ),
            ),
            // 相簿網格
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
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, crossAxisSpacing: 2, mainAxisSpacing: 2,
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
// 第二階段：商品圖片美化 (Product Media Editor)
// ---------------------------------------------------------------------------
class ProductMediaEditorScreen extends StatelessWidget {
  final Color imageColor;
  const ProductMediaEditorScreen({super.key, required this.imageColor});

  void _goToPublish(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        // [關鍵差異] 這裡跳轉到 ProductPublishScreen (商品資訊填寫頁)
        builder: (context) => ProductPublishScreen(imageColor: imageColor),
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
              backgroundColor: Colors.purple,
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
                ),
                child: const Center(child: Text("圖片美化/濾鏡", style: TextStyle(color: Colors.white, fontSize: 20))),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              color: Colors.white,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                   _EditorTool(icon: Icons.auto_fix_high, label: "智慧修圖"),
                   _EditorTool(icon: Icons.filter_vintage, label: "濾鏡"),
                   _EditorTool(icon: Icons.crop, label: "裁切"),
                   _EditorTool(icon: Icons.sell, label: "標籤"),
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
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [Icon(icon, color: Colors.black87), const SizedBox(height: 4), Text(label, style: const TextStyle(fontSize: 11))],
  );
}

// ---------------------------------------------------------------------------
// 第三階段：商品資訊填寫 (Product Publish Form) - [全新設計]
// ---------------------------------------------------------------------------
class ProductPublishScreen extends StatefulWidget {
  final Color imageColor;
  const ProductPublishScreen({super.key, required this.imageColor});

  @override
  State<ProductPublishScreen> createState() => _ProductPublishScreenState();
}

class _ProductPublishScreenState extends State<ProductPublishScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // 表單資料
  String _title = "";
  String _price = "";
  String _stock = "1";
  String _description = "";

  void _submitProduct() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      // 這裡執行實際的上架 API 邏輯
      // print("上架商品: $_title, 價格: $_price, 庫存: $_stock");

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("商品上架成功！")));
      // 回到商家儀表板或首頁
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text("填寫商品資訊", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: ElevatedButton(
              onPressed: _submitProduct,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                shape: const StadiumBorder(),
                elevation: 0,
              ),
              child: const Text("上架", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
      body: ResponsiveContainer(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 1. 商品圖片預覽與標題
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
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: "商品名稱 (例如：韓系針織毛衣)",
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      validator: (value) => value!.isEmpty ? "請輸入商品名稱" : null,
                      onSaved: (value) => _title = value!,
                    ),
                  ),
                ],
              ),
              const Divider(height: 32),

              // 2. 價格與庫存 (使用 Row 並排)
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: "價格 (NT\$)",
                        prefixIcon: Icon(Icons.attach_money),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly], // 只能輸入數字
                      validator: (value) => value!.isEmpty ? "請輸入價格" : null,
                      onSaved: (value) => _price = value!,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      initialValue: "1",
                      decoration: const InputDecoration(
                        labelText: "庫存數量",
                        prefixIcon: Icon(Icons.inventory_2_outlined),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onSaved: (value) => _stock = value!,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 3. 商品詳情描述
              const Text("商品詳情", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "描述商品的細節、材質、尺寸測量方式... \n#韓系 #穿搭 #新品",
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                maxLines: 6,
                maxLength: 1000,
                onSaved: (value) => _description = value ?? "",
              ),
              
              const SizedBox(height: 20),

              // 4. 其他選項 (運送方式、分類) - 這裡做 UI 示意
              const _OptionTile(icon: Icons.local_shipping_outlined, title: "運送方式", value: "超商取貨, 宅配"),
              const _OptionTile(icon: Icons.category_outlined, title: "商品分類", value: "選擇分類"),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  const _OptionTile({required this.icon, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
      onTap: () {}, // 暫無功能
    );
  }
}