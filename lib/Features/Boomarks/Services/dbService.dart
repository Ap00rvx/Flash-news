import 'package:hive/hive.dart';
import 'package:news_project/Features/Hive/hive_adp.dart';

class DBService {
  var box = Hive.box<NewsModelAdp>('BookMark');

  List<NewsModelAdp> getlist() => box.values.toList();
  void addList(int? index, NewsModelAdp model) => box.put(index, model);
  // ignore: avoid_print
  void deletelist(int? index) => {print('deleted'), box.delete(index)};
}
