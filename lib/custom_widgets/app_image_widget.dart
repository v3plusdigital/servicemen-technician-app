import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/app_colors.dart';

class AppImageWidget {
  Widget svgImage({
    required String imageName,
    double? width,
    double? height,
    Color? color,
  }) {
    return SvgPicture.asset(
      imageName,
      width: width,
      height: height,
      colorFilter: color != null
          ? ColorFilter.mode(color, BlendMode.srcIn)
          : null,
    );
  }

  Widget customNetworkImage({
    required double radius,
    Color? borderColor,
    double? borderWidth,
    bool? boxFit,
    BoxFit? boxFitVal,
    AlignmentGeometry? alignment,
    required String image,
    double? height,
    double? width,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: borderColor != null
            ? Border.all(color: borderColor, width: borderWidth ?? 1)
            : null,
      ),
      child: image.contains("http")
          ? ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: Image.network(
                image,
                fit: boxFit == false ? null : BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) {
                    return Center(
                      child: CircularProgressIndicator(
                        value: double.parse(
                          loadingProgress.cumulativeBytesLoaded.toString(),
                        ),
                      ),
                    );
                  }
                  return child;
                },
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error, color: AppColors.kBlack),
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: Image.asset(image,
                  fit: boxFitVal??BoxFit.cover, // 🔥 THIS IS THE FIX
                  alignment:alignment??Alignment.center,

              ),
            ),
    );
  }
}
