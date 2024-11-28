import 'package:flutter/material.dart';

class WaterfallFlowView extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double crossAxisSpacing;
  final int crossAxisCount;

  const WaterfallFlowView({
    super.key,
    required this.children,
    this.spacing = 8.0,
    this.crossAxisSpacing = 8.0,
    this.crossAxisCount = 2,
  });

  @override
  Widget build(BuildContext context) {
    final columnHeights = List.generate(crossAxisCount, (_) => 0.0);

    final columns = List.generate(
      crossAxisCount,
      (_) => <Widget>[],
    );

    for (var child in children) {
      final shortestColumnIndex = columnHeights.indexOf(columnHeights.reduce((a, b) => a < b ? a : b));
      final height = _getChildHeight(child);
      columnHeights[shortestColumnIndex] += height + spacing;
      columns[shortestColumnIndex].add(Padding(
        padding: EdgeInsets.only(bottom: spacing),
        child: child,
      ));
    }

    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          crossAxisCount,
          (index) => Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: columns[index],
            ),
          ),
        ),
      ),
    );
  }

  double _getChildHeight(Widget child) {
    // Estimate height for children based on provided constraints
    // This is an approximation. You can adjust this logic.
    return 200; // Default placeholder for height.
  }
}