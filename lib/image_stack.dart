library image_stack;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Creates an array of circular images stacked over each other
class ImageStack extends StatelessWidget {
  List<Widget> _widgetList = [];

  /// List of image urls
  final List<String> imageList;

  /// Image radius for the circular image
  final double? imageRadius;

  /// Count of the number of images to be shown
  final int? imageCount;

  /// Total count will be used to determine the number of circular images
  /// to be shown along with showing the remaining count in an additional
  /// circle
  final int totalCount;

  /// Optional field to set the circular image border width
  final double? imageBorderWidth;

  /// Optional field to set the color of circular image border
  final Color? imageBorderColor;

  /// The text style to apply if there is any extra count to be shown
  final TextStyle extraCountTextStyle;

  /// Set the background color of the circle
  final Color backgroundColor;

  /// Enum to define the image source.
  ///
  /// Describes type of the image source being sent in [imageList]
  ///
  /// Possible values:
  ///  * Asset
  ///  * Network
  ///  * File
  final ImageSource? imageSource;

  /// Custom widget list passed to render circular images
  final List<Widget> children;

  /// Radius for the circular image to applied when [children] is passed
  final double? widgetRadius;

  /// Count of the number of widget to be shown as circular images when [children]
  /// is passed
  final int? widgetCount;

  /// Optional field to set the circular border width when [children] is passed
  final double? widgetBorderWidth;

  /// Optional field to set the color of circular border when [children] is passed
  final Color? widgetBorderColor;

  /// List of `ImageProvider`
  final List<ImageProvider> providers;

  /// To show the remaining count if the provided list size is less than [totalCount]
  final bool showTotalCount;

  /// Creates a image stack widget.
  ///
  /// The [imageList] and [totalCount] parameters are required.
  ImageStack({
    Key? key,
    required this.imageList,
    this.imageRadius = 25,
    this.imageCount = 3,
    required this.totalCount,
    this.imageBorderWidth = 2,
    this.imageBorderColor = Colors.grey,
    this.imageSource = ImageSource.Network,
    this.showTotalCount = true,
    this.extraCountTextStyle = const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w600,
    ),
    this.backgroundColor = Colors.white,
  })  : children = [],
        providers = [],
        widgetBorderColor = null,
        widgetBorderWidth = null,
        widgetCount = null,
        widgetRadius = null,
        super(key: key);

  /// Creates a image stack widget by passing list of custom widgets.
  ///
  /// The [children] and [totalCount] parameters are required.
  ImageStack.widgets({
    Key? key,
    required this.children,
    this.widgetRadius = 25,
    this.widgetCount = 3,
    required this.totalCount,
    this.widgetBorderWidth = 2,
    Color this.widgetBorderColor = Colors.grey,
    this.showTotalCount = true,
    this.extraCountTextStyle = const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w600,
    ),
    this.backgroundColor = Colors.white,
  })  : imageList = [],
        providers = [],
        imageBorderColor = null,
        imageBorderWidth = null,
        imageCount = null,
        imageRadius = null,
        imageSource = null,
        super(key: key);

  /// Creates an image stack by passing list of `ImageProvider`.
  ///
  /// The [providers] and [totalCount] parameters are required.
  ImageStack.providers({
    Key? key,
    required this.providers,
    this.imageRadius = 25,
    this.imageCount = 3,
    required this.totalCount,
    this.imageBorderWidth = 2,
    this.imageBorderColor = Colors.grey,
    this.showTotalCount = true,
    this.extraCountTextStyle = const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w600,
    ),
    this.backgroundColor = Colors.white,
  })  : imageList = [],
        children = [],
        widgetBorderColor = null,
        widgetBorderWidth = null,
        widgetCount = null,
        widgetRadius = null,
        imageSource = null,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    int _size = children.length > 0 ? widgetCount! : imageCount!;
    var items = List.from(imageList)..addAll(children)..addAll(providers);
    _widgetList.addAll(items
        .sublist(0, _size)
        .asMap()
        .map((index, value) => MapEntry(
            index,
            Padding(
              padding: EdgeInsets.only(left: 0.7 * imageRadius! * index),
              child: circularItem(value),
            )))
        .values
        .toList()
        .reversed
        .toList());

    return Container(
      child: Row(
        children: <Widget>[
          _widgetList.isNotEmpty
              ? Stack(
                  clipBehavior: Clip.none,
                  children: _widgetList,
                )
              : SizedBox(),
          Container(
              child: showTotalCount && totalCount - _widgetList.length > 0
                  ? Container(
                      constraints: BoxConstraints(minWidth: imageRadius!),
                      padding: EdgeInsets.all(3),
                      height: imageRadius,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(imageRadius!),
                          border: Border.all(
                              color: imageBorderColor!,
                              width: imageBorderWidth!),
                          color: backgroundColor),
                      child: Center(
                        child: Text(
                          "+${totalCount - _widgetList.length}",
                          textAlign: TextAlign.center,
                          style: extraCountTextStyle,
                        ),
                      ),
                    )
                  : SizedBox()),
        ],
      ),
    );
  }

  Widget circularItem(dynamic item) {
    if (item is ImageProvider) {
      return circularProviders(item);
    } else if (item is Widget) {
      return circularWidget(item);
    } else if (item is String) {
      return circularImage(item);
    }
    return Container();
  }

  circularWidget(Widget widget) {
    return Container(
      height: widgetRadius,
      width: widgetRadius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        border: Border.all(
          color: widgetBorderColor!,
          width: widgetBorderWidth!,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widgetRadius!),
        child: widget,
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
          width: imageBorderWidth!,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          image: DecorationImage(
            image: imageProvider(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget circularProviders(ImageProvider imageProvider) {
    return Container(
      height: imageRadius,
      width: imageRadius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: imageBorderWidth!,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  imageProvider(imageUrl) {
    if (this.imageSource == ImageSource.Asset) {
      return AssetImage(imageUrl);
    } else if (this.imageSource == ImageSource.File) {
      return FileImage(imageUrl);
    }
    return NetworkImage(imageUrl);
  }
}

enum ImageSource { Asset, Network, File }
