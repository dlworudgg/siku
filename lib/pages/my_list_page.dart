import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../components/slide_image.dart';
import '../getx/my_list_controller.dart';
import '../screens/place_information_screen.dart';


class MyListPage extends StatelessWidget { // Changed to StatelessWidget
  final String id;
  final String name;
  final bool isSavedList;

  const MyListPage({
    Key? key,
    required this.id,
    required this.isSavedList,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final ListController = Get.put(MyListController());

    return Stack(
      children: [Scaffold(
        // ... [Rest of your code remains unchanged]
        body: Obx(() {
              // final box =  ListController.box1;
              // final imageBox = ListController.box2;
              // final orderBox = ListController.box3;
              final box = ListController.box1.value;
              final imageBox = ListController.box2.value;
              final orderBox = ListController.box3.value;

              if (box == null || imageBox == null || orderBox == null) {
                return const Center(child: CircularProgressIndicator());
              }
              {
                final keys = ListController.keys;
                return Column(
                children: [
                  // SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.only(
                        top: 80.0, bottom: 20.0, left: 100, right: 100),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      style: TextStyle(color: Colors.black, fontSize: MediaQuery.of(context).size.width * 0.045),
                    ),
                  ),
                  Expanded(
                    child: ReorderableListView.builder(
                      shrinkWrap: false,
                      physics: const ClampingScrollPhysics(),
                      proxyDecorator: (child, index, animation) {
                        return Material(
                          elevation: 4.0,
                          color: Colors
                              .transparent, // setting background color to transparent
                          child: child,
                        );
                      },
                      itemCount: keys.length,
                      itemBuilder: (context, index) {
                        final key = keys[index];
                        final placeDetail = box.get(key);
                        final placeDetailImages = imageBox.get(key);
                        // final placeDetailFormated = Map<String, dynamic>.from(placeDetail );
                        return InkWell(
                          key: ValueKey(key),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => placeInformationScreen(
                                placeDetail: placeDetail,
                                placeDetailImages: placeDetailImages,
                                placeId: key)));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 0.0, top: 0),
                            height: 250,
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black
                                      .withOpacity(0.3), // Set the border color
                                  width: 0.6, // Set the border width (optional)
                                ),
                                // color: Colors.grey.withOpacity(0.05),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15.0),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey
                                          .withOpacity(0.4), // Soft shadow
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: const Offset(0, 3)),
                                  BoxShadow(
                                      color: Colors.grey
                                          .withOpacity(0.4), // Soft shadow
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: const Offset(5, 0)),
                                ],
                              ),
                              // padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  // Image
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: SizedBox(
                                      width: 400,
                                      height: 140,
                                      // child:  Hero(
                                      //   tag: 'my_list_image$index',
                                      child: ImageSlider(
                                        images: placeDetailImages,
                                        height: 140,
                                        width: 400,
                                        showDotIndicator: true,
                                        showIndexIndicator: false,
                                        placeDetail: placeDetail,
                                        placeDetailImages: placeDetailImages,
                                        placeId: key,
                                        // listIndex : index,
                                      ),
                                      // ),
                                    ),
                                  ),

                                  // Text Details
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          // Title
                                          Row(
                                            children: <Widget>[
                                              // const SizedBox(width: 16),
                                              Text(
                                                placeDetail?['Name'] ?? '',
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                              const SizedBox(width: 8),
                                              // Rating
                                              if (placeDetail?['rating'] !=
                                                  null &&
                                                  placeDetail?['rating'] != '')
                                                Row(
                                                  children: [
                                                    const Icon(Icons.star,
                                                        color: Colors.yellow,
                                                        size: 16),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      placeDetail?['rating']
                                                          .toString() ??
                                                          '',
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 13),
                                                    ),
                                                  ],
                                                ),
                                              const SizedBox(width: 4),

                                              // Price Level
                                              if (placeDetail?['priceLevel'] !=
                                                  null &&
                                                  placeDetail?['priceLevel'] !=
                                                      '')
                                                Text(
                                                  '\$' *
                                                      int.parse(placeDetail![
                                                      'priceLevel']
                                                          .toString()),
                                                  style: TextStyle(
                                                      color: Colors.grey[40],
                                                      fontSize: 13),
                                                ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),

                                          // Editorial Summary
                                          Text(
                                            placeDetail?['editorialSummary'] ??
                                                '',
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 12),
                                          ),
                                          const SizedBox(height: 5),

                                          // Price Level and Rating
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      onReorder: (oldIndex, newIndex) {
                        ListController.reorderList( oldIndex, newIndex);
                      },
                    ),
                  ),
                ],
              );}
  }),
      ),
        Positioned(
          top: 40, // Adjust these values as needed
          left: 15,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 21,
            child: Material(
              type: MaterialType.transparency, // This makes the Material visually transparent
              child: InkWell(
                onTap: () {
                  // Navigator.pop(context);
                  Get.back();
                },
                child: const Center(
                  child: Icon(Icons.arrow_back,
                      size: 21,
                      color: Colors.black), // Adjust the size and color as needed
                ),
              ),
            ),
          ),
        )
    ]);
  }
}



