import 'package:flutter/material.dart';

extension WidgetLayouts on Widget {
  Widget wrapRow(List<Widget> widget) {
    return Row(
      children: [
        Expanded(child: this),
        ...widget.map((widget) => Expanded(child: widget))
      ],
    );
  }
}