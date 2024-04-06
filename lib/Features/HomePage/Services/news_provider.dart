import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:news_project/Features/Hive/hive_adp.dart';
import 'package:news_project/Model/news_model.dart';
import 'package:news_project/Features/Boomarks/Services/dbService.dart';
import 'package:news_project/Features/News%20Page/Services/news_service.dart';

class NewsProvider extends ChangeNotifier {
  final _service = NewsService();
  bool isLoading = false;
  NewsModel _news = NewsModel();
  NewsModel _k = NewsModel();
  NewsModel get news => _news;
  Map<String, int> fav = {};
  Map<String, int> get _fav => fav;
  Map<News, bool> bookmark = {};
  Map<News, bool> get _bookmark => bookmark;
  // List<NewsModel> get _bookmark => bookmark ;

  final DBService _dbService = DBService();
  DBService get dbService => _dbService;
  late List<NewsModelAdp> _hiveList = _dbService.getlist();
  List<NewsModelAdp> get hivelist => _hiveList;
  int count = 0;
  List<News> list = [];
  List<News> get _list => list;

  int get _count => _count;
  void add_list(int? ind, News news) {
    final newsAdp = NewsModelAdp.fromNews(news);
    if (hivelist.contains(newsAdp)) {
      print(('yessss'));
      dbService.deletelist(ind);
      notifyListeners();
    } else {
      print('No');
      dbService.addList(ind, newsAdp);
      notifyListeners();
    }

    print('hivelist: ${hivelist.length}');
    print('list: $list');
    notifyListeners();
  }

  Future<NewsModel> get_news(String text) async {
    isLoading = true;
    notifyListeners();

    try {
      _news = await _service.fetch_news(text);
      return _news;
    } catch (e) {
      print('error');
      return _k;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
