import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article_model.dart';
import '../constant.dart';

class NewsService {
  // Fungsi khusus untuk request ke internet
  Future<List<Article>> fetchArticles() async {
    try {
      // Menggunakan Constant agar rapi
      var url = Uri.parse(
        '${ApiConstant.baseUrl}${ApiConstant.everythingEndpoint}?domains=wsj.com&apiKey=${ApiConstant.apiKey}',
      );

      print("Fetching data from: $url");
      
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData['status'] == 'ok') {
          var articlesJson = jsonData['articles'] as List;
          // Parsing JSON ke List<Article> langsung di sini
          return articlesJson.map((article) => Article.fromJson(article)).toList();
        } else {
          // Bisa throw error atau return list kosong tergantung kebutuhan
          return [];
        }
      } else {
        print("Gagal mengambil data: ${response.body}");
        return []; // Return kosong jika gagal
      }
    } catch (e) {
      print("Terjadi Error pada Service: $e");
      rethrow; // Lempar error agar bisa ditangkap di Controller
    }
  }
}


