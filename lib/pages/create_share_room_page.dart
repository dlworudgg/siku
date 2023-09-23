import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../getx/share_room_controller.dart';



//I need to create a user ID section and let user search with email or user_id 
class ComposeChatRoomPage extends StatelessWidget {
  final ShareRoomController chatController = Get.put(ShareRoomController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Compose Chat Room'),
      ),
      body: Obx(
            () => ListView.builder(
          itemCount: chatController.contacts.length,
          itemBuilder: (context, index) {
            final contact = chatController.contacts[index];
            return ListTile(
              title: Text(contact.displayName ?? ''),
              onTap: () {
                // Handle contact selection
              },
            );
          },
        ),
      ),
    );
  }
}
