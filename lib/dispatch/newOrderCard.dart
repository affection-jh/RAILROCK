import 'package:flutter/material.dart';
import 'package:railrock/dispatch/newOrderClass.dart';

class NewOrderCard extends StatefulWidget {
  final NewOrder newOrder;
  NewOrderCard({
    required this.newOrder,
  });
  @override
  _NewOrderCardState createState() => _NewOrderCardState();
}

class _NewOrderCardState extends State<NewOrderCard> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 11,
      child: Column(
        children: [
          Stack(children: [
            Container(
              margin: EdgeInsets.only(top: 5),
              child: Center(
                child: Text(
                  "7400",
                  style: TextStyle(
                      fontFamily: "Pretendard",
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ),
            ),
            Positioned(
              child: Checkbox(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                value: isChecked,
                onChanged: (value) {
                  setState(() {
                    isChecked = value!;
                    widget.newOrder.isChecked = isChecked;
                  });
                },
                activeColor: Color.fromRGBO(255, 80, 80, 100),
                checkColor: Colors.white,
              ),
              top: 10,
              left: 10,
            ),
          ]),
          SizedBox(
            height: screenSize.height * 0.005,
          ),
          Container(
            margin: EdgeInsets.only(
                left: screenSize.width * 0.03,
                bottom: screenSize.height * 0.008),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'qty.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          letterSpacing: 2,
                          color: const Color.fromARGB(180, 80, 80, 100)),
                    ),
                    SizedBox(
                      width: screenSize.width * 0.02,
                    ),
                    Text(widget.newOrder.qty.toString())
                  ],
                ),
                SizedBox(
                  height: screenSize.height * 0.005,
                ),
                Row(
                  children: [
                    Text(
                      'nme.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          letterSpacing: 0.06,
                          color: const Color.fromARGB(180, 80, 80, 100)),
                    ),
                    SizedBox(
                      width: screenSize.width * 0.02,
                    ),
                    Text(widget.newOrder.name)
                  ],
                ),
                SizedBox(
                  height: screenSize.height * 0.005,
                ),
                Row(
                  children: [
                    Text(
                      'tel.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          letterSpacing: 3.2,
                          color: const Color.fromARGB(180, 80, 80, 100)),
                    ),
                    SizedBox(
                      width: screenSize.width * 0.02,
                    ),
                    Text(widget.newOrder.tel)
                  ],
                ),
                SizedBox(
                  height: screenSize.height * 0.005,
                ),
                Row(
                  children: [
                    Text(
                      'dat.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          letterSpacing: 2,
                          color: const Color.fromARGB(180, 80, 80, 100)),
                    ),
                    SizedBox(
                      width: screenSize.width * 0.02,
                    ),
                    Text(widget.newOrder.date)
                  ],
                ),
                SizedBox(
                  height: screenSize.height * 0.005,
                ),
                Row(
                  children: [
                    Text(
                      'pay.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          letterSpacing: 1.3,
                          color: const Color.fromARGB(180, 80, 80, 100)),
                    ),
                    SizedBox(
                      width: screenSize.width * 0.02,
                    ),
                    Text(widget.newOrder.paid)
                  ],
                ),
                SizedBox(height: screenSize.height * 0.01),
                Row(
                  children: [
                    Text(
                      'ads.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          letterSpacing: 1.6,
                          color: const Color.fromARGB(180, 80, 80, 100)),
                    ),
                    SizedBox(
                      width: screenSize.width * 0.02,
                    ),
                    Expanded(
                        child: Text(
                      widget.newOrder.adress,
                      softWrap: true,
                    ))
                  ],
                ),
                SizedBox(
                  height: screenSize.height * 0.01,
                ),
                Row(children: [
                  Text(
                    'msg.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        letterSpacing: 0.4,
                        color: const Color.fromARGB(180, 80, 80, 100)),
                  ),
                  SizedBox(
                    width: screenSize.width * 0.02,
                  ),
                  Text(widget.newOrder.msg),
                ]),
                SizedBox(
                  height: screenSize.height * 0.003,
                ),
                Row(
                  children: [
                    Text(
                      'gsc.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          letterSpacing: 2,
                          color: const Color.fromARGB(180, 80, 80, 100)),
                    ),
                    SizedBox(
                      width: screenSize.width * 0.02,
                    ),
                    Text(widget.newOrder.bookCode),
                    SizedBox(
                      width: screenSize.width * 0.002,
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.edit,
                          size: 16,
                        ))
                  ],
                ),
                SizedBox(
                  height: screenSize.height * 0.01,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
