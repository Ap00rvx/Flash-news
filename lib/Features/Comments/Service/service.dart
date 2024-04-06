import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_project/common/snackbar.dart';
import 'package:news_project/model/CommentsModel.dart';

class CommentService {
  Future<List<Comment>> getComments(int? id) async {
    final collection = await FirebaseFirestore.instance
        .collection('Comments')
        .doc(id.toString())
        .get();
    final commentlist = collection.get('comments') as List<Comment>;
    // list_size = commentlist.length;
    // listtt = commentlist;
    return commentlist;
  }

  void addComment(int? id, String comments, user) async {
    final collection = await FirebaseFirestore.instance
        .collection('Comments')
        .doc(id.toString())
        .get();

    final commentlist =
        collection.get('comments') as List<Map<String, dynamic>>;
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

  final user = FirebaseAuth.instance.currentUser;

  final _comment = TextEditingController();
  void addCommentifNULL(int? id, String comments, user, context) async {
    FirebaseFirestore.instance.collection('Comments').doc(id.toString()).set({
      'comments': [
        {'comment': comments, 'user': user}
      ]
    }).then((value) => Snack().show("Comment added Successfully", context));
  }

  Future<bool> doesDocumentExist(int? id) async {
    String collectionName = 'Comments';
    String documentId = id.toString();

    DocumentReference documentReference =
        FirebaseFirestore.instance.collection(collectionName).doc(documentId);

    DocumentSnapshot documentSnapshot = await documentReference.get();

    return documentSnapshot.exists;
  }

  void showSheet(h, w, int? id, context) {
    doesDocumentExist(id).then((value) {
      print(value);
      if (value) {
        final collection =
            FirebaseFirestore.instance.collection('Comments').get();

        getComments(id).then((value) {
          showBottomSheet(
            elevation: 20,
            context: context,
            builder: (context) {
              print(value.length);
              return Container(
                height: h * 0.6,
                width: w,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: h * .01),
                      child: Container(
                        width: w * 0.08,
                        height: h * 0.008,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade500,
                            borderRadius: BorderRadius.circular(23)),
                      ),
                    ),
                    Text(
                      'Comments',
                      style: GoogleFonts.ubuntu(fontSize: h * 0.03),
                    ),
                    const Divider(
                      color: Colors.black,
                    ),
                    Container(
                        // color: Colors.red,
                        height: h * 0.42,
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: value.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Colors.grey.shade200),
                                    borderRadius: BorderRadius.circular(5)),
                                width: w,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: w * 0.05, vertical: h * 0.00),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            value[index].comment.toString(),
                                            style: GoogleFonts.ubuntu(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width: w,
                                        alignment: Alignment.centerLeft,
                                        child: Expanded(
                                          child: Text(
                                            value[index].comment.toString(),
                                            style: GoogleFonts.ubuntu(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )),
                    const Divider(
                      color: Colors.black,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.01),
                      child: TextField(
                        controller: _comment,
                        decoration: InputDecoration(
                            suffixIconColor: Colors.black,
                            hintText: 'Type your opinion',
                            focusColor: Colors.black,
                            hoverColor: Colors.black,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(23)),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  addComment(id, _comment.text,
                                      user!.email!.split('@')[0].toString());
                                },
                                icon: Icon(Icons.send_rounded))),
                      ),
                    )
                  ],
                ),
              );
            },
          );
        });
      } else {
        showBottomSheet(
          elevation: 20,
          context: context,
          builder: (context) {
            return Container(
                height: h * 0.6,
                width: w,
                child: Column(children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: h * .01),
                    child: Container(
                      width: w * 0.08,
                      height: h * 0.008,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade500,
                          borderRadius: BorderRadius.circular(23)),
                    ),
                  ),
                  Text(
                    'Comments',
                    style: GoogleFonts.ubuntu(fontSize: h * 0.03),
                  ),
                  const Divider(
                    color: Colors.black,
                  ),
                  Container(
                      // color: Colors.red,
                      height: h * 0.42,
                      child: Center(
                        child: Text(
                          "No Commets yet ",
                          style: GoogleFonts.ubuntu(fontSize: 20),
                        ),
                      )),
                  const Divider(
                    color: Colors.black,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.01),
                    child: TextField(
                      controller: _comment,
                      decoration: InputDecoration(
                          suffixIconColor: Colors.black,
                          hintText: 'Type your opinion',
                          focusColor: Colors.black,
                          hoverColor: Colors.black,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(23)),
                          suffixIcon: IconButton(
                              onPressed: () => addCommentifNULL(
                                  id,
                                  _comment.text,
                                  user!.email!.split('@')[0].toString(),
                                  context),
                              icon: Icon(Icons.send_rounded))),
                    ),
                  )
                ]));
          },
        );
      }
    });
  }
}
