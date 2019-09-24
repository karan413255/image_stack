library image_stack;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Creates an image stack
class ImageStack extends StatelessWidget {
  final List<String> imageList;
  final double imageRadius;
  final int imageCount;
  final double imageBorderWidth;
  final Color imageBorderColor;
  final TextStyle extraCountTextStyle;
  final Color backgroundColor;

  ImageStack({
    Key key,
    @required this.imageList,
    this.imageRadius = 25,
    this.imageCount = 3,
    this.imageBorderWidth = 2,
    this.imageBorderColor = Colors.grey,
    this.extraCountTextStyle = const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w600,
    ),
    this.backgroundColor = Colors.white,
  })  : assert(imageList != null && imageList.length != 0),
        assert(extraCountTextStyle != null),
        assert(imageBorderColor != null),
        assert(backgroundColor != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var images = List<Widget>();
    int _size = imageCount;
    images.add(circularImage(imageList[0]));

    if (imageList.length > 1) {
      if (imageList.length < _size) {
        _size = imageList.length;
      }
      images.addAll(imageList
          .sublist(1, _size)
          .asMap()
          .map((index, image) => MapEntry(
                index,
                Positioned(
                  right: 0.8 * imageRadius * (index + 1.0),
                  child: circularImage(image),
                ),
              ))
          .values
          .toList());
    }

    return Container(
      child: Row(
        children: <Widget>[
          Stack(
            overflow: Overflow.visible,
            textDirection: TextDirection.rtl,
            children: images,
          ),
          Container(
            margin: EdgeInsets.only(left: 2),
            child: imageList.length - _size > 0
                ? Container(
                    constraints: BoxConstraints(minWidth: imageRadius),
                    padding: EdgeInsets.all(3),
                    height: imageRadius,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(imageRadius),
                        border: Border.all(
                            color: imageBorderColor, width: imageBorderWidth),
                        color: backgroundColor),
                    child: Center(
                      child: Text(
                        "+" + (imageList.length - _size).toString(),
                        textAlign: TextAlign.center,
                        style: extraCountTextStyle,
                      ),
                    ),
                  )
                : SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget circularImage(String imageUrl) {
    return Container(
      height: imageRadius,
      width: imageRadius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: imageBorderWidth,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
