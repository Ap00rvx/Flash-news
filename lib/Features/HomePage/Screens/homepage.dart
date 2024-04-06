import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_project/Features/Boomarks/Providers/Bookmarkprovider.dart';
import 'package:news_project/Features/Chat/Service/chatservice.dart';
// import 'package:news_project/Features/HomePage/Provider/env_news.dart';
import 'package:news_project/Features/HomePage/Provider/news_provider.dart';
import 'package:news_project/Features/HomePage/Screens/Astrolist.dart';
// import 'package:news_project/Features/News%20Page/Screens/AstroScreen.dart';
import 'package:news_project/Features/News%20Page/Screens/new_screen.dart';
import 'package:news_project/Features/HomePage/Screens/list_env.dart';
import 'package:news_project/Features/HomePage/Screens/listview.dart';
import 'package:news_project/common/snackbar.dart';
// import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:news_project/model/CommentsModel.dart';
import 'package:news_project/model/news_model.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> with SingleTickerProviderStateMixin {
  List<Widget> _list = [
    const ListView22(),
    const ListView33(),
    const ListView4()
  ];
  final _scroll = ItemScrollController();
  void scrollToIndex(int index) {
    print('calld');
    _scroll.scrollTo(index: index, duration: const Duration(seconds: 2));
  }

  TextEditingController _controller = TextEditingController();
  late final AnimationController _cont;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser;
  bool _value = false;
  bool theme = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cont = AnimationController(vsync: this);
    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) => scrollToIndex(0));
  }

  final _comment = TextEditingController();
  String cate = 'India';
  final List<String> _cate = [
    'India',
    'Entertainment',
    'Health',
    'Sports',
    'Business',
    'Science & Tech'
  ];
  final List items = ['Political', 'Environment', 'Astrology'];
  void addComment(int? id, String comments, user) async {
    _comment.clear();
    getComments(id).then((value) {
      print(value);
      value.add({'comment': comments, 'user': user});
      print(value);
      CommentsModel commentsModel = CommentsModel(comments: value);
      FirebaseFirestore.instance
          .collection('Comments')
          .doc(id.toString())
          .set({'comments': value}).then(
              (value) => Snack().show("Comment added successfully", context));

      print('done');
    });
  }

  void addCommentifNULL(int? id, String comments, user) async {
    _comment.clear();
    FirebaseFirestore.instance.collection('Comments').doc(id.toString()).set({
      'comments': [
        {'comment': comments, 'user': user}
      ]
    }).then((value) => Snack().show("Comment added successfully", context));
  }

  Future<bool> doesDocumentExist(int? id) async {
    String collectionName = 'Comments';
    String documentId = id.toString();

    DocumentReference documentReference =
        FirebaseFirestore.instance.collection(collectionName).doc(documentId);

    DocumentSnapshot documentSnapshot = await documentReference.get();

    return documentSnapshot.exists;
  }

  Future<List<dynamic>> getComments(int? id) async {
    final collection = await FirebaseFirestore.instance
        .collection('Comments')
        .doc(id.toString())
        .get();
    final commentlist = collection.get('comments') as List<dynamic>;

    return commentlist;
  }

  void _showSheet(h, w, int? id) {
    doesDocumentExist(id).then((value) {
      setState(() {});
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
                    Expanded(
                      child: Container(
                          // color: Colors.red,
                          height: h * 0.42,
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: value.length,
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Colors.grey.shade200),
                                    borderRadius: BorderRadius.circular(5)),
                                width: w,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: w * 0.05, vertical: h * 0.02),
                                  child: Container(
                                    width: w,
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: RichText(
                                        text: TextSpan(
                                            text:
                                                value[index]['user'].toString(),
                                            children: [
                                              TextSpan(
                                                text: "  " +
                                                    value[index]['comment'],
                                                style: GoogleFonts.ubuntu(
                                                    color: Colors.grey.shade700,
                                                    fontSize: 15),
                                              )
                                            ],
                                            style: GoogleFonts.ubuntu(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )),
                    ),
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
                                  _comment.clear;
                                  setState(() {});
                                },
                                icon: const Icon(Icons.send_rounded))),
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
                  Expanded(
                    child: Container(
                        // color: Colors.red,
                        height: h * 0.42,
                        child: Center(
                          child: Text(
                            "No Comments yet",
                            style: GoogleFonts.ubuntu(fontSize: 20),
                          ),
                        )),
                  ),
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
                                  user!.email!.split('@')[0].toString()),
                              icon: const Icon(Icons.send_rounded))),
                    ),
                  )
                ]));
          },
        );
      }
    });
  }

  Widget _usersList(context, selected, news) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('Users').snapshots(),
      builder: (context, snapshot) {
        final w = MediaQuery.sizeOf(context).width;
        final h = MediaQuery.sizeOf(context).height;
        final userEmail = FirebaseAuth.instance.currentUser!.email;
        if (snapshot.hasError) {
          return const Text('error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SpinKitWanderingCubes(
              color: Colors.orange,
              size: 40,
            ),
          );
        } else {
          return Container(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25)),
                    color: Colors.white,
                  ),
                  height: 20,
                ),
                Container(
                  color: Colors.white,
                  child: Divider(
                    color: Colors.black,
                    // color: Colors.orange.shade100,
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    width: w,
                    child: ListView(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        children: snapshot.data!.docs.map((e) {
                          final data = e.data()! as Map<String, dynamic>;
                          if (data['email'] != userEmail) {
                            return Container(
                              height: 115,
                              width: w,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 40,
                                            backgroundImage:
                                                NetworkImage(data['imgUrl']),
                                          ),
                                          SizedBox(
                                            width: w * 0.05,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                width: w * 0.6,
                                                child: Text(
                                                  data['email']
                                                      .toString()
                                                      .split('@')[0],
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.ubuntu(
                                                      fontSize: 20),
                                                ),
                                              ),
                                              SizedBox(
                                                height: w * 0.02,
                                              ),
                                              Container(
                                                width: w * 0.6,
                                                child: Text(
                                                  data['bio'],
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.ubuntu(
                                                      color:
                                                          Colors.grey.shade500,
                                                      fontSize: 10),
                                                ),
                                              ),
                                            ],
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              print('send');
                                              ChatService().sendMessage(
                                                  data['uid'], '', '', news);
                                              Navigator.pop(context);
                                              Snack().show(
                                                  'Sent to ' +
                                                      data['email']
                                                          .toString()
                                                          .split('@')[0],
                                                  context);
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                child: Text(
                                                  'Send',
                                                  style: GoogleFonts.ubuntu(
                                                      color: Colors.blue),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Divider()
                                ],
                              ),
                            );
                          } else {
                            return Container();
                          }
                        }).toList()),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;

    return Consumer<NewsProvider>(builder: (context, value, child) {
      final res = value.news;
      print(res.news);
      return value.news.news == null
          ? Scaffold(
              //     floatingActionButtonLocation:
              //         FloatingActionButtonLocation.centerTop,
              //     floatingActionButton: FloatingActionButton(
              //       onPressed: () => scrollToIndex(2),
              //       child: Icon(Icons.add),
              //       foregroundColor: Colors.orange.shade200,
              //     ),
              appBar: AppBar(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                title: Text(
                  'Flash News',
                  style: GoogleFonts.ubuntu(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 25),
                ),
                centerTitle: true,
              ),
              body: Center(
                  child: SpinKitWanderingCubes(
                color: Colors.black,
                size: 60,
              )),
            )
          : Scaffold(
              appBar: AppBar(
                scrolledUnderElevation: 10,
                backgroundColor: Colors.white,
                foregroundColor: Colors.grey.shade600,
                elevation: 1,
                centerTitle: true,
                title: Text(
                  'Flash News',
                  style: GoogleFonts.ubuntu(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        child: TextField(
                          controller: _controller,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              fillColor: Colors.black,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(34)),
                              prefixIcon: const Icon(Icons.search_sharp),
                              iconColor: Colors.black,
                              prefixIconColor: Colors.black,
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(34)),
                              hintText: 'Find Interesting News',
                              suffixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.orange,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(34))),
                                      onPressed: () {
                                        // ignore: prefer_is_empty
                                        if (_controller.text
                                                .toString()
                                                .trim()
                                                .length !=
                                            0) {
                                          value.bookmark.clear();
                                          value.get_news(
                                              _controller.text.toString());
                                        } else {
                                          return null;
                                        }
                                      },
                                      child: Text(
                                        'Search',
                                        style: GoogleFonts.poppins(
                                            color: Colors.white),
                                      )))),
                        ),
                      ),
                    ),
                    Container(
                      height: h * 0.06,
                      width: w,
                      // color: Colors.red,
                      child: DefaultTabController(
                        length: _cate.length,
                        child: Column(
                          children: [
                            Container(
                              height: h * 0.05,
                              child: TabBar(
                                isScrollable: true,
                                onTap: (value445) {
                                  cate = _cate[value445];
                                  value.get_news(_cate[value445]);

                                  setState(() {});
                                },
                                labelColor: Colors.orange,
                                unselectedLabelColor: Colors.black,
                                indicatorColor: Colors.orange,
                                tabs: _cate.map((category) {
                                  return Tab(
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      margin: const EdgeInsets.all(5),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        category.toString(),
                                        style: GoogleFonts.ubuntu(
                                          fontSize: h * 0.018,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (value.isLoading)
                      SizedBox(
                        height: h * 0.5,
                        child: const Center(
                          child: SpinKitWanderingCubes(color: Colors.black),
                        ),
                      )
                    else
                      SizedBox(
                          height: h * 0.5,
                          child: CarouselSlider(
                            options: CarouselOptions(
                                autoPlayInterval: const Duration(seconds: 5),
                                height: h * 0.5,
                                viewportFraction: 1,
                                autoPlay: true),
                            items: List.generate(res.number!, (index) {
                              final _news = res.news![index];
                              return InkWell(
                                onTap: () {
                                  Get.to(NewsScreen(index: index));
                                },
                                child: Container(
                                  child: Column(
                                    children: [
                                      Stack(
                                        alignment: Alignment.topCenter,
                                        children: [
                                          Container(
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                            ),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            width: w * 1,
                                            height: h * 0.5,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(23),
                                              child: Container(
                                                constraints:
                                                    const BoxConstraints
                                                        .expand(),
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) =>
                                                      const SpinKitWanderingCubes(
                                                    color: Colors.black,
                                                    size: 40,
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          const Icon(
                                                    Icons
                                                        .error_outline_outlined,
                                                    color: Colors.orange,
                                                  ),
                                                  imageUrl:
                                                      _news.image.toString(),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: h * 0.01,
                                            child: Container(
                                              height: h * 0.22,
                                              width: w * 0.9,
                                              child: Opacity(
                                                opacity: 0.8,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      boxShadow: const [
                                                        BoxShadow(
                                                            blurRadius: 4,
                                                            offset:
                                                                Offset(0, 0.5))
                                                      ],
                                                      color:
                                                          Colors.grey.shade300,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              23)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20.0),
                                                    child: Center(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Text(
                                                            _news.title
                                                                .toString(),
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .fade,
                                                            style: GoogleFonts
                                                                .poppins(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20,
                                                            ),
                                                          ),
                                                          Consumer<
                                                              BookmarkProvider>(
                                                            builder: (context,
                                                                value2, child) {
                                                              return Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceAround,
                                                                children: [
                                                                  IconButton(
                                                                    onPressed: () =>
                                                                        _showSheet(
                                                                            h,
                                                                            w,
                                                                            _news.id),
                                                                    icon: const Icon(
                                                                        Icons
                                                                            .comment),
                                                                  ),
                                                                  IconButton(
                                                                    onPressed:
                                                                        () {
                                                                      value2.add_bookmark(
                                                                          _news);
                                                                      setState(
                                                                          () {});
                                                                    },
                                                                    icon: value2
                                                                            .box
                                                                            .containsKey(_news
                                                                                .id)
                                                                        ? const Icon(
                                                                            Icons.bookmark_added_rounded,
                                                                            color:
                                                                                Colors.orange,
                                                                            size:
                                                                                25,
                                                                          )
                                                                        : const Icon(
                                                                            Icons.bookmark_add_outlined),
                                                                  ),
                                                                  IconButton(
                                                                    onPressed:
                                                                        () {
                                                                      print(
                                                                          'bottomSheet Called ');
                                                                      showModalBottomSheet(
                                                                          backgroundColor: Colors
                                                                              .transparent,
                                                                          isDismissible:
                                                                              true,
                                                                          enableDrag:
                                                                              true,
                                                                          showDragHandle:
                                                                              true,
                                                                          isScrollControlled:
                                                                              true,
                                                                          barrierColor: const Color
                                                                              .fromARGB(
                                                                              255,
                                                                              52,
                                                                              51,
                                                                              51),
                                                                          barrierLabel:
                                                                              'Share',
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (context) {
                                                                            bool
                                                                                se =
                                                                                true;
                                                                            return Container(
                                                                                height: h * 0.8,
                                                                                child: _usersList(context, se, _news));
                                                                          });
                                                                    },
                                                                    icon: Image
                                                                        .asset(
                                                                      'assets/share-post.png',
                                                                      height:
                                                                          25,
                                                                    ),
                                                                    iconSize:
                                                                        10,
                                                                  )
                                                                ],
                                                              );
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          )),
                    SizedBox(
                      height: h * 0.02,
                    ),
                    Container(
                      color: const Color.fromARGB(255, 255, 253, 253),
                      // height: h * 2,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: w * 0.02),
                                child: Text(
                                  'Recommendations ',
                                  style: GoogleFonts.poppins(
                                      color: Colors.black, fontSize: 20),
                                ),
                              ),
                              // GestureDetector(
                              //     onTap: () {
                              //       showDialog(
                              //         context: context,
                              //         builder: (context) {
                              //           return Container(
                              //             height: 100,
                              //             width: 100,
                              //             child: AlertDialog(
                              //               // shadowColor: Colors.orange,
                              //               // backgroundColor: Colors.grey,
                              //               content: Container(
                              //                 width: w * 0.5,
                              //                 height: h * 0.17,
                              //                 color: Colors.white,
                              //                 child: Center(
                              //                   child: ListView.builder(
                              //                     physics:
                              //                         NeverScrollableScrollPhysics(),
                              //                     itemBuilder:
                              //                         (context, index) {
                              //                       return GestureDetector(
                              //                           onTap: () {
                              //                             print(index);
                              //                             Navigator.pop(
                              //                                 context);
                              //                             scrollToIndex(index);
                              //                           },
                              //                           child: Container(
                              //                             margin:
                              //                                 EdgeInsets.all(5),
                              //                             padding:
                              //                                 EdgeInsets.all(6),
                              //                             alignment:
                              //                                 Alignment.center,
                              //                             decoration: BoxDecoration(
                              //                                 borderRadius:
                              //                                     BorderRadius
                              //                                         .circular(
                              //                                             16),
                              //                                 border: Border.all(
                              //                                     color: Colors
                              //                                         .orange
                              //                                         .shade200)),
                              //                             child: Text(
                              //                               items[index],
                              //                               style: GoogleFonts
                              //                                   .ubuntu(
                              //                                 fontSize: 20,
                              //                               ),
                              //                             ),
                              //                           ));
                              //                     },
                              //                     itemCount: 3,
                              //                   ),
                              //                 ),
                              //               ),
                              //             ),
                              //           );
                              //         },
                              //       );
                              //     },
                              //     child: Container(
                              //       margin: EdgeInsets.only(right: w * 0.02),
                              //       child: Padding(
                              //         padding: EdgeInsets.symmetric(
                              //             horizontal: w * 0.03),
                              //         child: Text(
                              //           'See All',
                              //           style: GoogleFonts.poppins(
                              //               color: Colors.blue, fontSize: 15),
                              //         ),
                              //       ),
                              //     ))
                            ],
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(
                    //   height: h * 0.02,
                    // ),
                    // Container(
                    //   color: Colors.red,
                    //   height: h * 0.02,
                    // ),
                    _list[0],
                    _list[1],
                    _list[2],
                  ],
                ),
              ),
            );
    });
  }
}
