import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../components/slide_image.dart';
import '../models/place_detail_response.dart';

class placeInformationScreen extends StatefulWidget {
  final dynamic placeDetail;
  final dynamic placeDetailImages;
  final String placeId;
  final int  imageIndex;

  const placeInformationScreen(
      {Key? key,
      required this.placeDetail,
      required this.placeDetailImages,
      required this.placeId,
      required this.imageIndex})
      : super(key: key);

  @override
  State<placeInformationScreen> createState() => _placeInformationScreenState();
}


class _placeInformationScreenState extends State<placeInformationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ClipRRect(
          //   borderRadius: BorderRadius.circular(15.0),
          //   child: SizedBox(
          //     width: 400,
          //     height: 230,
          //     child: ImageSlider(
          //         images: widget.placeDetailImages, width: 400, height: 250),
          //   ),
          // ),
          Hero(
            tag: widget.placeDetailImages[widget.imageIndex],  // Using the passed selectedImage as the Hero tag
            child: Image.network(widget.placeDetailImages[widget.imageIndex],
              height: 400,
              width: 400,
            ),
          ),
          SizedBox(height: 25),
            Row(
              children: <Widget>[
                // const SizedBox(width: 16),
                Text(
                  widget.placeDetail['Name'] ?? '',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                // Rating
                if (widget.placeDetail['rating'] != null &&
                    widget.placeDetail['rating'] != '')
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.yellow, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        widget.placeDetail['rating'].toString() ?? '',
                        style: TextStyle(color: Colors.black, fontSize: 13),
                      ),
                    ],
                  ),
                const SizedBox(width: 4),

                // Price Level
                if (widget.placeDetail['priceLevel'] != null &&
                    widget.placeDetail['priceLevel'] != '')
                  Text(
                    '\$' *
                        int.parse(widget.placeDetail['priceLevel'].toString()),
                    style: TextStyle(color: Colors.grey[40], fontSize: 13),
                  ),
              ],
            ),
          SizedBox(height: 10),
          Text(
            widget.placeDetail['formatted_address'] ?? '',
            style: TextStyle(fontSize: 18),
          ),
          //   SizedBox(height: 10),
          // for ( var review in widget.placeDetail!.reviews! ?? [])
          //   Text(
          //    review.text,
          //     style: TextStyle(fontSize: 18),
          //   ),
          SizedBox(height: 10),
          for (var text in widget.placeDetail['weekday_text'] ?? [])
            Text(
              text,
              style: TextStyle(fontSize: 14),
            ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
