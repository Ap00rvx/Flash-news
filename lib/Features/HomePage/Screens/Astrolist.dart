import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:news_project/Features/HomePage/Provider/env_news.dart';
import 'package:news_project/Features/News%20Page/Screens/AstroScreen.dart';
import 'package:news_project/Features/News%20Page/Screens/Enviroment_newsScreen.dart';
import 'package:provider/provider.dart';

class ListView4 extends StatefulWidget {
  const ListView4({Key? key}) : super(key: key);

  @override
  State<ListView4> createState() => _ListView4State();
}

class _ListView4State extends State<ListView4> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Provider.of<AstroProvider>(context, listen: false).get_list('Astrology');
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Consumer<AstroProvider>(builder: (context, value, child) {
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
              ),
            )
          : Column(
              children: [
                Container(
                  child: Text(
                    'Astrology',
                    style: GoogleFonts.kanit(
                        color: const Color.fromARGB(255, 23, 21, 21),
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.02),
                  child: Center(
                    child: Container(
                      height: h * .18 * (res.number! < res.available! ? res.number! : res.available!),
                      child: ListView.builder(
                        controller: _controller,
                        scrollDirection: Axis.vertical,
                        itemCount: res.number! <= res.available! ? res.number! : res.available!,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final _news = res.news![index];
                          return InkWell(
                            onTap: () {
                              Get.to(NewsScreenofAstro(
                                index: index,
                                id: _news.id,
                              ));
                            },
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
                                            padding: EdgeInsets.all(w * .05),
                                            child: Text(
                                              _news.title.toString(),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3,
                                              style: GoogleFonts.poppins(),
                                            ),
                                          ),
                                        ),
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
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(
                                              Icons.error_outline_outlined,
                                              color: Colors.orange,
                                            ),
                                            imageUrl: _news.image.toString(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
    });
  }
}
