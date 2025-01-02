import 'package:flutter/material.dart';
import 'package:railrock/homePage.dart';
import 'package:railrock/stock/stockClass.dart';
import 'package:railrock/stock/fireMethods.dart';
import 'package:railrock/stock/stockDetailInfo.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

List<Color> colorInset = [
  Color.fromRGBO(118, 118, 118, 100),
  Colors.black,
  Color.fromRGBO(255, 80, 80, 100)
];

class trackingInfoUpdate extends StatefulWidget {
  final Stock currentStock;
  final VoidCallback updateScreen;
  late String currentNumber;
  late String currentDate;

  trackingInfoUpdate(
      {required this.currentStock,
      required this.updateScreen,
      required this.currentNumber,
      required this.currentDate,
      super.key});

  @override
  State<trackingInfoUpdate> createState() => _trackinInfoUpdateState();
}

String result = '';
String qtyOfOrder = '';
String orderNumber = '';
String orderCost = '';
String orderDate = '';
String trackingNumber = '';

Color qtyOfOrderCol = colorInset[0];
Color orderNumberCol = colorInset[0];
Color orderCostCol = colorInset[0];
Color orderDateCol = colorInset[0];
Color trackingNumberCol = colorInset[0];
Color buttonColor = colorInset[0];

int originalExpectedNum = 0;

