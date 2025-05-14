import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final Color? color;
  final double size;
  
  const LoadingIndicator({
    Key? key,
    this.color,
    this.size = 40.0,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          color: color ?? Theme.of(context).primaryColor,
          strokeWidth: 3.0,
        ),
      ),
    );
  }
}
