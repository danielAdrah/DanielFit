import 'package:flutter/material.dart';

class SmallCircluarBtn extends StatelessWidget {
  const SmallCircluarBtn({
    super.key,
    required this.colors,
    required this.icon,
    required this.onTap,
  });
  final List<Color> colors;
  final IconData icon;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 10,
              offset: Offset(0, 5),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15,
              offset: Offset(0, 8),
              spreadRadius: -3,
            ),
            BoxShadow(
              color: Colors.red.withOpacity(0.1),
              blurRadius: 6,
              offset: Offset(0, -3),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Center(child: Icon(icon, color: Colors.white, size: 25)),
      ),
    );
  }
}
