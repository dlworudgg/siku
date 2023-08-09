
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../getx/init_controller.dart';


final mapController = Get.find<initController>();

class InitLoadingPage extends StatelessWidget {
  const InitLoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset( 'lib/images/Chef_Hat_Icon.png',
          height: 100,
          width: 100,), // replace with your image path
      ),
    );
  }
}