class _trackinInfoUpdateState extends State<trackingInfoUpdate> {
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    int index = _findCurrentCardIndex(widget.currentNumber, widget.currentDate);
    originalExpectedNum = widget.currentStock.expectedToInStock;
    if (index != -1) {
      _initializeTexts(index, widget.currentStock);
      _initializeColors();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    int index = _findCurrentCardIndex(widget.currentNumber, widget.currentDate);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              widget.currentStock.expectedToInStock =
                  widget.currentStock.expectedToInStock -
                      originalExpectedNum +
                      int.parse(qtyOfOrder);
              widget.updateScreen();
              updateStock(widget.currentStock);

              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => StockInfo(
                          currentstock: widget.currentStock,
                          updateScreen: updateScreen)));
            },
            icon: Icon(Icons.arrow_back)),
        title: GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Homepage()));
          },
          child: Text(
            'RAILROCK',
            style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.normal,
                fontSize: 30,
                letterSpacing: 2),
          ),
        ),
      ),
      body: Center(
        child: Stack(children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: screenSize.width * 0.07,
                  ),
                  Text(
                    widget.currentStock.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '의 발주정보를 수정해주세요',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  )
                ],
              ),
              SizedBox(
                height: screenSize.height * 0.08,
              ),
              GestureDetector(
                onTap: () async {
                  result = await _showEnrollDialog('주문수량');
                  if (result != '' &&
                      int.tryParse(result) != null &&
                      int.parse(result) >= 0) {
                    setState(() {
                      qtyOfOrder = result;
                      qtyOfOrderCol = colorInset[1];
                      widget.currentStock.trackingInfoList[index].qtyOfOrder =
                          qtyOfOrder;

                      updateStock(widget.currentStock);

                      _showSnackbar('변경되었습니다');
                      result = '';
                    });
                  } else {
                    _showSnackbar('유효한 값을 입력하세요');
                  }
                },
                child: Column(
                  children: [
                    Text(
                      qtyOfOrder,
                      style: TextStyle(
                          color: qtyOfOrderCol,
                          fontFamily: 'Pretendard',
                          fontSize: 34,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "주문수량",
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w300,
                        color: Color.fromRGBO(0, 0, 0, 1),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenSize.height * 0.05,
              ),
              GestureDetector(
                onTap: () async {
                  result = await _showEnrollDialog('주문번호');
                  if (result != '') {
                    setState(() {
                      orderNumber = result;
                      orderNumberCol = colorInset[1];
                      widget.currentStock.trackingInfoList[index].orderNumber =
                          orderNumber;

                      updateStock(widget.currentStock);
                      widget.currentNumber = orderNumber;
                      index = _findCurrentCardIndex(
                          widget.currentNumber, widget.currentDate);

                      result = '';
                      _showSnackbar('변경되었습니다');
                    });
                  } else {
                    _showSnackbar('유효한 값을 입력하세요');
                  }
                },
                child: Column(
                  children: [
                    Text(
                      orderNumber,
                      style: TextStyle(
                          color: orderNumberCol,
                          fontFamily: 'Pretendard',
                          fontSize: 34,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "주문번호",
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w300,
                        color: Color.fromRGBO(0, 0, 0, 1),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenSize.height * 0.05,
              ),
              GestureDetector(
                onTap: () async {
                  result = await _showEnrollDialog('주문가격');
                  if (result != '' &&
                      int.tryParse(result) != null &&
                      int.parse(result) >= 0) {
                    setState(() {
                      orderCost = result;
                      orderCostCol = colorInset[1];
                      widget.currentStock.trackingInfoList[index].orderCost =
                          orderCost;

                      updateStock(widget.currentStock);

                      result = '';
                      _showSnackbar('변경되었습니다');
                    });
                  } else {
                    _showSnackbar('유효한 값을 입력하세요');
                  }
                },
                child: Column(
                  children: [
                    Text(
                      orderCost,
                      style: TextStyle(
                          color: orderCostCol,
                          fontFamily: 'Pretendard',
                          fontSize: 34,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "주문가격",
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w300,
                        color: Color.fromRGBO(0, 0, 0, 1),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenSize.height * 0.05,
              ),
              GestureDetector(
                onTap: () async {
                  result = await _showEnrollDialog('주문날짜');
                  if (result != '') {
                    setState(() {
                      orderDate = result;
                      orderDateCol = colorInset[1];
                      widget.currentStock.trackingInfoList[index].orderDate =
                          orderDate;
                      updateStock(widget.currentStock);
                      widget.currentDate = orderDate;
                      index = _findCurrentCardIndex(
                          widget.currentNumber, widget.currentDate);
                      widget.currentDate = orderDate;

                      result = '';
                      _showSnackbar('변경되었습니다');
                    });
                  } else {
                    _showSnackbar('유효한 값을 입력하세요');
                  }
                },
                child: Column(
                  children: [
                    Text(
                      orderDate,
                      style: TextStyle(
                          color: orderDateCol,
                          fontFamily: 'Pretendard',
                          fontSize: 34,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "주문날짜",
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w300,
                        color: Color.fromRGBO(0, 0, 0, 1),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenSize.height * 0.05,
              ),
              GestureDetector(
                onTap: () async {
                  result = await _showEnrollDialog('송장번호');
                  if (result != '' && result != trackingNumber) {
                    trackerEnroll(result);
                    setState(() {
                      trackingNumber = result;
                      trackingNumberCol = colorInset[1];
                      widget.currentStock.trackingInfoList[index]
                          .trackingNumber = trackingNumber;
                      updateStock(widget.currentStock);
                      _showSnackbar('변경되었습니다');
                      result = '';
                    });
                  } else {
                    _showSnackbar('유효한 값을 입력하세요');
                  }
                },
                child: Column(
                  children: [
                    Text(
                      trackingNumber,
                      style: TextStyle(
                          color: trackingNumberCol,
                          fontFamily: 'Pretendard',
                          fontSize: 34,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "송장번호",
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w300,
                        color: Color.fromRGBO(0, 0, 0, 1),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ]),
      ),
    );
  }

  void updateScreen() {
    setState(() {});
  }

  void trackerEnroll(String tn) async {
    setState(() {
      isLoading = true;
    });
    Dio dio = Dio();
    String trackerEnroll = 'https://api.ship24.com/public/v1/trackers';

    String? myKey = dotenv.env['ship24_KEY'];

    Map<String, dynamic> requestData = {
      "trackingNumber": tn,
      "shipmentReference": null,
      "clientTrackerId": null,
      "originCountryCode": null,
      "destinationCountryCode": null,
      "destinationPostCode": null,
      "shippingDate": null,
      "courierCode": null,
      "courierName": null,
      "trackingUrl": null,
      "orderNumber": null,
      "settings": {
        "restrictTrackingToCourierCode": true,
      }
    };
    Navigator.of(context).pop(tn);
    try {
      Response response = await dio.post(
        trackerEnroll,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': myKey,
            'Content-Type': 'application/json',
          },
        ),
        data: requestData,
      );
      setState(() {
        isLoading = false;
      });
      print('Response: ${response.data}');
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
      _showSnackbar('운송장번호를 다시 확인해주세요');
    }
  }

  Future<String> _showEnrollDialog(String msg) async {
    TextEditingController _textController = TextEditingController();
    return await showDialog<String>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(title: Text(msg), actions: [
                TextField(
                  controller: _textController,
                  decoration: InputDecoration(),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(_textController.text);
                      _textController.clear();
                    },
                    child: Text("변경")),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop('');
                    },
                    child: Text('취소')),
              ]);
            }) ??
        '';
  }

  void _showSnackbar(String alertMessage) {
    final snackBar = SnackBar(
      content: Text(alertMessage),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _initializeTexts(int i, Stock currentStock) {
    result = '';
    qtyOfOrder = currentStock.trackingInfoList[i].qtyOfOrder;
    orderNumber = currentStock.trackingInfoList[i].orderNumber;
    orderCost = currentStock.trackingInfoList[i].orderCost;
    orderDate = currentStock.trackingInfoList[i].orderDate;
    trackingNumber = currentStock.trackingInfoList[i].trackingNumber;
  }

  void _initializeColors() {
    qtyOfOrderCol = colorInset[0];
    orderNumberCol = colorInset[0];
    orderCostCol = colorInset[0];
    orderDateCol = colorInset[0];
    trackingNumberCol = colorInset[0];
    buttonColor = colorInset[0];
  }

  int _findCurrentCardIndex(String a, String b) {
    for (int i = 0; i < widget.currentStock.trackingInfoList.length; i++) {
      if (widget.currentStock.trackingInfoList[i].orderNumber == a &&
          widget.currentStock.trackingInfoList[i].orderDate == b) {
        return i;
      }
    }
    return -1;
  }
}
