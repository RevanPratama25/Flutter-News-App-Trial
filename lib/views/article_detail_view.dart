import 'package:flutter/material.dart';
import '../models/article_model.dart';

class ArticleDetailView extends StatelessWidget {
  final Article article;

  // Kita mewajibkan pengiriman data 'article' saat halaman ini dipanggil
  const ArticleDetailView({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Content'),
        backgroundColor: const Color.fromARGB(255, 0, 17, 255),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Gambar Utama
            if (article.urlToImage != null)
              Image.network(
                article.urlToImage!,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox(height: 200, child: Icon(Icons.broken_image)),
              ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. Judul Berita
                  Text(
                    article.title ?? 'Tanpa Judul',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 3. Penulis & Tanggal
                  Row(
                    children: [
                      const Icon(Icons.person, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          article.author ?? 'Penulis Tidak Diketahui',
                          style: const TextStyle(color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        // Mengambil 10 karakter pertama saja (YYYY-MM-DD)
                        article.publishedAt != null && article.publishedAt!.length >= 10
                            ? article.publishedAt!.substring(0, 10)
                            : '',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const Divider(height: 30),

                  // 4. Deskripsi & Konten
                  Text(
                    article.description ?? '',
                    style: const TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    article.content ?? 'Tidak ada konten tambahan.',
                    style: const TextStyle(fontSize: 16, height: 1.5),
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