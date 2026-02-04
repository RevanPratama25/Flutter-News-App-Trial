import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart'; // Import package shimmer
import '../controllers/news_controller.dart';
import 'article_detail_view.dart';

class NewsView extends StatefulWidget {
  const NewsView({super.key});

  @override
  State<NewsView> createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
  final NewsController controller = Get.put(NewsController());
  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 31, 93, 184),
        // ... (Kode AppBar Search sama seperti sebelumnya) ...
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: isSearching
              ? Container(
                  key: const ValueKey('searchBar'),
                  height: 45,
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: searchController,
                    autofocus: true,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      hintText: "Search tech news...",
                      hintStyle: const TextStyle(color: Colors.white60),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white70),
                        onPressed: () {
                          searchController.clear();
                          controller.filterNews("");
                        },
                      ),
                    ),
                    onChanged: (value) => controller.filterNews(value),
                  ),
                )
              : const Text(
                  'News',
                  key: ValueKey('title'),
                  style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2),
                ),
        ),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) controller.filterNews("");
              });
            },
          )
        ],
      ),
      body: Obx(() {
        // --- MODIFIKASI: Ganti CircularProgressIndicator dengan Shimmer ---
        if (controller.isLoading.value) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 6, // Tampilkan 6 dummy item
            itemBuilder: (context, index) => _buildShimmerLoading(),
          );
        }

        if (controller.articles.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: () async => controller.fetchArticles(), // Pastikan nama method sesuai di controller
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.articles.length,
            itemBuilder: (context, index) {
              var article = controller.articles[index];
              return _buildModernCard(article);
            },
          ),
        );
      }),
    );
  }

  // --- WIDGET SHIMMER (Loading Skeleton) ---
  Widget _buildShimmerLoading() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dummy Image
            Container(
              height: 200,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dummy Metadata
                  Container(width: 80, height: 12, color: Colors.white),
                  const SizedBox(height: 10),
                  // Dummy Title (2 baris)
                  Container(width: double.infinity, height: 16, color: Colors.white),
                  const SizedBox(height: 8),
                  Container(width: 200, height: 16, color: Colors.white),
                  const SizedBox(height: 10),
                  // Dummy Description
                  Container(width: double.infinity, height: 12, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ... (Gunakan method _buildModernCard, _buildEmptyState, _buildPlaceholder yang lama di sini) ...
  // Pastikan menyalin method-method tersebut dari kode sebelumnya agar tidak error.
  
   Widget _buildModernCard(dynamic article) {
    // ... Copy paste dari kode sebelumnya ...
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: () => Get.to(() => ArticleDetailView(article: article)),
        // ... dst
        child: Ink(
            // ... dst
            // Isi card UI yang sudah dibuat sebelumnya
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]
            ),
            child: Column(
                // ... isi konten gambar dan teks
                children: [
                    ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        child: article.urlToImage != null 
                            ? Image.network(article.urlToImage!, height: 200, width: double.infinity, fit: BoxFit.cover) 
                            : Container(height: 200, color: Colors.grey[200])
                    ),
                    Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Text(article.title ?? '', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                SizedBox(height: 8),
                                Text(article.description ?? '', maxLines: 2, overflow: TextOverflow.ellipsis),
                            ]
                        )
                    )
                ]
            )
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
     return const Center(child: Text("Tidak ada berita"));
  }
}