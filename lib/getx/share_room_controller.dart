import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class ShareRoomController extends GetxController {
  var contacts = <Contact>[].obs;
  var searchPredictions = <DocumentSnapshot>[].obs;

  @override
  void onInit() {
    super.onInit();
    _requestPermission();
  }

  Future<void> _requestPermission() async {
    PermissionStatus status = await Permission.contacts.request();
    if (status.isGranted) {
      _loadContacts();
    } else {
      // Handle permission denied
    }
  }

  Future<void> _loadContacts() async {
    Iterable<Contact> contactList = await ContactsService.getContacts();
    contacts.addAll(contactList);
    // Apply your logic to filter contacts who are using your app
  }

  void updateSearchPredictions(List<DocumentSnapshot> newPredictions) {
    searchPredictions.value = newPredictions;
  }

  void clearSearchPredictions() {
    searchPredictions.clear();
  }
}
