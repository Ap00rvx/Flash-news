// To parse this JSON data, do
//
//     final commentsModel = commentsModelFromJson(jsonString);

import 'dart:convert';

CommentsModel commentsModelFromJson(String str) => CommentsModel.fromJson(json.decode(str));

String commentsModelToJson(CommentsModel data) => json.encode(data.toJson());

class CommentsModel {
  
    List<dynamic> comments;

    CommentsModel({
        
        required this.comments,
    });

    factory CommentsModel.fromJson(Map<String, dynamic> json) => CommentsModel(
      
        comments: List<Comment>.from(json["comments"].map((x) => Comment.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
      
        "comments": List<dynamic>.from(comments.map((x) => x.toJson())),
    };
}

class Comment {
    String user;
    String comment;

    Comment({
        required this.user,
        required this.comment,
    });

    factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        user: json["user"],
        comment: json["comment"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "comment": comment,
    };
}
