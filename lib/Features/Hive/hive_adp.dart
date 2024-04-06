import 'package:hive/hive.dart';
import 'package:news_project/Model/news_model.dart';

part 'hive_adp.g.dart';

@HiveType(typeId: 0)
class NewsModelAdp extends HiveObject {
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final String? title;
  @HiveField(2)
  final String? text;
  @HiveField(3)
  final String? url;
  @HiveField(4)
  final String? image;
  @HiveField(5)
  final String? publishDate;
  @HiveField(6)
  final String? author;
  @HiveField(7)
  final String? language;
  @HiveField(8)
  final String? sourceCountry;
  @HiveField(9)
  final double? sentiment;

  NewsModelAdp({
    this.id,
    this.title,
    this.text,
    this.url,
    this.image,
    this.publishDate,
    this.author,
    this.language,
    this.sourceCountry,
    this.sentiment,
  });
  factory NewsModelAdp.fromNews(News news) {
    return NewsModelAdp(
      id: news.id,
      title: news.title,
      text: news.text,
      url: news.url,
      image: news.image,
      publishDate: news.publishDate,
      author: news.author,
      language: news.language,
      sourceCountry: news.sourceCountry,
      sentiment: news.sentiment,
    );
  }
  factory NewsModelAdp.fromNewsModel(NewsModel news, index) {
    final newss = news.news![index];
    return NewsModelAdp(
      id : newss.id,
      title : newss.title,
      text : newss.text,
      url : newss.url,
      image : newss.image,
      publishDate : newss.publishDate,
      author : newss.author,
      language : newss.language,
      sourceCountry : newss.sourceCountry,
      sentiment : newss.sentiment,
      
    );
  }
}
