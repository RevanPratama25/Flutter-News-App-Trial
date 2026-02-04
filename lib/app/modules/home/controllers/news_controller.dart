import 'dart:async';
import 'package:get/get.dart';
import '../../../data/models/article_model.dart';
import '../../../data/services/news_service.dart'; // Import service 

class NewsController extends GetxController {
  // 1. Inisialisasi Service
  final NewsService _newsService = Get.put(NewsService());
  
  var articles = <Article>[].obs; // Gunakan tipe data spesifik <Article>
  var isLoading = true.obs;
  
  // Backup data untuk fitur pencarian
  var allArticles = <Article>[].obs; 

  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    fetchArticles();
  }

  void fetchArticles() async {
    try {
      isLoading(true);
      
      // Simulasi delay (opsional, bisa dihapus agar lebih cepat)
      await Future.delayed(const Duration(seconds: 1));

      // 2. Panggil Service untuk ambil data
      // Controller tidak perlu tahu cara connect ke API, cuma terima beres
      var result = await _newsService.fetchArticles();
      
      if (result.isNotEmpty) {
        articles.assignAll(result);
        allArticles.assignAll(result); // Simpan ke backup juga
      }
      
    } catch (e) {
      print("Error di Controller: $e");
      Get.snackbar("Error", "Gagal memuat berita. Cek koneksi internet.");
    } finally {
      isLoading(false);
    }
  }

  void filterNews(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isEmpty) {
        articles.assignAll(allArticles);
      } else {
        var filtered = allArticles.where((article) {
          // Null check sederhana
          return (article.title ?? '').toLowerCase().contains(query.toLowerCase());
        }).toList();
        articles.assignAll(filtered);
      }
    });
  }
}