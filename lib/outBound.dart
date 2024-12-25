import 'package:flutter/material.dart';

class OutBound extends StatefulWidget {
  const OutBound({super.key});

  @override
  State<OutBound> createState() => _OutBoundState();
}

class _OutBoundState extends State<OutBound> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "RAILROCK",
          style: TextStyle(
              fontFamily: 'Pretendard', fontSize: 30, letterSpacing: 2),
        ),
      ),
    );
  }
}
