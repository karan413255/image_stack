library image_stack;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Creates an image stack
class ImageStack extends StatelessWidget {
  final List<String> imageList;
  final double? imageRadius;
  final int? imageCount;
  final int totalCount;
  final double? imageBorderWidth;
  final Color? imageBorderColor;
  final TextStyle extraCountTextStyle;
  final Color backgroundColor;
  final ImageSource? imageSource;
  final List<Widget> children;
  final double? widgetRadius;
  final int? widgetCount;
  final double? widgetBorderWidth;
  final Color? widgetBorderColor;
  final List<ImageProvider> providers;
  final bool showTotalCount;

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
    var images = <Widget>[];
    var widgets = <Widget>[];
    var providersImages = <Widget>[];
    int _size = children.length > 0 ? widgetCount! : imageCount!;
    if (imageList.isNotEmpty) {
      images.add(circularImage(imageList[0]));
    } else if (children.isNotEmpty) {
      widgets.add(circularWidget(children[0]));
    } else if (providers.isNotEmpty) {
      providersImages.add(circularProviders(providers[0]));
    }

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
                  right: 0.8 * imageRadius! * (index + 1.0),
                  child: circularImage(image),
                ),
              ))
          .values
          .toList());
    }
    if (children.length > 1) {
      if (children.length < _size) {
        _size = children.length;
      }
      widgets.addAll(children
          .sublist(1, _size)
          .asMap()
          .map((index, widget) => MapEntry(
                index,
                Positioned(
                  right: 0.8 * widgetRadius! * (index + 1.0),
                  child: circularWidget(widget),
                ),
              ))
          .values
          .toList());
    }
    if (providers.length > 1) {
      if (providers.length < _size) {
        _size = providers.length;
      }
      providersImages.addAll(providers
          .sublist(1, _size)
          .asMap()
          .map((index, data) => MapEntry(
                index,
                Positioned(
                  right: 0.8 * imageRadius! * (index + 1.0),
                  child: circularProviders(data),
                ),
              ))
          .values
          .toList());
    }
    int _renderedImageSize = images.length > 0
        ? images.length
        : children.length > 0 ? children.length : providersImages.length;
    return Container(
      child: Row(
        children: <Widget>[
          images.isNotEmpty || widgets.isNotEmpty || providersImages.isNotEmpty
              ? Stack(
                  clipBehavior: Clip.none, 
                  textDirection: TextDirection.rtl,
                  children: children.length > 0
                      ? widgets
                      : providers.length > 0 ? providersImages : images,
                )
              : SizedBox(),
          Container(
            margin: EdgeInsets.only(left: 5),
            child: totalCount - _renderedImageSize > 0
                ? showTotalCount
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
                            (totalCount - images.length).toString(),
                            textAlign: TextAlign.center,
                            style: extraCountTextStyle,
                          ),
                        ),
                      )
                    : SizedBox()
                : Container(),
          ),
        ],
      ),
    );
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
