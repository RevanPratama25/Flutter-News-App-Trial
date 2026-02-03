import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/news_controller.dart';
import 'article_detail_view.dart';

class NewsView extends StatefulWidget {
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
        backgroundColor: const Color(0xFF0D47A1),
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: isSearching
              ? Container(
                  key: const ValueKey('searchBar'),
                  height: 45,
                  decoration: BoxDecoration(
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
                      // Icon Cancel di dalam TextField
                      suffixIcon: searchController.text.isNotEmpty 
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.cancel, color: Colors.white70, size: 20),
                                onPressed: () {
                                  searchController.clear();
                                  controller.filterNews("");
                                  setState(() {});
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.check_circle, color: Colors.greenAccent, size: 22),
                                onPressed: () {
                                  controller.filterNews(searchController.text);
                                  FocusScope.of(context).unfocus();
                                },
                              ),
                            ],
                          )
                        : null,
                    ),
                    onChanged: (value) {
                      controller.filterNews(value);
                      setState(() {}); // Untuk update icon suffix
                    },
                    onSubmitted: (value) => controller.filterNews(value),
                  ),
                )
              : const Text(
                  'TECH PULSE',
                  key: ValueKey('title'),
                  style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2),
                ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: Icon(isSearching ? Icons.close : Icons.search, size: 28),
              onPressed: () {
                setState(() {
                  isSearching = !isSearching;
                  if (!isSearching) {
                    searchController.clear();
                    controller.filterNews("");
                  }
                });
              },
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF0D47A1)));
        }

        return RefreshIndicator(
          onRefresh: () async => controller.fetchArticles(),
          child: controller.articles.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
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

  Widget _buildModernCard(dynamic article) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: () => Get.to(() => ArticleDetailView(article: article)),
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.blueGrey.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: article.urlToImage != null
                    ? Image.network(
                        article.urlToImage!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                      )
                    : _buildPlaceholder(),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 14, color: Colors.blueAccent),
                        const SizedBox(width: 5),
                        Text("Just Now", style: TextStyle(color: Colors.blueAccent[700], fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      article.title ?? 'Headline News',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, height: 1.3),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      article.description ?? 'No description available for this article.',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14, height: 1.5),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 100, color: Colors.blueGrey[100]),
          const Text("No matches found", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
          const Text("Try different keywords", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 200, width: double.infinity, color: Colors.blueGrey[50],
      child: const Icon(Icons.image_not_supported_outlined, color: Colors.blueGrey),
    );
  }
}