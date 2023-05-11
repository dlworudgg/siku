import 'package:flutter/material.dart';

import '../theme.dart';
import 'home_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Positioned(
        top: 60.0,
        left: 16.0,
        right: 16.0,
        child: TextFormField(

          decoration: InputDecoration(
            hintText: 'Search here',
            fillColor: AppColors.cardLight,
            filled: true,
            prefixIcon: InkWell(
              onTap: () {
                Navigator.pop(context);
                // Navigator.push(
                  // context,
                  // MaterialPageRoute(builder: (context) => HomeScreen()),
                // );
              },
              child: const Icon(Icons.arrow_back_ios),
            ),

            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          // textInputAction: TextInputAction.search,
        ),
      ),
    ]
        )
    );
  }
}
