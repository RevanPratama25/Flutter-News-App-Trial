import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/news_controller.dart';

class NewsView extends StatelessWidget {
  // 1. Panggil Controller yang sudah kita buat tadi
  final NewsController controller = Get.put(NewsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter News GetX'),
        backgroundColor: Colors.redAccent,
      ),
      // 2. Gunakan Obx untuk mendeteksi perubahan data
      body: Obx(() {
        // Jika sedang loading, tampilkan lingkaran putar-putar
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Jika data kosong
        if (controller.articles.isEmpty) {
          return const Center(child: Text("Tidak ada berita ditemukan"));
        }

        // 3. Tampilkan daftar berita dengan ListView
        return ListView.builder(
          itemCount: controller.articles.length,
          itemBuilder: (context, index) {
            var article = controller.articles[index];
            
            return Card(
              margin: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Menampilkan Gambar (jika ada URL-nya)
                  if (article.urlToImage != null)
                    Image.network(
                      article.urlToImage!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                      // Handle jika gambar error/tidak bisa dimuat
                      errorBuilder: (context, error, stackTrace) {
                        return const SizedBox(
                          height: 200, 
                          child: Center(child: Icon(Icons.broken_image))
                        );
                      },
                    ),
                  
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.title ?? 'Tanpa Judul',
                          style: const TextStyle(
                            fontSize: 18, 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          article.description ?? 'Tidak ada deskripsi',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}