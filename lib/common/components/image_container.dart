import 'package:clinic_medicines/common/styles/colors.dart';
import 'package:flutter/widgets.dart';

class ImageContainer extends StatelessWidget {
  final ImageProvider<Object> imageProvider;

  final double height;

  final double width;

  final BoxFit? boxFit;

  const ImageContainer({
    Key? key,
    required this.imageProvider,
    required this.width,
    required this.height,
    this.boxFit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.0,
          color: defaultColor.shade700, //Colors.blueGrey,
        ),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          fit: boxFit,
          image: imageProvider,
        ),
      ),
    );
  }
}
