import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../getx/share_room_controller.dart';


class CancellationToken {
  bool isCancelled = false;

  void cancel() {
    isCancelled = true;
  }
}
Timer? _debounce;
CancellationToken? _cancellationToken;

//I need to create a user ID section and let user search with email or user_id
class ComposeChatRoomPage extends StatelessWidget {
  final ShareRoomController chatController = Get.put(ShareRoomController());
  //Need to have only search section like search_page
  //And It will search with in all the emails in authentication,
  //



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 60.0,
            left: 16.0,
            right: 16.0,
            child: TextFormField(
              // focusNode: _focusNode,
              onChanged: onSearchTextChanged,
              decoration: InputDecoration(
                hintText: 'Search Restaurants Here',
                fillColor: AppColors.cardLight,
                filled: true,
                prefixIcon: InkWell(
                  onTap: () {
                    // Cancel timer
                    _debounce?.cancel();

                    // Signal to cancel all ongoing operations
                    _cancellationToken?.cancel();

                    // Navigator.pop(context);
                    Get.back();
                  },
                  child: const Icon(Icons.arrow_back_ios, color: Colors.blue),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
