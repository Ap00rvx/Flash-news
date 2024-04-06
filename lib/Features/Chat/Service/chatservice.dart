import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_project/model/MessageModel.dart';
import 'package:news_project/Model/news_model.dart';

class ChatService extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _store = FirebaseFirestore.instance;
  String current = '';
  Future<void> clearChat(String uid, String uid2) async {
    List<String> ids = [uid, uid2];
    ids.sort();
    String roomId = ids.join("-");
    try {
      await _store
          .collection('ChatRoom')
          .doc(roomId)
          .collection('Messages')
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });
    } catch (e) {
      print('Error deleting messages: $e');
    }
  }

  void sendMessage(String Remail, String message, String imgUrl, news) async {
    if (news != '') {
      news = news as News;
      final currentuserId = _auth.currentUser!.uid;
      final now = DateTime.now();
      final currentUserEmail = _auth.currentUser!.email.toString();
      final time = Timestamp.now();
      final now11 = DateFormat("dd-MM-yyyy h-mma").format(now);
      print(now11);
      Message newMessage = Message(
          receiverId: Remail,
          message: message,
          senderEmail: currentUserEmail,
          senderld: currentuserId,
          timestamp: time,
          date: now11.toString(),
          imgUrl: imgUrl,
          id: news.id.toString(),
          title: news.title.toString(),
          text: news.text.toString(),
          image: news.image.toString(),
          url: news.url.toString());

      List<String> ids = [currentuserId, Remail];
      ids.sort();
      String room = ids.join("-");
      await _store
          .collection('ChatRoom')
          .doc(room)
          .collection('Messages')
          .add(newMessage.toMAP());
    } else {
      final currentuserId = _auth.currentUser!.uid;
      final now = DateTime.now();
      final currentUserEmail = _auth.currentUser!.email.toString();
      final time = Timestamp.now();
      final now11 = DateFormat("dd-MM-yyyy h-mma").format(now);
      print(now11);
      Message newMessage = Message(
          receiverId: Remail,
          message: message,
          senderEmail: currentUserEmail,
          senderld: currentuserId,
          timestamp: time,
          date: now11.toString(),
          imgUrl: imgUrl,
          id: 'null',
          title: 'null',
          text: 'null',
          image: 'null',
          url: 'null');

      List<String> ids = [currentuserId, Remail];
      ids.sort();
      String room = ids.join("-");
      await _store
          .collection('ChatRoom')
          .doc(room)
          .collection('Messages')
          .add(newMessage.toMAP());
    }
  }

  void delete(String uid, String uid2) async {
    List<String> ids = [uid, uid2];
    ids.sort();
    String room = ids.join("-");
    final doc = await _store
        .collection('ChatRoom')
        .doc(room)
        .collection('Messages')
        .get();
  }

  Stream<QuerySnapshot> getMessages(String uid2, String uid1) {
    print(uid1 + "           " + uid2);
    List<String> ids = [uid1, uid2];
    ids.sort();
    String room = ids.join("-");
    return _store
        .collection('ChatRoom')
        .doc(room)
        .collection('Messages')
        .orderBy('timeStamp', descending: true)
        // .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
