import 'package:flutter/material.dart';
import 'package:railrock/homePage.dart';
import 'package:railrock/dispatch/newOrderCard.dart';
import 'package:railrock/dispatch/newOrderClass.dart';

List<NewOrder> newOrdersList = [];
List<NewOrder> inTransitList = [];
List<NewOrder> displayList = [];

Color checkedColor = Color.fromRGBO(255, 80, 80, 100);
Color newOrderPageColor = const Color.fromARGB(180, 80, 80, 100);
Color inTransitPageColor = const Color.fromARGB(180, 80, 80, 100);
Color local_shipping_iconColor = const Color.fromARGB(180, 80, 80, 100);
Color defaultColor = const Color.fromARGB(180, 80, 80, 100);

class OutBound extends StatefulWidget {
  const OutBound({super.key});

  @override
  State<OutBound> createState() => _OutBoundState();
}

class _OutBoundState extends State<OutBound> {
  @override
  void initState() {
    newOrderPageColor = checkedColor;
    newOrdersList.add(NewOrder(
        name: '박미경',
        productName: '7400',
        qty: 1,
        tel: '010-7162-1979',
        date: '2025.01.03',
        paid: '결재완료',
        adress: '경기도 안양시 만안구 박달로 453 한라비발디 아파트 105동 503호(안앙시 만안구 호계동아님 한라비발디)',
        msg: '문앞에 배송해주세요',
        bookCode: '101-374-3495',
        tn: '336388849372945'));
    displayList = newOrdersList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => Homepage()));
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
      ),
      body: Stack(children: [
        Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: screenSize.width * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: screenSize.width * 0.02,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        inTransitPageColor =
                            const Color.fromARGB(180, 80, 80, 100);
                        newOrderPageColor = checkedColor;
                        displayList = newOrdersList;
                      });
                    },
                    child: Text(
                      "신규주문",
                      style: TextStyle(
                          color: newOrderPageColor,
                          fontFamily: 'Pretendard',
                          fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    width: screenSize.width * 0.03,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        inTransitPageColor = checkedColor;
                        newOrderPageColor =
                            const Color.fromARGB(180, 80, 80, 100);
                        displayList = inTransitList;
                      });
                    },
                    child: Text(
                      "배송중",
                      style: TextStyle(
                          color: inTransitPageColor,
                          fontFamily: 'Pretendard',
                          fontSize: 20),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: screenSize.height * 0.02,
            ),
            Container(
                height: screenSize.height * 0.6,
                child: ListView.builder(
                    itemCount: displayList.length,
                    itemBuilder: (context, index) {
                      return NewOrderCard(
                        checkedCheck: checkedCheck,
                        newOrder: displayList[index],
                      );
                    })),
          ],
        ),
        Positioned(
          bottom: screenSize.height * 0.03,
          right: screenSize.width * 0.05,
          child: inTransitPageColor == checkedColor
              ? Container()
              : IconButton(
                  onPressed: () async {
                    String tn;
                    if (local_shipping_iconColor == checkedColor) {
                      tn = await showTextField('운송장번호를 입력하세요');
                      if (tn != '') {
                        tnEnroll(tn);
                        setState(() {
                          local_shipping_iconColor = defaultColor;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("발송처리가 완료되었습니다")));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("올바른 운송장번호를 입력해주세요")));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("발송처리할 주문건을 선택해주세요"),
                      ));
                    }
                  },
                  icon: Icon(Icons.local_shipping),
                  iconSize: 40,
                  color: local_shipping_iconColor,
                ),
        )
      ]),
    );
  }

  Future<String> showTextField(String msg) {
    TextEditingController _textController = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(msg),
          actions: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(_textController.text);
                  },
                  child: Text('발송처리'),
                ),
                TextButton(
                  onPressed: () {
                    _textController.clear();
                    Navigator.of(context).pop();
                  },
                  child: Text('취소'),
                ),
              ],
            ),
          ],
        );
      },
    ).then((value) => value ?? '');
  }

  void checkedCheck() {
    bool isChecked = false;
    for (int i = 0; i < displayList.length; i++) {
      if (displayList[i].isChecked) {
        isChecked = true;
        break;
      }
    }
    setState(() {
      local_shipping_iconColor = isChecked ? checkedColor : defaultColor;
    });
  }

  void tnEnroll(String tn) {
    for (int i = 0; i < displayList.length; i++) {
      if (displayList[i].isChecked) {
        displayList[i].tn = tn;
        saveOrdersToFirebase(displayList[i]);
        inTransitList.add(displayList[i]);
        if (displayList[i].tn != '') {
          displayList.removeAt(i);
          newOrdersList
              .removeWhere((order) => order.name == displayList[i].name);
        }
      }
    }
  }
}
