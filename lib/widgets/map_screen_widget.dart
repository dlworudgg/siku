//
// void _showSignOutDialog(BuildContext context) {
//   showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('User Name'), // Replace 'User Name' with the actual user name
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               Divider(color: Colors.grey),
//               Row(
//                 children: [
//                   Icon(Icons.logout, color: Colors.black), // This is the prefix icon
//                   SizedBox(width: 10), // Add some space between the icon and the button
//                   TextButton(
//                     child: Text('Sign Out'),
//                     onPressed: () {
//                       signUserOut();
//                       Navigator.of(context).pop();
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       }
//   );
// }
//
//
//
// void _onSearchTap() {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true, // This allows the bottom sheet to expand to its full height
//     builder: (BuildContext context) {
//       return Container(
//         constraints: BoxConstraints(
//           maxHeight: MediaQuery.of(context).size.height,
//           maxWidth: MediaQuery.of(context).size.width,
//         ),
//         child: SearchScreen(),
//       );
//     },
//   );
// }
//
//
// void _onMenuTap() {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true, // This allows the bottom sheet to expand to its full height
//     builder: (BuildContext context) {
//       return Container(
//         constraints: BoxConstraints(
//           maxHeight: MediaQuery.of(context).size.height,
//           maxWidth: MediaQuery.of(context).size.width,
//         ),
//         child:  MessagesPage(),
//       );
//     },
//   );
// }
//
//
// void _showPlaceDetail() {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true, // This allows you to control the size of the bottom sheet
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(
//         top: Radius.circular(25),
//       ),
//     ),
//     builder: (BuildContext context) {
//       return FractionallySizedBox(
//         heightFactor: 0.7, // This allows the bottom sheet to take up 60% of the screen
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(25),
//               topRight: Radius.circular(25),
//             ),
//           ),
//           padding: EdgeInsets.all(20),
//           child: SingleChildScrollView( // wrap your Column in a SingleChildScrollView
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   widget.place_detail!.name,
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   widget.place_detail!.formattedAddress,
//                   style: TextStyle(fontSize: 18),
//                 ),
//                 SizedBox(height: 10),
//                 for (var text in widget.place_detail!.weekdayText)
//                   Text(
//                     text,
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 SizedBox(height: 10),
//                 Row(
//                   children: [
//                     for (int i = 0; i < widget.place_detail!.rating.round(); i++)
//                       Icon(Icons.star, color: Colors.pink),
//                   ],
//                 ),
//                 SizedBox(height: 10),
//                 if (widget.place_detail!.photos.isNotEmpty)
//                   Image.network(
//                     'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${widget.place_detail!.photos[0]}&key=$googleMapKey',
//                     fit: BoxFit.cover,
//                   ),
//               ],
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }
//
