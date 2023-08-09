import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:siku/pages/auth_page.dart';
import 'package:siku/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart';  // <-- Import this
import 'getx/init_controller.dart';
import 'getx/map_controller.dart';
//
void main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );



  await dotenv.load(fileName: '.env');
  //
  // Hive.registerAdapter(ResultAdapter());
  // Hive.registerAdapter(GeometryAdapter());
  // Hive.registerAdapter(LocationAdapter());
  // Hive.registerAdapter(EditorialSummaryAdapter());
  // Hive.registerAdapter(PhotoAdapter());
  // Hive.registerAdapter(PhotosListAdapter());
  // Hive.registerAdapter(ReviewsAdapter());


  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);


  // final box = await Hive.openBox('placeDetails');

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
  Widget build(BuildContext context) {
    return GetMaterialApp(  // <-- Change this to GetMaterialApp
      theme: AppTheme.lightBase,
      darkTheme: AppTheme.darkBase,
      // title: 'Flutter Google Map',
      debugShowCheckedModeBanner: false,
      home:  Home()// <-- We use Home widget here to initialize the controller
    );
  }
}

// This widget is introduced to initialize the MapController
class Home extends StatelessWidget {
  final mapController = Get.put(MapController());
  final initControllerInstance = Get.put(initController());

  @override
  Widget build(BuildContext context) {
    return AuthPage();
  }
}