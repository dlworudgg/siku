import 'dart:typed_data';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/place_information_screen.dart';

class ImageSlider extends StatefulWidget {
  final List<dynamic> images;
  final double height;
  final double width;
  final bool showDotIndicator;
  final bool showIndexIndicator;
  final dynamic placeDetail;
  final dynamic placeDetailImages;
  final String placeId;
  // final int listIndex;
  // final ValueChanged<int> onImageChanged;
  ImageSlider({required this.images, required this.height,
    required this.width,
    required this.showDotIndicator,
    required this.showIndexIndicator,
    required this.placeDetail,
    required this.placeDetailImages,
    required this.placeId,
    // required this.listIndex
    // required this.onImageChanged
  });

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  double _currentPage = 0.0;
  final _controller = PageController(viewportFraction: 1);

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page!;
        // _controller.addListener(() {
          // setState(() {
            // widget.onImageChanged(_currentPage.round());
          // });
        // });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => placeInformationScreen(placeDetail: widget.placeDetail ,
                    placeDetailImages : widget.placeDetailImages,
                    placeId : widget.placeId)
            ));
          },
          child: Container(
            height: widget.height,
            child: Hero(
              transitionOnUserGestures: true,
              tag : 'my_list_image_${widget.placeId}',
              child: PageView.builder(
                controller: _controller,
                itemCount: widget.images.length,
                itemBuilder: (context, index) {
                  return  Image.memory(
                      widget.images[index],
                      height: widget.height,
                      width: widget.width,
                      fit: BoxFit.cover
                  );
                  // return Hero(
                  //   tag : 'my_list_image_${widget.listIndex}',
                  //     child: Image.memory(
                  //         widget.images[index],
                  //         height: widget.height,
                  //         width: widget.width,
                  //         fit: BoxFit.cover
                  //     )
                  // );
                },
              ),
            ),
          ),
        ),
          // Existing logic for displaying the DotIndicator
          Visibility(
            visible: widget.showDotIndicator,
            child: Positioned(
              // top: 60.0,
              left: 16.0,
              right: 16.0,
              bottom: 5.0,
              child: DotsIndicator(
                dotsCount: 6,
                position: (_currentPage / 2).round(),
                decorator: DotsDecorator(
                  size: const Size.square(7.0),
                  activeSize: const Size(20.0, 7.0),
                  color: Colors.white.withOpacity(0.4), // Inactive color
                  activeColor: Colors.white,
                ),
              ),
            ),
          ),
          // New logic for displaying the image index
          Visibility(
            visible: widget.showIndexIndicator,
            child: Positioned(
              right: 10,
              bottom: 10,
              child: Container(
                width: 60,  // desired width
                height: 25,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    '${_currentPage.round() + 1}/${widget.images.length}',
                    style: TextStyle(color: Colors.white, fontSize: 14,fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          )
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}