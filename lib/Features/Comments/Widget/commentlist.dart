import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:news_project/model/CommentsModel.dart';

class CommentList extends StatefulWidget {
  const CommentList({super.key, required this.identity});
  final identity;
  @override
  State<CommentList> createState() => _CommentListState();
}

int list_size = 0;
var listtt = [];
Future<List<Comment>> getComments(int? id) async {
  final collection = await FirebaseFirestore.instance
      .collection('Comments')
      .doc(id.toString())
      .get();
  final commentlist = collection.get('comments') as List<Comment>;
  list_size = commentlist.length;
  listtt = commentlist;
  return commentlist;
}

void addComment(int? id, String comments, user) async {
  final collection = await FirebaseFirestore.instance
      .collection('Comments')
      .doc(id.toString())
      .get();

  final commentlist = collection.get('comments') as List<Map<String, dynamic>>;
  CommentsModel commentsModel =
      CommentsModel(comments: [Comment(user: user, comment: 'aspurva')]);
  commentlist.add(commentsModel.toJson());
  Map<String, dynamic> map = {'id': id.toString(), 'comments': commentlist};
  try {
    await FirebaseFirestore.instance
        .collection('Comments')
        .doc(id.toString())
        .set(map);
  } catch (e) {
    print('$e');
  }
}

class _CommentListState extends State<CommentList> {
  @override
  void initState() {
    super.initState();
    getComments(widget.identity);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final list = getComments(widget.identity);
    return ListView.builder(
      itemCount: list_size,
      itemBuilder: (context, index) {
        return Text(listtt[index].toString());
      },
    );
  }
}
