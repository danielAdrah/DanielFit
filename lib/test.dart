import 'package:flutter/material.dart';

class TT extends StatelessWidget {
  const TT({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: [Text("first"), Text("second"), Text("third")]),
    );
  }
}
