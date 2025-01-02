import 'package:flutter/material.dart';
import 'package:railrock/homePage.dart';
import 'package:railrock/stock/stockClass.dart';

List<Stock> newOrdersList = [];
List<Stock> verificatedList = [];
List<Stock> inTransitList = [];
List<Stock> DeliveredList = [];

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
      automaticallyImplyLeading: false,
      title: GestureDetector(
        onTap: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (BuildContext context) => Homepage()));
        },
        child: Text(
          "RAILROCK",
          style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 30,
              color: Colors.black,
              letterSpacing: 2,
              fontWeight: FontWeight.normal),
        ),
      ),
    ));
  }
}
