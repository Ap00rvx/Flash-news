import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_project/Features/LoginPage/Screens/startpage.dart';
import 'package:news_project/common/snackbar.dart';
import 'package:news_project/model/UserModel.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key, required this.usermodel});
  final UserModel usermodel;
  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final _bio = TextEditingController();
  final _insta = TextEditingController();
  final _linked = TextEditingController();
  void showupdateopt() {
    Get.defaultDialog(
        title: "Update User Info",
        content: Container(
          child: Column(children: [
            TextField(
              maxLines: 5,
              controller: _bio,
              decoration: InputDecoration(
                  labelText: "Update Bio",
                  labelStyle:
                      GoogleFonts.ubuntu(color: Colors.black, fontSize: 20),
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(),
                  disabledBorder: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder()),
            ),
            const SizedBox(
              height: 10,
            ),
            // TextField(
            //     controller: email,
            //     decoration: InputDecoration(labelText: "Email")),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: 100,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(23))),
                  onPressed: () {
                    update(_bio.text.toString(), _linked.text, _insta.text);
                  },
                  child: const Text("Save")),
            )
          ]),
        ));
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  void showAlertBox() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'LOGOUT',
            style:
                GoogleFonts.ubuntu(fontSize: 25, fontWeight: FontWeight.w500),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                child: Text(
                  "No",
                  style: GoogleFonts.ubuntu(color: Colors.blue),
                ),
                onTap: () => Navigator.pop(context),
              ),
              GestureDetector(
                child: Text(
                  "Yes",
                  style: GoogleFonts.ubuntu(color: Colors.blue),
                ),
                onTap: () async {
                  await signOut().whenComplete(() {
                    Navigator.pop(context);

                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const StartPage()));
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().disconnect();

    // : await FirebaseAuth.instance.signOut();
    print('sign out');
  }

  void update(String bio, String link, String insta) async {
    final currentUser22 = FirebaseAuth.instance.currentUser;
    if (link.isEmpty && insta.isEmpty) {
      final DocumentReference documentRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser22!.email!.split('@')[0].toString());

      // Update specific fields in the document

      try {
        biocontroller.clear();
        await documentRef.update({
          'bio': bio,
        }).whenComplete(() => Navigator.pop(context));
        print('Document successfully updated');
      } catch (e) {
        print('Error updating document: $e');
      }
    } else {
      final DocumentReference documentRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser22!.email!.split('@')[0].toString());

      // Update specific fields in the document

      try {
        biocontroller.clear();
        await documentRef.update({
          'bio': bio,
          'instagram': insta,
          'linkedin': link
        }).whenComplete(() => Navigator.pop(context));
        print('Document successfully updated');
      } catch (e) {
        print('Error updating document: $e');
      }
    }
  }

  void updateUrl(String url) async {
    final currentUser22 = FirebaseAuth.instance.currentUser;

    final DocumentReference documentRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser22!.email!.split('@')[0].toString());
    showDialog(
        context: context,
        builder: (context) {
          return const SpinKitWanderingCubes(
            color: Colors.black,
            size: 50,
          );
        });

    // Update specific fields in the document
    try {
      biocontroller.clear();
      await documentRef.update({
        'imgUrl': url,
      }).whenComplete(() => Navigator.pop(context));
      print('Document successfully updated');
    } catch (e) {
      print('Error updating document: $e');
    }
  }

  Future<String> uploadFile(File file, String name, context) async {
    final h = MediaQuery.sizeOf(context).height;
    final w = MediaQuery.sizeOf(context).width;
    print('upload file called');
    String url = '';

    bool isload = true;
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
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
      cur_url = value;
      url = value.toString();
      updateUrl(value);
      setState(() {});

      Navigator.pop(context);
      print(value);

      // imgUrl = '';
    });
    return url;
  }

  void imagePick() async {
    XFile? image;
    var link = '';
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

  String cur_url = '';
  final biocontroller = TextEditingController();
  void showUpdateProfile() {
    showDialog(
        context: context,
        builder: (context) {
          final h = MediaQuery.of(context).size.height;
          final w = MediaQuery.of(context).size.width;
          return SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: Text(
                  'EDIT PROFILE',
                  style: GoogleFonts.ubuntu(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      biocontroller.clear();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.red,
                    )),
              ),
              body: Container(
                color: Colors.orange.shade100,
                width: MediaQuery.sizeOf(context).width * 1,
                // height: 500,
                height: MediaQuery.of(context).size.height,

                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    // mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const SizedBox(
                        height: 35,
                      ),
                      CircleAvatar(
                        backgroundImage:
                            NetworkImage(cur_url == '' ? user.imgUrl : cur_url),
                        radius: 70,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          imagePick();
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.orange.shade200,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Change Photo',
                              style: GoogleFonts.ubuntu(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        constraints: BoxConstraints.loose(Size(w, h * 0.65)),
                        // margin: const EdgeInsets.only(top: 5),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                        ),
                        child: Card(
                          child: Column(
                            // direction: Axis.vertical,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    Text(
                                      'Bio',
                                      style: GoogleFonts.ubuntu(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: TextField(
                                  controller: biocontroller,
                                  decoration: InputDecoration(
                                    enabledBorder: const OutlineInputBorder(),
                                    focusedBorder: const OutlineInputBorder(),
                                    hintText: user.bio,
                                    hintStyle: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    Text(
                                      'Update your instagram url',
                                      style: GoogleFonts.ubuntu(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: TextField(
                                  controller: _insta,
                                  decoration: InputDecoration(
                                    enabledBorder: const OutlineInputBorder(),
                                    focusedBorder: const OutlineInputBorder(),
                                    hintText: 'Instagram Handle',
                                    hintStyle: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    Text(
                                      'update your LinkedIn url',
                                      style: GoogleFonts.ubuntu(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: TextField(
                                  controller: _linked,
                                  decoration: InputDecoration(
                                    enabledBorder: const OutlineInputBorder(),
                                    focusedBorder: const OutlineInputBorder(),
                                    hintText: 'LinkedIn',
                                    hintStyle: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                height: 100,
                                child: GestureDetector(
                                  onTap: () => _auth
                                      .sendPasswordResetEmail(email: user.email)
                                      .whenComplete(() => Snack().show(
                                          'Password reset link sent to ${user.email}',
                                          context)),
                                  child: Text(
                                    'Get Password Reset link',
                                    style: GoogleFonts.ubuntu(
                                        fontSize: 15, color: Colors.grey),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  UserModel user = UserModel(
      bio: '',
      email: '',
      username: '',
      uid: '',
      imgUrl: '',
      instagram: '',
      linkedin: '');

  final currentUser = FirebaseAuth.instance.currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final usercollection = FirebaseFirestore.instance.collection('Users');
  // List drop = ['Logout'];
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;
    final userd = widget.usermodel;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey.shade100,
          foregroundColor: Colors.black,
          title: Text(
            'PROFILE',
            style:
                GoogleFonts.ubuntu(fontWeight: FontWeight.bold, fontSize: 25),
          ),

          centerTitle: true,
          // elevation:0,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(currentUser!.email!.split('@')[0])
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userdata = UserModel.fromJson(
                  snapshot.data!.data() as Map<String, dynamic>);
              user = UserModel.fromJson(
                  snapshot.data!.data() as Map<String, dynamic>);

              return Column(
                children: [
                  Expanded(
                    child: Container(
                      // ignore: sort_child_properties_last
                      // margin: EdgeInsets.only(top: 20),

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(),
                        image: DecorationImage(
                            image: NetworkImage(userd.imgUrl.toString()),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  Container(
                    height: h * 0.4,
                    width: w,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.only(),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 5,
                            spreadRadius: 2,
                          )
                        ]),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 2),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                    color: Colors.grey.shade600)
                              ]),
                          width: w * 0.3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  height: 50,
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Connect',
                                    style: GoogleFonts.ubuntu(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700),
                                  )),
                              Divider(),
                              GestureDetector(
                                onTap: () {
                                  print('instagram');
                                  if (userdata.instagram == '') {
                                    Snack().show(
                                        "Seems like User haven't provided Instagram Link",
                                        context);
                                  } else {
                                    Uri uri = Uri.parse(
                                        'https://www.' + userdata.instagram);
                                    print(userdata.instagram);
                                    _launchInBrowser(uri);
                                  }
                                },
                                child: Container(
                                    width: w * 0.25,
                                    height: w * 0.2,
                                    child: SvgPicture.network(
                                        'https://upload.wikimedia.org/wikipedia/commons/e/e7/Instagram_logo_2016.svg')),
                              ),
                              SizedBox(
                                height: h * 0.05,
                              ),
                              GestureDetector(
                                onTap: () {
                                  print('linkedin');
                                  if (userdata.linkedin == '') {
                                    Snack().show(
                                        "Seems like User haven't provided LinkedIn Link",
                                        context);
                                  } else {
                                    Uri uri = Uri.parse(
                                        'https://www.' + userdata.linkedin);
                                    print(uri);
                                    _launchInBrowser(uri);
                                  }
                                },
                                child: Container(
                                    width: w * 0.2,
                                    height: w * 0.2,
                                    child: SvgPicture.network(
                                        'https://upload.wikimedia.org/wikipedia/commons/8/81/LinkedIn_icon.svg')),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userd.email.split('@')[0].toString(),
                                style: GoogleFonts.ubuntu(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: h * 0.03,
                              ),
                              Text(userd.email..toString(),
                                  style: GoogleFonts.ubuntu(
                                      color: Colors.grey.shade700)),
                              Text(userd.bio,
                                  style: GoogleFonts.ubuntu(
                                      fontSize: 12,
                                      color: Colors.grey.shade500))
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
            } else {
              return SpinKitFoldingCube(
                color: Colors.black12,
                size: 50,
              );
            }
          },
        ));
  }
}
