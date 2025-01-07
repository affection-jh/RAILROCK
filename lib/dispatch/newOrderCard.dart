import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:railrock/dispatch/newOrderClass.dart';
import 'package:railrock/dispatch/outBound.dart';

class NewOrderCard extends StatefulWidget {
  final VoidCallback checkedCheck;
  final NewOrder newOrder;

  NewOrderCard({
    required this.checkedCheck,
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
              child: inTransitPageColor == checkedColor
                  ? Container()
                  : Checkbox(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      value: isChecked,
                      onChanged: (value) {
                        setState(() {
                          isChecked = value!;
                          if (isChecked) {
                            widget.newOrder.isChecked = true;

                            widget.checkedCheck();
                          } else {
                            widget.newOrder.isChecked = false;
                            widget.checkedCheck();
                          }
                          print('${isChecked}');
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
            height: screenSize.height * 0.006,
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
                      width: screenSize.width * 0.034,
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
                      width: screenSize.width * 0.034,
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
                      width: screenSize.width * 0.034,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                          onPressed: () {
                            Clipboard.setData(
                                    ClipboardData(text: widget.newOrder.tel))
                                .then((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  (SnackBar(
                                      content: Text("전화번호가 클립보드에 복사되었습니다"))));
                            });
                          },
                          child: Text(
                            widget.newOrder.tel,
                            style: TextStyle(color: Colors.black),
                          )),
                    ),
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
                      width: screenSize.width * 0.034,
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
                      width: screenSize.width * 0.034,
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
                        child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                          onPressed: () {
                            Clipboard.setData(
                                    ClipboardData(text: widget.newOrder.adress))
                                .then((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("주소가 클립보드에 복사되었습니다")),
                              );
                            });
                          },
                          child: Text(
                            widget.newOrder.adress,
                            style: TextStyle(color: Colors.black),
                            softWrap: true,
                          )),
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
                    Text(widget.newOrder.tn == ''
                        ? widget.newOrder.bookCode
                        : widget.newOrder.tn),
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
