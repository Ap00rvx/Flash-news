import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_project/Features/HomePage/Provider/list_provider.dart';
import 'package:news_project/Features/News%20Page/Screens/LIST_news_screen.dart';
import 'package:provider/provider.dart';

class ListView22 extends StatefulWidget {
  const ListView22({super.key});

  @override
  State<ListView22> createState() => _ListView22State();
}

class _ListView22State extends State<ListView22> {
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ListProvider>(context, listen: false).get_list('political');
    });
    // _scroll.addListener(_scrollListener);
  }

  final _scroll = ScrollController();

  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;
    return Consumer<ListProvider>(builder: (context, value, child) {
      final res = value.news;

      return value.isLoading
          ? Center(
              child: Container(
              height: h * 0.14,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Getting Latest News',
                    style: GoogleFonts.ubuntu(),
                  ),
                  SizedBox(width: w * 0.04),
                  const SpinKitWanderingCubes(
                    color: Colors.black,
                    size: 20,
                  ),
                ],
              ),
            ))
          : Column(
              children: [
                Container(
                  child: Text(
                    'Politics',
                    style: GoogleFonts.kanit(
                        color: const Color.fromARGB(255, 45, 42, 42),
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),
                ),
                
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.02),
                  child: Container(
                    height: h * 0.18 * res.number!,
                    child: ListView.builder(
                        controller: _scroll,
                        scrollDirection: Axis.vertical,
                        itemCount: (res.number!),
                        physics: NeverScrollableScrollPhysics(),
                        // shrinkWrap: true,
                        itemBuilder: (cotext, index) {
                          final _news = res.news![index];

                          // _scrollListener();
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          NewsScreenofList(index: index)));
                            },
                            child: Center(
                              child: Card(
                                elevation: 10,
                                child: Column(
                                  children: [
                                    Container(
                                        height: h * 0.15,
                                        color: Colors.grey.shade200,
                                        margin: EdgeInsets.all(10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                                width: w * 0.5,
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.all(w * .05),
                                                  child: Text(
                                                    _news.title.toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 3,
                                                    style:
                                                        GoogleFonts.poppins(),
                                                  ),
                                                )),
                                            Container(
                                              height: h * 0.5,
                                              width: w * 0.25,
                                              child: CachedNetworkImage(
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) =>
                                                      const SpinKitFoldingCube(
                                                        color: Colors.orange,
                                                        size: 20,
                                                      ),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(
                                                        Icons
                                                            .error_outline_outlined,
                                                        color: Colors.orange,
                                                      ),
                                                  imageUrl:
                                                      _news.image.toString()),
                                            )
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              ],
            );
    });
  }
}
