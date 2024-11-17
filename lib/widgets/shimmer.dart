import 'package:flutter/material.dart';
import 'package:kiind_web/core/util/extensions/buildcontext_extensions.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class LoadingTile extends StatelessWidget {
  final bool? filled;
  final List<LoadingText> styles;
  final List<LoadingText>? trailingStyles;
  final double? leadingSize, trailingSize;
  final bool rounded;
  final EdgeInsetsGeometry? margin, padding;
  final CrossAxisAlignment crossAxisAlignment;

  const LoadingTile({
    Key? key,
    this.filled = false,
    this.styles = const [],
    this.leadingSize,
    this.trailingStyles,
    this.margin,
    this.padding,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.trailingSize,
    this.rounded = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ??
          EdgeInsets.symmetric(
            vertical: context.h(1.84729064),
          ),
      padding: padding ??
          EdgeInsets.symmetric(
            vertical: context.h(1.84729064),
            horizontal: context.w(05.340453939),
          ),
      decoration: BoxDecoration(
        color: filled! ? Colors.grey : Colors.white,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          if (leadingSize != null)
            Container(
              width: leadingSize,
              height: leadingSize,
              margin: EdgeInsetsDirectional.only(end: context.w(07)),
              child: LuneShimmer(rounded: rounded),
            ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: styles
                        .map(
                          (textConfig) => TextShimmer(
                            textConfig: textConfig,
                          ),
                        )
                        .toList(),
                  ),
                ),
                if ((trailingStyles ?? []).isNotEmpty)
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: trailingStyles!
                          .map(
                            (text) => LayoutBuilder(
                              builder: (context, constraints) {
                                return Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2.5),
                                  width: text.width * constraints.maxWidth,
                                  child: Shimmer(
                                    duration: const Duration(
                                        milliseconds: 750), //Default value
                                    color: Colors.black, //Default value
                                    colorOpacity: 0, //Default value
                                    child: Text(
                                      '',
                                      style: text.style.copyWith(height: 1),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
              ],
            ),
          ),
          if (trailingSize != null)
            Container(
              width: trailingSize,
              height: trailingSize,
              margin: EdgeInsetsDirectional.only(start: context.w(7)),
              child: LuneShimmer(rounded: rounded),
            ),
        ],
      ),
    );
  }
}

class LuneShimmer extends StatelessWidget {
  final bool rounded;

  const LuneShimmer({
    Key? key,
    this.rounded = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return rounded
        ? const ClipOval(
            child: BareShimmer(),
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const BareShimmer(),
          );
  }
}

class BareShimmer extends StatelessWidget {
  const BareShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: const Duration(milliseconds: 750), //Default value
      // interval: Duration(
      //     seconds: 0), //Default value: Duration(seconds: 0)
      color: Colors.black,
      colorOpacity: 0,
      child: Container(),
    );
  }
}

class TextShimmer extends StatelessWidget {
  final LoadingText textConfig;
  const TextShimmer({
    Key? key,
    required this.textConfig,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 2.5),
          width: textConfig.width * constraints.maxWidth,
          child: Shimmer(
            duration: const Duration(milliseconds: 750), //Default value
            // interval: Duration(
            //     seconds: 0), //Default value: Duration(seconds: 0)
            color: Colors.black, //Default value
            colorOpacity: 0, //Default value
            // enabled: true, //Default value
            // direction: ShimmerDirection.fromLTRB(),
            child: Text(
              '',
              style: textConfig.style.copyWith(height: 1),
              textAlign: textConfig.textAlign,
              textScaleFactor: textConfig.textScaleFactor,
            ),
          ),
        );
      },
    );
  }
}

class LoadingText {
  late final double width;
  late final TextStyle style;
  late final TextAlign? textAlign;
  late final double? textScaleFactor;

  LoadingText({
    this.width = .75,
    required this.style,
    this.textAlign = TextAlign.start,
    this.textScaleFactor,
  });
}
