import 'dart:typed_data';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageSlider extends StatefulWidget {
  final List<dynamic> images;
  final double height;
  final double width;
  final ValueChanged<int> onImageChanged;
  ImageSlider({required this.images, required this.height,
    required this.width,
    required this.onImageChanged});

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

        _controller.addListener(() {
          setState(() {
            _currentPage = _controller.page!;
            widget.onImageChanged(_currentPage.round());
          });
        });

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: widget.height,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              return Hero(
                  tag: widget.images[index],
                  child: Image.memory(
                      widget.images[index],
                      height: widget.height,
                      width: widget.width,
                      fit: BoxFit.cover
                  )
              );
            },
          ),
        ),
        Positioned(
          // top: 60.0,
          left: 16.0,
          right: 16.0,
          bottom: 5.0,
          child: DotsIndicator(
            dotsCount: (widget.images.length / 2).ceil(),
            position: (_currentPage / 2).round(),
            decorator: DotsDecorator(
              size: const Size.square(7.0),
              activeSize: const Size(20.0, 7.0),
              color: Colors.white.withOpacity(0.4), // Inactive color
              activeColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}