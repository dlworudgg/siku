import 'package:flutter/material.dart';
import 'package:siku/screens/home_screen.dart';
import 'package:siku/screens/map_screen.dart';
import 'package:siku/screens/login_screen.dart';
import 'package:siku/theme.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
//
void main() {
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
      home: LoginPage()
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

