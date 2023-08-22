import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../components/slide_image.dart';
import '../getx/map_controller.dart';
import '../getx/my_list_controller.dart';
import '../screens/place_information_screen.dart';

class MyListPage extends StatelessWidget {
  // Changed to StatelessWidget
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
    final mapController = Get.find<MapController>();

    return Stack(children: [
      Scaffold(
        // ... [Rest of your code remains unchanged]
        body: Obx(() {
          // final box =  ListController.box1;
          // final imageBox = ListController.box2;
          // final orderBox = ListController.box3;
          final box = ListController.box1.value;
          final imageBox = ListController.box2.value;
          final orderBox = ListController.box3.value;
          final aiBox = ListController.box4.value;

          if (box == null ||
              imageBox == null ||
              orderBox == null ||
              aiBox == null) {
            return const Center(child: CircularProgressIndicator());
          }
          {
            final keys = ListController.keys;
            return Column(
              children: [
                // SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.only(top: 80.0, left: 100, right: 60
                              // right: 100
                              ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Text(
                        name,
                        maxLines: 1,
                        // overflow: TextOverflow.clip,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize:
                                MediaQuery.of(context).size.width * 0.045),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 80.0, right: 0),
                      child: IconButton(
                        icon: Icon(Icons.view_list),
                        onPressed: () {
                          ListController.isSimpleView
                              .toggle(); // Toggle the view
                        },
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Container(
                    child: TextField(
                      onChanged : (value) => ListController.runFilter(value),
                      decoration: const InputDecoration(
                          labelText: 'Search', suffixIcon: Icon(Icons.search)),
                    ),
                    // decoration: BoxDecoration(
                    //   border: Border.all(
                    //     color: Colors.black54,
                    //     width: 1.0,
                    //   ),
                    // ),
                  ),
                ),
                Container(
                  height: 50,
                  color: Colors.transparent,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount:  mapController.cuisinesStylesList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 3.0, top: 8, bottom: 8),
                        child: GestureDetector(
                          onTap: () {
                            mapController.toggleSelection(index);
                          },
                          child: Obx(() { // Rebuilds this widget when selectedIndexes changes
                            return Container(
                              // width: mapController.widthList[index],
                              width:  mapController.buttonWidths[index],
                              height: 10,
                              decoration: BoxDecoration(
                                color: mapController.selectedIndexes.contains(index)
                                    ? Colors.lightBlue[100]
                                    : Colors.grey[100],
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.grey, width: 1),
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(width: 15),
                                  Center(
                                      child: Text(
                                        // mapController.cuisines[index],
                                        mapController.cuisinesStylesList[index],
                                        style: TextStyle(
                                            color: mapController.selectedIndexes.contains(index)
                                                ? Colors.blue[900]
                                                : Colors.black,
                                            fontWeight: FontWeight.bold
                                        ),
                                      )
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                    child: buildListView(
                        ListController, keys, box, imageBox, aiBox, context)),
              ],
            );
          }
        }),
      ),
      Positioned(
        top: 40, // Adjust these values as needed
        left: 15,
        child: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 21,
          child: Material(
            type: MaterialType
                .transparency, // This makes the Material visually transparent
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

Widget buildListView(MyListController ListController, List<dynamic> keys,
    Box box, Box imageBox, Box aiBox, BuildContext context) {
  if (!ListController.isSimpleView.value) {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        color: Colors.black54,
      ),
      padding: EdgeInsets.zero,
      itemCount: ListController.filteredKeys.length,
      itemBuilder: (context, index) {
        // final key = keys[index];
        final key = ListController.filteredKeys[index];
        final placeDetail = box.get(key);
        final placeDetailImages = imageBox.get(key);
        final aisummary = aiBox.get(key);
        // PListController.savedAIResponse = AiBox?.get(placeId) as Map<String, dynamic>?;
        return InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => placeInformationScreen(
                    placeDetail: placeDetail,
                    placeDetailImages: placeDetailImages,
                    placeId: key)));
          },
          child: Container(
            margin: const EdgeInsets.only(left: 10, bottom: 0.0, top: 0),
            height: 90,
            // padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
              child: Row(
                children: [
                  Hero(
                    transitionOnUserGestures: true,
                    tag: 'my_list_image_${key}',
                    child: Container(
                      width: 70.0,
                      height: 70.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        border: Border.all(
                          color: Colors.black54,
                          width: 1.0,
                        ),
                        image: DecorationImage(
                          image: MemoryImage(placeDetailImages[0]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  // Container(
                  //   width: 70.0,
                  //   height: 70.0,
                  //   decoration: BoxDecoration(
                  //     shape: BoxShape.circle,
                  //     border: Border.all(
                  //       color: Colors.black54,
                  //       width: 2.0,
                  //     ),
                  //   ),
                  //   child: ClipOval(
                  //     child: Image.memory(
                  //       placeDetailImages[0],
                  //       fit: BoxFit.cover,
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Title
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              placeDetail?['Name'] ?? '',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              placeDetail?['cuisines/styles'] ??
                                  aisummary['Cuisines/Styles'] ??
                                  'Not Available',
                              // placeDetail?['cusine'] ?? '',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Rating
                            if (placeDetail?['rating'] != null &&
                                placeDetail?['rating'] != '')
                              Row(
                                children: [
                                  const Icon(Icons.star,
                                      color: Colors.yellow, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    placeDetail?['rating'].toString() ?? '',
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 13),
                                  ),
                                ],
                              ),
                            const SizedBox(width: 4),

                            // Price Level
                            if (placeDetail?['priceLevel'] != null &&
                                placeDetail?['priceLevel'] != '')
                              Text(
                                '\$' *
                                    int.parse(
                                        placeDetail!['priceLevel'].toString()),
                                style: TextStyle(
                                    color: Colors.grey[400], fontSize: 13),
                              ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Text(
                            placeDetail?['editorialSummary'] ?? '',
                            style: const TextStyle(
                                color: Colors.black, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  } else {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: false,
      physics: const ClampingScrollPhysics(),
      // itemCount: keys.length,
      itemCount: ListController.filteredKeys.length,
      itemBuilder: (context, index) {
        // final key = keys[index];
        final key = ListController.filteredKeys[index];
        final placeDetail = box.get(key);
        final placeDetailImages = imageBox.get(key);
        // final placeDetailFormated = Map<String, dynamic>.from(placeDetail );
        return InkWell(
          key: ValueKey(key),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => placeInformationScreen(
                    placeDetail: placeDetail,
                    placeDetailImages: placeDetailImages,
                    placeId: key)));
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 0.0, top: 0),
            height: 250,
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black.withOpacity(0.3), // Set the border color
                  width: 0.6, // Set the border width (optional)
                ),
                // color: Colors.grey.withOpacity(0.05),
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.4), // Soft shadow
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 3)),
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.4), // Soft shadow
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(5, 0)),
                ],
              ),
              // padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Image
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
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
                          picNum: 5
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
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 8),
                              // Rating
                              if (placeDetail?['rating'] != null &&
                                  placeDetail?['rating'] != '')
                                Row(
                                  children: [
                                    const Icon(Icons.star,
                                        color: Colors.yellow, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      placeDetail?['rating'].toString() ?? '',
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 13),
                                    ),
                                  ],
                                ),
                              const SizedBox(width: 4),

                              // Price Level
                              if (placeDetail?['priceLevel'] != null &&
                                  placeDetail?['priceLevel'] != '')
                                Text(
                                  '\$' *
                                      int.parse(placeDetail!['priceLevel']
                                          .toString()),
                                  style: TextStyle(
                                      color: Colors.grey[40], fontSize: 13),
                                ),
                            ],
                          ),
                          const SizedBox(height: 5),

                          // Editorial Summary
                          Text(
                            placeDetail?['editorialSummary'] ?? '',
                            style: const TextStyle(
                                color: Colors.black, fontSize: 12),
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
      // onReorder: (oldIndex, newIndex) {
      //   print("oldIndex :  $oldIndex ,  newIndex :  $newIndex");
      //   ListController.reorderList( oldIndex, newIndex);
      // },
    );
  }
}

Widget simpleListItem(
    Map<String, dynamic> placeDetail, key, context, placeDetailImages) {
  return InkWell(
    onTap: () {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => placeInformationScreen(
              placeDetail: placeDetail,
              placeDetailImages: placeDetailImages,
              placeId: key)));
    },
    child: Container(
      margin: const EdgeInsets.only(bottom: 0.0, top: 0),
      height: 100,
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child:
          // Text Details
          Expanded(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  // Rating
                  if (placeDetail?['rating'] != null &&
                      placeDetail?['rating'] != '')
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.yellow, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          placeDetail?['rating'].toString() ?? '',
                          style: const TextStyle(
                              color: Colors.black, fontSize: 13),
                        ),
                      ],
                    ),
                  const SizedBox(width: 4),

                  // Price Level
                  if (placeDetail?['priceLevel'] != null &&
                      placeDetail?['priceLevel'] != '')
                    Text(
                      '\$' * int.parse(placeDetail!['priceLevel'].toString()),
                      style: TextStyle(color: Colors.grey[40], fontSize: 13),
                    ),
                ],
              ),
              const SizedBox(height: 5),

              // Editorial Summary
              // Text(
              //   placeDetail?['editorialSummary'] ??
              //       '',
              //   style: const TextStyle(
              //       color: Colors.black,
              //       fontSize: 12),
              // ),
              // const SizedBox(height: 5),

              // Price Level and Rating
            ],
          ),
        ),
      ),
    ),
  );
}
