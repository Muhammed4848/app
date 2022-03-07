import 'package:flutter/material.dart';

class HorizontalListWidget extends StatelessWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final double? spacing;
  final EdgeInsets? padding;
  final ScrollPhysics? physics;
  final bool reverse;

  HorizontalListWidget({
    required this.itemCount,
    required this.itemBuilder,
    this.spacing,
    this.padding,
    this.physics,
    this.reverse = false,
  }) : assert(itemBuilder != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        physics: physics,
        padding: padding ?? EdgeInsets.all(8),
        scrollDirection: Axis.horizontal,
        reverse: reverse,
        child: Wrap(
          spacing: spacing ?? 8,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          direction: Axis.horizontal,
          children: List.generate(itemCount, (index) => itemBuilder(context, index)),
        ),
      ),
    );
  }
}
