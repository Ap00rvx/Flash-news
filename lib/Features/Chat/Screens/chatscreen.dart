import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_project/Features/Chat/Screens/newsPage.dart';
import 'package:news_project/Features/Chat/Service/chatservice.dart';
import 'package:news_project/Features/Profile/userProfilePage.dart';
import 'package:news_project/model/UserModel.dart';
import 'package:news_project/model/news_model.dart';

class Chatscreen extends StatefulWidget {
  const Chatscreen(
      {super.key,
      required this.Remail,
      required this.Rid,
      required this.imgUrl,
      required this.senderUrl});
  final Remail;
  final senderUrl;
  final Rid;
  final imgUrl;
  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  bool isLoading = false;
  Future<String?> getImageUrlForUser() async {
    final em = FirebaseAuth.instance.currentUser!.email.toString();

    final userSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: em)
        .get();

    if (userSnapshot.docs.isNotEmpty) {
      final userData = userSnapshot.docs.first.data() as Map<String, dynamic>;

      final imageUrl = userData['imgUrl'] as String?;
      print(imageUrl);
      return imageUrl;
    } else {
      // Handle the case when the user's document is not found
      return null;
    }
  }

  News news = News();
  final _messageController = TextEditingController();
  final chatService = ChatService();
  final auth = FirebaseAuth.instance;
  void send(String imgUrl) {
    if (_messageController.text.isNotEmpty || imgUrl.isNotEmpty) {
      chatService.sendMessage(
        widget.Rid,
        _messageController.text.toString(),
        imgUrl,
        '',
      );
    }
    _messageController.clear();
  }

  Future<UserModel> toUserPofile() async {
    final em = widget.Remail.toString();

    final userSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: em)
        .get();
    if (userSnapshot.docs.isNotEmpty) {
      final userData = userSnapshot.docs.first.data() as Map<String, dynamic>;

      final imageUrl = userData['imgUrl'] as String?;
      return UserModel(
          bio: userData['bio'],
          email: userData['email'],
          username: userData['username'],
          uid: userData['uid'],
          imgUrl: imageUrl.toString(),
          instagram: userData['instagram'],
          linkedin: userData['linkedin']);
    }
    return UserModel(
        bio: 'bio',
        email: '',
        username: '',
        uid: '',
        imgUrl: '',
        linkedin: '',
        instagram: '');
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    toUserPofile().then((value) => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                UserProfilePage(usermodel: value))));
                  },
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Container(
                          child: Center(
                            child: CircleAvatar(
                              radius: 160,
                              backgroundImage: NetworkImage(widget.imgUrl),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  // onLongPressCancel: () => Navigator.pop(context),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(widget.imgUrl),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    // color: Colors.amber,
                    // alignment: Alignment.center,
                    margin: EdgeInsets.only(left: 90),
                    child: Text(
                      widget.Remail.toString().split('@')[0],
                      style: GoogleFonts.ubuntu(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 20,
            color: Colors.black,
          ),
          Expanded(
              child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              opacity: 0.3,
              image: AssetImage('assets/3731533_1971537.jpg'),
              fit: BoxFit.cover,
            )),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: builderMessage(),
            ),
          )),
          input(),
        ],
      ),
    );
  }

  Widget builderMessage() {
    return StreamBuilder(
      stream: chatService.getMessages(widget.Rid, auth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SpinKitWanderingCubes(
              color: Colors.orange,
              size: 35,
            ),
          );
        }
        // print('tolist');
        return ListView(
            reverse: true,
            physics: BouncingScrollPhysics(),
            children:
                snapshot.data!.docs.map((e) => messages(e, context)).toList());
      },
    );
  }

  var dt;
  Widget messages(DocumentSnapshot docsss, context) {
    final w = MediaQuery.sizeOf(context).width;
    // final h = MediaQuery.sizeOf(context).height;
    Map<String, dynamic> data = docsss.data() as Map<String, dynamic>;
    dt = data;
    // print(data['senderId']);
    var align = (data['senderId'] == auth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    // final kk = (data['senderId'] == auth.currentUser!.uid);
    // print(data['timeStamp'].toString());
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        alignment: align,
        child: Column(
          children: [
            // Container(
            //   alignment: align,
            //   child: Text(
            //     data['email'].toString(),
            //     style: GoogleFonts.ubuntu(color: Colors.black),
            //   ),
            // ),

            data['senderId'] == auth.currentUser!.uid
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          data['id'] == 'null'
                              ? data['imgUrl'] == ''
                                  ? Container(
                                      alignment: Alignment.center,
                                      width:
                                          data['message'].toString().length >=
                                                  25
                                              ? w * 0.7
                                              : null,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.orange.shade300),
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            topLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ),
                                          color: align == Alignment.centerLeft
                                              ? Colors.white
                                              : Colors.orange.shade100),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              data['message'],
                                              style: GoogleFonts.ubuntu(
                                                  fontSize: 20),
                                            ),
                                          ],
                                        ),
                                      ))
                                  : GestureDetector(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Center(
                                                child: Image.network(
                                                    data['imgUrl'].toString()),
                                              );
                                            });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.orange.shade50,
                                            border: Border.all(
                                                color: Colors.orange.shade50,
                                                width: 5)),
                                        height: 300,
                                        width: 300,
                                        child: Image.network(
                                          data['imgUrl'].toString(),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                              : GestureDetector(
                                  onTap: () {
                                    print('news');
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => NewsScreen1(
                                                id: data['id'],
                                                title: data['title'],
                                                text: data['text'],
                                                url: data['image'])));
                                  },
                                  child: Container(
                                    alignment: Alignment.bottomCenter,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: CachedNetworkImageProvider(
                                                data['image']),
                                            fit: BoxFit.cover),
                                        color: Colors.orange.shade50,
                                        border: Border.all(
                                            color: Colors.orange.shade50,
                                            width: 5)),
                                    height: 300,
                                    width: 300,
                                    child: Opacity(
                                      opacity: 0.8,
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 10),
                                        decoration: BoxDecoration(
                                            boxShadow: const [
                                              BoxShadow(
                                                  blurRadius: 4,
                                                  offset: Offset(0, 0.5))
                                            ],
                                            color: Colors.grey.shade300,
                                            borderRadius:
                                                BorderRadius.circular(23)),
                                        height: 100,
                                        width: 250,
                                        child: Column(
                                          children: [
                                            Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      15.0),
                                                  child: Text(
                                                    data['title'],
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.ubuntu(),
                                                  ),
                                                ),
                                                // SizedBox(height: 6),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          right: 8),
                                                      child: Text(
                                                        'Shared from News',
                                                        style:
                                                            GoogleFonts.ubuntu(
                                                                color: Colors
                                                                    .grey
                                                                    .shade400,
                                                                fontSize: 5),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.centerRight,

                                // color: Colors.amber,

                                // color: Colors.amber,
                                child: Text(
                                  data['date']
                                      .toString()
                                      .split(' ')[1]
                                      .toString()
                                      .replaceFirst('-', ':'),
                                  style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      color: Colors.grey.shade600),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 40, left: 5),
                        child: CircleAvatar(
                          radius: 12,
                          backgroundImage: NetworkImage(widget.senderUrl),
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 40, right: 5),
                        child: CircleAvatar(
                          radius: 12,
                          backgroundImage: NetworkImage(widget.imgUrl),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          data['id'] == 'null'
                              ? data['imgUrl'] == ''
                                  ? Container(
                                      width:
                                          data['message'].toString().length >=
                                                  25
                                              ? w * 0.7
                                              : null,
                                      alignment: Alignment.centerLeft,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey.shade300),
                                          borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                          ),
                                          color: align == Alignment.centerLeft
                                              ? Colors.grey.shade200
                                              : Colors.orange.shade200),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          data['message'],
                                          style:
                                              GoogleFonts.ubuntu(fontSize: 20),
                                        ),
                                      ))
                                  : GestureDetector(
                                      onTap: () {
                                        print('ontap');
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Center(
                                                child: Image.network(
                                                    data['imgUrl'].toString()),
                                              );
                                            });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            border: Border.all(
                                                color: Colors.grey.shade100,
                                                width: 5)),
                                        height: 300,
                                        width: 300,
                                        child: Image.network(
                                          data['imgUrl'].toString(),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                              : GestureDetector(
                                  onTap: () {
                                    print('news');
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => NewsScreen1(
                                                id: data['id'],
                                                title: data['title'],
                                                text: data['text'],
                                                url: data['image'])));
                                  },
                                  child: Container(
                                    alignment: Alignment.bottomCenter,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: CachedNetworkImageProvider(
                                                data['image']),
                                            fit: BoxFit.cover),
                                        color: Colors.grey.shade50,
                                        border: Border.all(
                                            color: Colors.grey.shade50,
                                            width: 5)),
                                    height: 300,
                                    width: 300,
                                    child: Opacity(
                                      opacity: 0.8,
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 10),
                                        decoration: BoxDecoration(
                                            boxShadow: const [
                                              BoxShadow(
                                                  blurRadius: 4,
                                                  offset: Offset(0, 0.5))
                                            ],
                                            color: Colors.grey.shade300,
                                            borderRadius:
                                                BorderRadius.circular(23)),
                                        height: 100,
                                        width: 250,
                                        child: Column(
                                          children: [
                                            Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      15.0),
                                                  child: Text(
                                                    data['title'],
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.ubuntu(),
                                                  ),
                                                ),
                                                // SizedBox(height: 6),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          right: 8),
                                                      child: Text(
                                                        'Shared from News',
                                                        style:
                                                            GoogleFonts.ubuntu(
                                                                color: Colors
                                                                    .grey
                                                                    .shade400,
                                                                fontSize: 5),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,

                                width: w * 0.7,
                                // color: Colors.amber,
                                child: Text(
                                  data['date']
                                      .toString()
                                      .split(' ')[1]
                                      .replaceFirst('-', ':')
                                      .toString(),
                                  style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      color: Colors.grey.shade600),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  // String imgUrl = '';
  Future<String> uploadFile(File file, String name, context) async {
    final h = MediaQuery.sizeOf(context).height;
    final w = MediaQuery.sizeOf(context).width;
    print('upload file called');
    String url = '';
    // bool isload = true;
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: SpinKitWanderingCubes(
              color: Colors.orange,
              size: 50,
            ),
          );
        });
    String filename = name;
    final firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$filename');
    final upload = firebaseStorageRef.putFile(file);
    final task = await upload.whenComplete(() => Navigator.pop(context));
    task.ref.getDownloadURL().then((value) {
      url = value.toString();

      showDialog(
        context: context,
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              title: Text(widget.Remail.toString().split('@')[0]),
              centerTitle: true,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.keyboard_return)),
            ),
            body: Container(
              width: w,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade200,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade200,
                          image: DecorationImage(
                              image: AssetImage('assets/3731533_1971537.jpg'),
                              fit: BoxFit.cover)),
                      child: Image.network(value, fit: BoxFit.cover)),
                  ElevatedButton(
                      onPressed: () {
                        send(value);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(w * 0.7, h * 0.05),
                          backgroundColor: Colors.orange.shade200,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      child: Text(
                        'Send',
                        style: GoogleFonts.ubuntu(
                            fontSize: 25, color: Colors.black),
                      ))
                ],
              ),
            ),
          );
        },
      );

      setState(() {});
      print(value);

      // imgUrl = '';
    });
    return url;
  }

  void imagePick() async {
    // XFile? image;
    // var link = '';
    await ImagePicker()
        .pickImage(
            source: ImageSource.gallery,
            maxHeight: 512,
            maxWidth: 512,
            imageQuality: 75)
        .then((value) {
      if (value != null) {
        setState(() {
          uploadFile(File(value.path), value.name, context);
        });
      } else {}
    });
  }

  Widget input() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: _messageController,
        textInputAction: TextInputAction.newline,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(23),
            ),
            prefixIcon: IconButton(
                onPressed: () => imagePick(),
                icon: Icon(Icons.add_photo_alternate_rounded)),
            prefixIconColor: Colors.black,
            suffixIconColor: Colors.black,
            hintText: 'Message',
            focusColor: Colors.orange,
            // hoverColor: Colors.black,

            border: OutlineInputBorder(borderRadius: BorderRadius.circular(23)),
            suffixIcon: IconButton(
                onPressed: () {
                  send('');
                },
                icon: Icon(Icons.send_rounded))),
      ),
    );
  }
}
