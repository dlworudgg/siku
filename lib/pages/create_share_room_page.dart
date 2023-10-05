import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../getx/share_room_controller.dart';
import '../theme.dart';

class CancellationToken {
  bool isCancelled = false;

  void cancel() {
    isCancelled = true;
  }
}

class ComposeChatRoomPage extends StatefulWidget {
  @override
  _ComposeChatRoomPageState createState() => _ComposeChatRoomPageState();
}

class _ComposeChatRoomPageState extends State<ComposeChatRoomPage> {
  final ShareRoomController chatController = Get.put(ShareRoomController());
  Timer? _debounce;
  CancellationToken? _cancellationToken;
  List<DocumentSnapshot> searchPredictions = [];
  List<DocumentSnapshot> selectedUsers = [];


  void onSearchTextChanged(String searchText) {
    _debounce?.cancel();
    if (searchText.trim().isEmpty) {
      chatController.clearSearchPredictions();
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 100), () {
      searchAutoComplete(searchText);
    });
  }

  Future<void> searchAutoComplete(String searchText) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isGreaterThanOrEqualTo: searchText)
        .orderBy('email')  // Order by email
        .limit(7)          // Limit results to 7
        .get();

    if (_cancellationToken!.isCancelled) return;

    chatController.updateSearchPredictions(querySnapshot.docs);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  top: 60.0,
                  left: 16.0,
                  right: 16.0,
                  child: TextFormField(
                    onChanged: onSearchTextChanged,
                    decoration: InputDecoration(
                      hintText: 'Search Email or User ID Here',
                      fillColor: AppColors.cardLight, // This should be defined in your theme file.
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
                // Display search results
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: selectedUsers.length,
                  itemBuilder: (context, index) {
                    final userData = selectedUsers[index].data() as Map<String, dynamic>;
                    final userEmail = userData['email'];
                    return ListTile(
                      title: Text(userEmail),
                      trailing: ElevatedButton(
                        child: Text("Remove"),
                        onPressed: () {
                          setState(() {
                            selectedUsers.removeAt(index);
                          });
                        },
                      ),
                    );
                  },
                ),
                Obx(() {
                  return ListView.builder(
                    itemCount: chatController.searchPredictions.length,
                    itemBuilder: (context, index) {
                      final userData = chatController.searchPredictions[index].data() as Map<String, dynamic>;
                      final userEmail = userData['email'];
                      return ListTile(
                        title: Text(userEmail),
                        trailing: ElevatedButton(
                          child: Text("Add"),
                          onPressed: () {
                            setState(() {
                              selectedUsers.add(chatController.searchPredictions[index]);
                            });
                          },
                        ),
                        // Add other UI elements or data as needed
                      );
                    },
                  );
                })

              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // For now, print the emails of the selected users
                for (var userDoc in selectedUsers) {
                  var userData = userDoc.data() as Map<String, dynamic>;
                  print(userData['email']);
                }
                // You can add logic to initiate the chat here
              },
              child: Text('Start Share'),
            ),
          ),
        ],
      ),
    );
  }
}
