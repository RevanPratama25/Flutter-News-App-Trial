import 'package:get/get.dart';
import 'package:news_app/app/modules/home/controllers/news_controller.dart';

import '../controllers/home_controller.dart';

class NewsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewsController>(
      () => NewsController(),
    );
  }
}
