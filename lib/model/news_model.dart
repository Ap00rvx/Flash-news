

import 'package:news_project/Features/Hive/hive_adp.dart';

class NewsModel {
  int? offset;
  int? number;
  int? available;
  List<News>? news;

  NewsModel({this.offset, this.number, this.available, this.news});

  NewsModel.fromJson(Map<String, dynamic> json) {
    offset = json['offset'];
    number = json['number'];
    available = json['available'];
    if (json['news'] != null) {
      news = <News>[];
      json['news'].forEach((v) {
        news!.add(new News.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['offset'] = this.offset;
    data['number'] = this.number;
    data['available'] = this.available;
    if (this.news != null) {
      data['news'] = this.news!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class News {
  int? id;
  String? title;
  String? text;
  String? url;
  String? image;
  String? publishDate;
  String? author;
  String? language;
  String? sourceCountry;
  double? sentiment;

  News(
      {this.id,
      this.title,
      this.text,
      this.url,
      this.image,
      this.publishDate,
      this.author,
      this.language,
      this.sourceCountry,
      this.sentiment});

  News.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    text = json['text'];
    url = json['url'];
    image = json['image'];
    publishDate = json['publish_date'];
    author = json['author'];
    language = json['language'];
    sourceCountry = json['source_country'];
    sentiment = json['sentiment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['text'] = this.text;
    data['url'] = this.url;
    data['image'] = this.image;
    data['publish_date'] = this.publishDate;
    data['author'] = this.author;
    data['language'] = this.language;
    data['source_country'] = this.sourceCountry;
    data['sentiment'] = this.sentiment;
    return data;
  }
  factory News.fromNewsAdp(NewsModelAdp news) {
    return News(
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
}


