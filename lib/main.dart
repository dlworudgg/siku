import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:siku/pages/auth_page.dart';
import 'package:siku/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';

import 'models/result_adapter.dart';
//
void main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await dotenv.load(fileName: '.env');
  Hive.registerAdapter(ResultAdapter());
  Hive.registerAdapter(GeometryAdapter());
  Hive.registerAdapter(LocationAdapter());
  Hive.registerAdapter(EditorialSummaryAdapter());
  Hive.registerAdapter(PhotoAdapter());
  Hive.registerAdapter(PhotosListAdapter());
  Hive.registerAdapter(ReviewsAdapter());


  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  // await Hive.initFlutter();

  // var my_list = await Hive.openBox('my list');
  // // AuthService authService = AuthService();
  // String? imageUrl = await authService.getProfileImageUrl();
  // await my_list.put('googleProfileImageUrl', imageUrl);
  // my_list.close();

  runApp(MaterialApp(home: MyApp()));
}


class MyApp extends StatelessWidget{
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      theme: AppTheme.lightBase,
      darkTheme: AppTheme.darkBase,
      // themeMode: ThemeMode.dark,
      title : 'Flutter Google Map',
      // debugShowCheckedModeBanner: false,
      // theme : ThemeData(
      //     primaryColor: Colors.white
      // ),
        debugShowCheckedModeBanner: false,
      home: AuthPage()
    );
  }
}


