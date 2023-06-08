import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:siku/pages/auth_page.dart';
import 'package:siku/screens/home_screen.dart';
import 'package:siku/screens/map_screen.dart';
import 'package:siku/screens/login_screen.dart';
import 'package:siku/theme.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:siku/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

//
void main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options : DefaultFirebaseOptions.currentPlatform,
  );

  await dotenv.load(fileName: '.env');


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
      // LoginPage()
      // HomeScreen(),
    );
  }
}




// class MyApp extends StatelessWidget{
//   @override
//   Widget build(BuildContext context){
//     return MaterialApp(
//       title : 'Flutter Google Map',
//       debugShowCheckedModeBanner: false,
//       theme : ThemeData(
//         primaryColor: Colors.white
//       ),
//       home: MapScreen(),
//     );
//   }
// }

