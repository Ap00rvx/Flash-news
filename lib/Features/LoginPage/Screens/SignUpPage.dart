import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:news_project/Features/LoginPage/Screens/LoginPage.dart';
import 'package:news_project/Features/HomePage/Screens/homepage.dart';
import 'package:news_project/Features/HomePage/Screens/navbar.dart';
import 'package:news_project/Features/LoginPage/Screens/SignupAnimation.dart';
import 'package:news_project/Features/LoginPage/Screens/Thankyou.dart';
import 'package:news_project/common/firebaseErrorHandling.dart';
import 'package:news_project/common/snackbar.dart';
import 'package:news_project/model/UserModel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String imgUrl = '';
  bool _obs = true;
  bool _obs2 = true;
  final _email = TextEditingController();
  final black = Colors.black;
  final orange = const Color(0xFFFA800F);
  final _cpass = TextEditingController();
  final _name = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  void thankyou() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(title: Thankyou());
      },
    );

    // Close dialog after 4 seconds
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pop();
    });
  }

  Future<User?> _handleGoogleSignIn(UserModel usermodel) async {
    User? user;
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        // Sign in to Firebase with the Google credentials
        showDialog(
            context: context,
            builder: ((context) => SpinKitWanderingCubes(
                  color: Colors.black,
                  size: 50,
                )));
        final UserCredential authResult =
            await FirebaseAuth.instance.signInWithCredential(credential);
        user = authResult.user;
        print('User signed in with Google: ${user!.displayName}');
        Navigator.pop(context);
        try {
          await FirebaseFirestore.instance
              .collection("Users")
              .doc(user.email!.split('@')[0].toString())
              .set({
            "username": user.displayName,
            "uid": user.uid,
            "email": user.email,
            "bio": "",
            'imgUrl': user.photoURL.toString(),
            'instagram': '',
            'linkedin': ''
          });
        } catch (e) {
          print('$e');
        }
      }
      return user;
    } on FirebaseAuthException catch (e) {
      print(e);
      Snack()
          .show(ErrorHandling().getMessageFromErrorCode(e.toString()), context);
    } finally {}
  }

  // final _email = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Future<String> uploadFile(File file, String name) async {
    showDialog(
        context: context,
        builder: (context) {
          return SpinKitWanderingCubes(
            color: Colors.black,
            size: 50,
          );
        });
    print('upload file called');
    String url = '';
    String filename = name;
    final firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$filename');
    final upload = firebaseStorageRef.putFile(file);
    final task = await upload.whenComplete(() => null);
    task.ref.getDownloadURL().then((value) {
      Navigator.pop(context);
      url = value.toString();

      setState(() {
        imgUrl = url;
      });
      print(imgUrl);
    });
    return url;
  }

  Future<File> uploadImage() async {
    XFile? image;

    ImagePicker()
        .pickImage(
            source: ImageSource.gallery,
            maxHeight: 512,
            maxWidth: 512,
            imageQuality: 75)
        .then((value) {
      setState(() {
        uploadFile(File(value!.path), value.name);
        print('image pciked');
      });
    });
    return File(image!.path);
  }

  final _pass = TextEditingController();
  Future<User?> _registerWithEmailAndPassword(UserModel useree) async {
    showDialog(
        context: context,
        builder: ((context) => SpinKitWanderingCubes(
              color: Colors.black,
              size: 50,
            )));
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _email.text,
          password: _pass.text,
        );
        final result = _auth.currentUser;
        useree.uid = result!.uid;
        try {
          await FirebaseFirestore.instance
              .collection("Users")
              .doc(userCredential.user!.email!.split('@')[0].toString())
              .set(useree.toJson());
        } on FirebaseAuthException catch (e) {}

        User? user = userCredential.user;

        print(user!.toString());
        return user;
        // User account created successfully.
      } on FirebaseAuthException catch (e) {
        print(e);
        Snack().show(
            ErrorHandling().getMessageFromErrorCode(e.toString()), context);
      } finally {
        Navigator.pop(context);
        // thankyou();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;
    snackbar(String text) {
      Snack().show(text, context);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFA800F),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          height: h,
          width: w,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'assets/Android Large - 1 (1).png',
                  ),
                  fit: BoxFit.cover)),
          child: Container(
            child: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.all(w * 0.05),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: h * 0.2,
                        width: w,
                        child: SignUpAnimation(),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: Text(
                          'Create New Account',
                          style: GoogleFonts.ubuntu(
                              fontSize: 23,
                              color: Colors.orange,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: w * 0.3,
                      ),
                      GestureDetector(
                        onTap: () async {
                          await uploadImage();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 0.50), //(x,y)
                                  blurRadius: 6.0,
                                ),
                              ],
                              border: Border.all(color: Colors.grey.shade200)),
                          width: w * 0.9,
                          height: h * 0.07,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                  backgroundColor: Colors.grey.shade200,
                                  radius: 35,
                                  backgroundImage: imgUrl == ''
                                      ? null
                                      : NetworkImage(imgUrl),
                                  child: imgUrl == ''
                                      ? Icon(
                                          Icons.add_a_photo_outlined,
                                          color: Colors.black,
                                          size: 20,
                                        )
                                      : null),
                              SizedBox(
                                width: w * 0.1,
                              ),
                              Container(
                                child: Text(
                                  'Upload a Profile picture',
                                  style: GoogleFonts.ubuntu(color: black),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: h * 0.02,
                      ),
                      TextFormField(
                          validator: (text) {
                            if (text == null ||
                                text.isEmpty ||
                                !text.contains('@')) {
                              snackbar('Enter a Valid Email');
                              return '';
                            } else {
                              return null;
                            }
                          },
                          controller: _email,
                          onSaved: (text) {},
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            suffixIcon: const Icon(
                              Icons.email_outlined,
                              color: Colors.black,
                            ),
                            hintText: 'Email',
                            hintStyle: GoogleFonts.ubuntu(color: black),
                            labelStyle: GoogleFonts.ubuntu(
                              color: black,
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: black)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: black)),
                          ),
                          maxLines: 1),
                      SizedBox(
                        height: h * 0.02,
                      ),
                      TextFormField(
                          validator: (text) {
                            if (text == null ||
                                text.isEmpty ||
                                text.length <= 6) {
                              snackbar('Password must be more than 6 letters');
                              return '';
                            } else {
                              return null;
                            }
                          },
                          controller: _pass,
                          obscureText: _obs,
                          onSaved: (text) {},
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obs = !_obs;
                                });
                              },
                              icon: Icon(_obs
                                  ? Icons.remove_red_eye_outlined
                                  : Icons.remove_red_eye),
                              color: Colors.black,
                            ),
                            hintText: 'Create Password',
                            hintStyle: GoogleFonts.ubuntu(color: black),
                            labelStyle: GoogleFonts.ubuntu(
                              color: black,
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: black)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: black)),
                          ),
                          maxLines: 1),
                      SizedBox(
                        height: h * 0.02,
                      ),
                      TextFormField(
                          validator: (text) {
                            if (text == null ||
                                text.isEmpty ||
                                text.length <= 6) {
                              snackbar('Password must be more than 6 letters');
                              return '';
                            } else {
                              return null;
                            }
                          },
                          controller: _cpass,
                          obscureText: _obs2,
                          onSaved: (text) {},
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obs2 = !_obs2;
                                });
                              },
                              icon: Icon(_obs2
                                  ? Icons.remove_red_eye_outlined
                                  : Icons.remove_red_eye),
                              color: Colors.black,
                            ),
                            hintText: 'Confirm Password',
                            hintStyle: GoogleFonts.ubuntu(color: black),
                            labelStyle: GoogleFonts.ubuntu(
                              color: black,
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: black)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: black)),
                          ),
                          maxLines: 1),
                      SizedBox(
                        height: h * 0.01,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (imgUrl.isEmpty) {
                            Snack().show('Please, Upload an Image', context);
                          } else {
                            if (_cpass.text == _pass.text) {
                              var user = await _registerWithEmailAndPassword(
                                  UserModel(
                                      bio: 'null',
                                      email: _email.text,
                                      uid: '',
                                      username: _name.text,
                                      imgUrl: imgUrl,
                                      linkedin: '',
                                      instagram: ''));

                              await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(title: Thankyou());
                                  });

                              // Close dialog after 4 seconds

                              if (user != null) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RootPage()));
                              } else {}
                            } else {
                              snackbar("Password doesn't Match");
                            }
                          }
                        },
                        child: const Text('SIGN UP'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: orange,
                            elevation: 10,
                            minimumSize: Size(w * 0.4, h * 0.05),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24))),
                      ),
                      SizedBox(
                        height: h * 0.01,
                      ),
                      Row(children: <Widget>[
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "or",
                            style: GoogleFonts.ubuntu(color: Colors.grey),
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ]),
                      SizedBox(
                        height: h * 0.01,
                      ),
                      InkWell(
                          onTap: () async {
                            User? user;
                            await _handleGoogleSignIn(UserModel(
                                    bio: '',
                                    email: '',
                                    uid: '',
                                    username: _name.text,
                                    imgUrl: '',
                                    instagram: '',
                                    linkedin: ''))
                                .then((value) {
                              user = value;
                            });
                            await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(title: Thankyou());
                                });
                            if (user != null) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RootPage()));
                            } else {
                              print('error');
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0.0, 0.50), //(x,y)
                                    blurRadius: 6.0,
                                  ),
                                ],
                                border:
                                    Border.all(color: Colors.grey.shade200)),
                            width: w * 0.8,
                            height: h * 0.07,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'Continue with Google',
                                  style:
                                      GoogleFonts.ubuntu(fontSize: h * 0.015),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset('assets/pngegg.png'),
                                ),
                              ],
                            ),
                          )),
                      SizedBox(
                        height: h * 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
                            style: GoogleFonts.ubuntu(),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginPage()));
                              },
                              child: Text(
                                'Login here',
                                style: GoogleFonts.ubuntu(
                                    decoration: TextDecoration.underline),
                              ))
                        ],
                      )
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
