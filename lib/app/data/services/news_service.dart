import 'package:get/get.dart';
import '../models/article_model.dart';
import '../constant.dart';

class NewsService extends GetConnect {
  // 1. Setup Base URL di onInit (Good Architecture)
  // Ini membuat kita tidak perlu mengetik base URL berulang kali
  // @override
  // void onInit()

  NewsService() {
    // Kode ini akan otomatis jalan saat NewsService() dipanggil di Controller
    httpClient.baseUrl = ApiConstant.baseUrl; 
    httpClient.timeout = const Duration(seconds: 10);
  } 
  Future<List<Article>> fetchArticles() async {
    try {
      // 2. Menggunakan Query Parameters (Map)
      // Ini jauh lebih rapi daripada menempel string manual (?apiKey=...)
      final response = await get(
        ApiConstant.everythingEndpoint,
        query: {'domains': 'wsj.com', 'apiKey': ApiConstant.apiKey},
      );

      // 3. Cek Error menggunakan status.hasError
      if (response.status.hasError) {
        print("Error Status: ${response.statusText}");
        return Future.error(response.statusText ?? "Terjadi kesalahan server");
      } else {
        // 4. Parsing Data
        // response.body di GetConnect SUDAH berbentuk JSON (Map/List)
        // Tidak perlu json.decode() lagi!
        final data = response.body;

        // --- TAMBAHKAN DEBUGGING INI ---
        print("Tipe Data Body: ${data.runtimeType}");
        print("Isi Data: $data");
        // -------------------------------

        if (data['status'] == 'ok') {
          var articlesJson = data['articles'] as List;
          return articlesJson
              .map((article) => Article.fromJson(article))
              .toList();
        } else {
          return [];
        }
      }
    } catch (e) {
      print("Terjadi Error pada Service: $e");
      rethrow;
    }
  }
}
