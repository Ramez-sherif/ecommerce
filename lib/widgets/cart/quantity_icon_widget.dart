import 'package:flutter/material.dart';

class QuantityIcon extends StatefulWidget {
  QuantityIcon(
      {super.key,
      required this.onChangedQuantity,
      required this.iconColor,
      required this.backgroundColor,
      required this.icon});
  Function onChangedQuantity;
  final Color iconColor;
  final Color backgroundColor;
  final IconData icon;
  @override
  State<StatefulWidget> createState() => QuantityIconState();
}

class QuantityIconState extends State<QuantityIcon> {
  @override
  Widget build(BuildContext context) {
    
    return GestureDetector(
      onTap: () => widget.onChangedQuantity(),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration:  BoxDecoration(
          color: widget.backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          widget.icon,
          color: widget.iconColor,
          size: 15,
        ),
      ),
    );
  }
}
