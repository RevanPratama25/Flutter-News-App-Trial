import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/article_model.dart';

class NewsController extends GetxController {
  var articles = <dynamic>[].obs;
  var isLoading = true.obs;

  Timer? _debounce;

  var allArticles = <dynamic>[].obs; // Backup data asli

  void fetchArticles() async {
    try {
      isLoading(true);
      await Future.delayed(const Duration(seconds: 1));
      String apiKey = '69754c2a9966467aa706346566824c19';

      // Menggunakan endpoint 'everything' dan domain 'wsj.com'
      var url = Uri.parse(
        'https://newsapi.org/v2/everything?domains=wsj.com&apiKey=$apiKey',
      );

      print("Mencoba mengambil data dari: $url"); // Log untuk debugging

      var response = await http.get(url);

      print("Status Code: ${response.statusCode}"); // Cek status server

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData['status'] == 'ok') {
          var articlesJson = jsonData['articles'] as List;
          articles.value = articlesJson
              .map((article) => Article.fromJson(article))
              .toList();
        }
      } else {
        // Jika error, kita print pesan errornya dari server
        print("Gagal mengambil data: ${response.body}");
      }
    } catch (e) {
      print("Terjadi Error: $e");
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchArticles();
  }

  void filterNews(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isEmpty) {
        articles.assignAll(allArticles);
      } else {
        var filtered = allArticles.where((article) {
          return article.title.toString().toLowerCase().contains(
            query.toLowerCase(),
          );
        }).toList();
        articles.assignAll(filtered);
      }
    });
  }
}
