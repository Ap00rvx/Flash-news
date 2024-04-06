import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:news_project/Features/Hive/hive_adp.dart';
import 'package:news_project/Features/LoginPage/Service/firebase_options.dart';
import 'package:news_project/Features/Boomarks/Providers/Bookmarkprovider.dart';
import 'package:news_project/Features/HomePage/Provider/env_news.dart';
import 'package:news_project/Features/HomePage/Provider/list_provider.dart';
import 'package:news_project/Features/HomePage/Provider/news_provider.dart';
import 'package:news_project/Features/LoginPage/Screens/startpage.dart';
import 'package:news_project/Features/notifications/services/notificationService.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:hive_flutter/hive_flutter.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(NewsModelAdapter());
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  await Hive.openBox<NewsModelAdp>('BookMark', path: appDocumentDir.path);
  print(Hive.isBoxOpen('BookMark'));
  print(Hive.box<NewsModelAdp>('BookMark').values.length.toString());

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseNotifications().initNotification();

  // Hive.box<NewsModelAdp>('BookMark').clear();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NewsProvider>(
            create: (context) => NewsProvider()),
        ChangeNotifierProvider<ListProvider>(
            create: (context) => ListProvider()),
        ChangeNotifierProvider<BookmarkProvider>(
            create: (context) => BookmarkProvider()),
        ChangeNotifierProvider<EnvProvider>(create: (context) => EnvProvider()),
        ChangeNotifierProvider<AstroProvider>(
            create: (context) => AstroProvider())
      ], // Create and provide the NewsProvider
      child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          home: ValueListenableBuilder(
            valueListenable: Hive.box<NewsModelAdp>('BookMark').listenable(),
            builder: (context, value, child) {
              return StartPage();
            },
          )),
    );
  }
}
