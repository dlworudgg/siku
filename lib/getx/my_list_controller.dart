import 'package:get/get.dart';
import 'package:hive/hive.dart';

class MyListController extends GetxController {
  var box1 = Rx<Box?>(null);
  var box2 = Rx<Box?>(null);
  var box3 = Rx<Box?>(null);
  var box4 = Rx<Box?>(null);

  var keys = RxList<dynamic>();
  var isSimpleView = false.obs;

  var filteredKeys = RxList<dynamic>();

  Future<void> reorderList( int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    // print("Changed oldIndex :  $oldIndex ,  Changed newIndex :  $newIndex");
    // print(keys);
    // print("     ");


    final key = keys.removeAt(oldIndex);
    // print(key);
    keys.insert(newIndex, key);
    // print(keys);

    // Save reordered keys to Hive
    final orderBox = await Hive.openBox('placeDetails_key_order');
    await orderBox.clear(); // Remove all existing keys
  //
    for (var key in keys) {
      print(key);
      await orderBox.add(key);
    }
    // keys.value = orderBox.values.toList();


    // update();
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    box1.value = await Hive.openBox('placeDetails');
    box2.value = await Hive.openBox('placeDetails_images');
    box3.value = await Hive.openBox('placeDetails_key_order');
    box4.value = await Hive.openBox('placeDetails_AISummary');
    keys.addAll(box3.value!.values.toList());

    filteredKeys.addAll(keys);
    // Hive.close();
  }

  void runFilter(String enteredKeyword) {
    List<dynamic> results = [];
    if (enteredKeyword.isEmpty) {
      results = keys;
    } else {
      results = keys.where((key) {
        var placeDetail = box1.value!.get(key);
        return placeDetail['Name'].toLowerCase().contains(enteredKeyword.toLowerCase());
      }).toList();
    }
    // update the filtered keys
    filteredKeys.assignAll(results);
  }


//
//   @override
//   void onClose() {
//     Hive.close(); // Close the Hive box when you're done with it
//     super.onClose();
//   }
}

