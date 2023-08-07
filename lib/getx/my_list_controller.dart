import 'package:get/get.dart';
import 'package:hive/hive.dart';

class MyListController extends GetxController {
  var box1 = Rx<Box?>(null);
  var box2 = Rx<Box?>(null);
  var box3 = Rx<Box?>(null);
  var box4 = Rx<Box?>(null);

  var keys = RxList<dynamic>();

  Future<void> reorderList( int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final key = keys.removeAt(oldIndex);
    keys.insert(newIndex, key);

    // Save reordered keys to Hive
    final orderBox = await Hive.openBox('placeDetails_key_order');
    await orderBox.clear(); // Remove all existing keys

    for (var key in keys) {
      await orderBox.add(key);
    }
    keys.value = orderBox.values.toList();
    update();
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    box1.value = await Hive.openBox('placeDetails');
    box2.value = await Hive.openBox('placeDetails_images');
    box3.value = await Hive.openBox('placeDetails_key_order');
    box4.value = await Hive.openBox('placeDetails_key_order');
    keys.addAll(box3.value!.values.toList());
  }


  @override
  void onClose() {
    Hive.close(); // Close the Hive box when you're done with it
    super.onClose();
  }
}
