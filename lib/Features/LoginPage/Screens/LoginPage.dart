import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:news_project/Features/LoginPage/Screens/SignUpPage.dart';
// import 'package:news_project/Features/HomePage/Screens/homepage.dart';
import 'package:news_project/Features/HomePage/Screens/navbar.dart';
import 'package:news_project/Features/LoginPage/Screens/welcomeAnimation.dart';
import 'package:news_project/common/firebaseErrorHandling.dart';
import 'package:news_project/common/snackbar.dart';
import 'package:news_project/model/UserModel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obs = true;
  final _email = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final black = Colors.black;
  final orange = const Color(0xFFFA800F);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  final CollectionReference users =
      FirebaseFirestore.instance.collection('Users');

  Future<bool> checkIfDocumentExists(String id) async {
    DocumentSnapshot documentSnapshot = await users.doc(id).get();

    if (documentSnapshot.exists) {
      print('exists');

      return true;
    } else {
      print('Document does not exist.');
      return false;
    }
  }

  Future<User?> _handleGoogleSignIn() async {
    showDialog(
        context: context,
        builder: (context) => SpinKitWanderingCubes(
              color: Colors.black,
              size: 50,
            ));
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
        final UserCredential authResult =
            await FirebaseAuth.instance.signInWithCredential(credential);
        final User? user = authResult.user;
        UserModel userdata = UserModel(
            bio: '',
            email: user!.email.toString(),
            username: user.displayName.toString(),
            uid: user.uid,
            imgUrl: user.photoURL.toString(),
            linkedin: '',
            instagram: '');
        checkIfDocumentExists(user.email.toString().split('@')[0])
            .then((value) {
          if (value) {
            print('User already Exist');
          } else {
            print('NOT EXIST');
            FirebaseFirestore.instance
                .collection('Users')
                .doc(user.email.toString().split('@')[0])
                .set(userdata.toJson());
          }
        });
        //

        print('User signed in with Google: ${user.displayName}');
        return user;
      }
    } on FirebaseAuthException catch (error) {
      print(error.code);
      Snack().show("Something went wrong", context);
    } finally {
      Navigator.pop(context);
    }
    return null;
  }

  Future<User?> _signInWithEmailAndPassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        final UserCredential userCredential =
            await _auth.signInWithEmailAndPassword(
          email: _email.text,
          password: _pass.text,
        );
        final User? user = userCredential.user;
        print(user!.email.toString());
        return user;
      } catch (e) {
        print(e);
        Snack().show(
            ErrorHandling().getMessageFromErrorCode(e.toString()), context);
      }
    }
    return null;
  }

  // final _email = TextEditingController();
  final _pass = TextEditingController();

  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;
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
                    'assets/Android Large - 1.png',
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
                      SizedBox(
                        height: h * 0.05,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: h * 0.02),
                        child: Container(
                            height: h * 0.2, child: WelcomeAnimation()),
                      ),
                      Container(
                        child: Text(
                          'Welcome Back',
                          style: GoogleFonts.openSans(
                              fontSize: h * 0.04,
                              fontWeight: FontWeight.bold,
                              color: orange),
                        ),
                      ),
                      SizedBox(
                        height: h * 0.01,
                      ),
                      TextFormField(
                          validator: (text) {
                            if (text == null ||
                                text.isEmpty ||
                                text.contains('@') == false) {
                              Snack().show("Enter a Valid Email", context);
                              return 'Email is Not Valid ';
                            }
                            return null;
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
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(color: black)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
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
                              Snack().show(
                                  "Password must be more than 6 letters",
                                  context);
                              return 'Password Error';
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
                            hintText: 'Password',
                            hintStyle: GoogleFonts.ubuntu(color: black),
                            labelStyle: GoogleFonts.ubuntu(
                              color: black,
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(color: black)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(color: black)),
                          ),
                          maxLines: 1),
                      Row(
                        children: [
                          TextButton(
                              onPressed: () async {
                                if (_email.text.isNotEmpty ||
                                    _email.text.contains('@')) {
                                  await _auth
                                      .sendPasswordResetEmail(
                                          email: _email.text)
                                      .whenComplete(() => Snack().show(
                                          "Password reset link sent to ${_email.text}",
                                          context));
                                } else {
                                  Snack().show("Enter a Valid Email", context);
                                }
                              },
                              child: Text(
                                'Forgot Password?',
                                style: GoogleFonts.ubuntu(),
                              ))
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          var user = await _signInWithEmailAndPassword();
                          if (user != null) {
                            // ignore: use_build_context_synchronously
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const RootPage()));
                          }
                        },
                        child: const Text('LOGIN'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: orange,
                            elevation: 10,
                            minimumSize: Size(w * 0.4, h * 0.05),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24))),
                      ),
                      SizedBox(
                        height: h * 0.02,
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
                        height: h * 0.02,
                      ),
                      InkWell(
                          onTap: () async {
                            var user = await _handleGoogleSignIn();

                            if (user != null) {
                              // ignore: use_build_context_synchronously
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const RootPage()));
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
                                  padding: const EdgeInsets.all(10.0),
                                  child: Image.asset('assets/pngegg.png'),
                                ),
                              ],
                            ),
                          )),
                      SizedBox(
                        height: h * 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'New User?',
                            style: GoogleFonts.ubuntu(),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SignUpPage()));
                              },
                              child: Text(
                                'Create new account',
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
