import 'package:flutter/material.dart';
import 'package:railrock/stock/fireMethods.dart';
import 'package:railrock/stock/stockManage.dart';
import 'package:railrock/stock/trackingUI.dart';
import 'package:railrock/stock/trackingInfoUpdate.dart';
import 'stockClass.dart';
import 'package:railrock/stock/trackingInfoEnroll.dart';

TextEditingController _textController = TextEditingController();

class StockInfo extends StatefulWidget {
  final Stock currentstock;
  final VoidCallback updateScreen;

  const StockInfo(
      {Key? key, required this.currentstock, required this.updateScreen})
      : super(key: key);
  @override
  State<StockInfo> createState() => _StockInfoState();
}

class _StockInfoState extends State<StockInfo> {
  int changedValue = -1;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => Stockmanage()));
          },
        ),
        title: Center(
          child: Text(
            widget.currentstock.title,
            style: TextStyle(
                color: Color.fromRGBO(0, 0, 0, 1),
                fontFamily: 'Pretendard',
                fontSize: 28,
                fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('상품을 삭제하시겠습니까?'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                deleteStock(widget.currentstock);
                                allStocks.remove(widget.currentstock);
                                switch (widget.currentstock.category) {
                                  case '기관차':
                                    locomotive.remove(widget.currentstock);
                                    break;
                                  case '객차':
                                    passenger_car.remove(widget.currentstock);
                                    break;
                                  case '화차':
                                    cargo_car.remove(widget.currentstock);
                                    break;
                                  default:
                                    accessory.remove(widget.currentstock);
                                }
                                Navigator.of(context).pop();
                                updateStock(widget.currentstock);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Stockmanage()));
                                _showSnackbar('삭제되었습니다');
                              },
                              child: Text('삭제')),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('취소'))
                        ],
                      );
                    });
              },
              icon: Icon(Icons.remove))
        ],
      ),
      body: Column(
        children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () async {
                    changedValue =
                        await _showQtyChangeDialog(widget.currentstock.stocks);
                    if (changedValue != -1) {
                      setState(() {
                        widget.currentstock.stocks = changedValue;
                        updateStock(widget.currentstock);
                        changedValue = -1;
                      });
                    }
                  },
                  child: Column(
                    children: [
                      Text(
                        widget.currentstock.stocks.toString(),
                        style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontFamily: 'Pretendard',
                            fontSize: 34,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "재고",
                        style: TextStyle(
                          color: Color.fromRGBO(118, 118, 118, 100),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    changedValue = await _showQtyChangeDialog(
                        widget.currentstock.expectedToInStock);
                    if (changedValue != -1) {
                      setState(() {
                        widget.currentstock.expectedToInStock = changedValue;
                        updateStock(widget.currentstock);
                        changedValue = -1;
                      });
                    }
                  },
                  child: Column(
                    children: [
                      Text(
                        widget.currentstock.expectedToInStock.toString(),
                        style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontFamily: 'Pretendard',
                            fontSize: 34,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "입고중",
                        style: TextStyle(
                          color: Color.fromRGBO(118, 118, 118, 100),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    changedValue = await _showQtyChangeDialog(
                        widget.currentstock.neededStocks);
                    if (changedValue != -1) {
                      setState(() {
                        widget.currentstock.neededStocks = changedValue;

                        updateStock(widget.currentstock);
                        changedValue = -1;
                      });
                    }
                  },
                  child: Column(
                    children: [
                      Text(
                        widget.currentstock.neededStocks.toString(),
                        style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontFamily: 'Pretendard',
                            fontSize: 34,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "필요재고",
                        style: TextStyle(
                          color: Color.fromRGBO(118, 118, 118, 100),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: screenSize.height * 0.03),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: screenSize.width * 0.05,
              ),
              Text(
                textAlign: TextAlign.end,
                "입고 처리 & 발주 정보",
                style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 12),
            child: Stack(children: [
              Center(
                child: Container(
                  width: screenSize.width * 0.9,
                  height: screenSize.height * 0.3,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(236, 234, 234, 1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              Center(
                  child: Container(
                width: screenSize.width * 0.85,
                height: screenSize.height * 0.27,
                child: ListView(
                  children: [
                    for (int i = 0;
                        i < widget.currentstock.trackingInfoList.length;
                        i++)
                      ShippingCard(
                          updateScreen: updateScreen,
                          currentStock: widget.currentstock,
                          orderedQty: int.parse(widget
                              .currentstock.trackingInfoList[i].qtyOfOrder),
                          orderNumber: widget
                              .currentstock.trackingInfoList[i].orderNumber,
                          orderDate:
                              widget.currentstock.trackingInfoList[i].orderDate,
                          trackingNumber: widget
                              .currentstock.trackingInfoList[i].trackingNumber)
                  ],
                ),
              )),
              Positioned(
                bottom: screenSize.height * 0.015,
                right: screenSize.width * 0.07,
                child: IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                trackinInfoEnroll(
                                    currentStock: widget.currentstock,
                                    updateScreen: updateScreen)));
                  },
                  icon: Icon(Icons.add),
                  iconSize: 35,
                ),
              )
            ]),
          )
        ],
      ),
    );
  }

  Future<int> _showQtyChangeDialog(int qty) async {
    final String result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("수량변경"),
            actions: [
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                    hintText: qty.toString(),
                    hintStyle:
                        TextStyle(color: Color.fromARGB(118, 178, 178, 178))),
                keyboardType: TextInputType.number,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("취소")),
              TextButton(
                  onPressed: () {
                    updateStock(widget.currentstock);
                    Navigator.of(context).pop(_textController.text);
                    _showSnackbar('변경되었습니다.');
                  },
                  child: Text("변경"))
            ],
          );
        });
    _textController.clear();
    if (result.isNotEmpty) {
      return int.tryParse(result) ?? -1;
    }
    return -1;
  }

  void updateScreen() {
    setState(() {});
  }

  void _showSnackbar(String alertMessage) {
    final snackBar = SnackBar(
      content: Text(alertMessage),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class ShippingCard extends StatefulWidget {
  final VoidCallback updateScreen;
  final int orderedQty;
  final Stock currentStock;
  final String orderNumber;
  final String orderDate;
  final String trackingNumber;

  ShippingCard({
    required this.updateScreen,
    required this.currentStock,
    required this.orderedQty,
    required this.orderNumber,
    required this.orderDate,
    required this.trackingNumber,
  });

  @override
  _ShippingCardState createState() => _ShippingCardState();
}

class _ShippingCardState extends State<ShippingCard> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        if (widget.trackingNumber != '') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  TrackingUI(trackingNum: widget.trackingNumber),
            ),
          );
        } else {
          _showSnackbar('운송장번호를 등록해주세요');
        }
        print('onTap');
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Color.fromRGBO(110, 106, 106, 100),
        elevation: 18,
        child: Container(
            padding: EdgeInsets.all(3),
            child: Stack(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 2,
                        ),
                        Text('Qty.',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Pretendard',
                                fontSize: 12,
                                fontWeight: FontWeight.w100)),
                        Text(widget.orderedQty.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Pretendard',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            )),
                        SizedBox(
                          height: 4,
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 2,
                        ),
                        Text('No.',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Pretendard',
                                fontSize: 12,
                                fontWeight: FontWeight.w100)),
                        Text(widget.orderNumber,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Pretendard',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            )),
                        SizedBox(
                          height: 4,
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 2,
                        ),
                        Text('Date.',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Pretendard',
                                fontSize: 12,
                                fontWeight: FontWeight.w100)),
                        Text(widget.orderDate,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Pretendard',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            )),
                        SizedBox(
                          height: 4,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: screenSize.width * 0.26,
                  ),
                ],
              ),
              Positioned(
                right: screenSize.width * 0.14,
                top: screenSize.height * 0.007,
                child: ElevatedButton(
                  onPressed: () {
                    String targetOrderNumber = widget.orderNumber;
                    String targetOrderDate = widget.orderDate;
                    for (int i = 0;
                        i < widget.currentStock.trackingInfoList.length;
                        i++) {
                      if (widget.currentStock.trackingInfoList[i].orderNumber ==
                              targetOrderNumber &&
                          widget.currentStock.trackingInfoList[i].orderDate ==
                              targetOrderDate) {
                        setState(() {
                          int increaseStock = int.parse(widget
                              .currentStock.trackingInfoList[i].qtyOfOrder);
                          widget.currentStock.expectedToInStock -=
                              increaseStock;
                          widget.currentStock.stocks += increaseStock;
                          deleteShippingCard(widget.currentStock.title, i);
                          widget.currentStock.trackingInfoList.removeAt(i);
                          widget.updateScreen();
                          _showSnackbar('입고되었습니다.');
                        });
                        targetOrderNumber = '';
                        targetOrderDate = '';
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 255, 96, 96), // 배경 색상
                    foregroundColor: Colors.white, // 텍스트 색상
                  ),
                  child: Text(
                    '입고',
                    style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w200,
                        fontSize: 17),
                  ),
                ),
              ),
              Positioned(
                  right: screenSize.width * 0.07,
                  top: screenSize.height * 0.002,
                  child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    trackingInfoUpdate(
                                        currentStock: widget.currentStock,
                                        updateScreen: updateScreen,
                                        currentNumber: widget.orderNumber,
                                        currentDate: widget.orderDate)));
                      },
                      icon: Icon(Icons.edit))),
              Positioned(
                right: screenSize.width * 0.01,
                top: screenSize.height * 0.002,
                child: IconButton(
                    onPressed: () {
                      String targetOrderNumber = widget.orderNumber;
                      String targetOrderDate = widget.orderDate;
                      for (int i = 0;
                          i < widget.currentStock.trackingInfoList.length;
                          i++) {
                        if (widget.currentStock.trackingInfoList[i]
                                    .orderNumber ==
                                targetOrderNumber &&
                            widget.currentStock.trackingInfoList[i].orderDate ==
                                targetOrderDate) {
                          setState(() {
                            deleteShippingCard(widget.currentStock.title, i);
                            int increaseStock = int.parse(widget
                                .currentStock.trackingInfoList[i].qtyOfOrder);
                            widget.currentStock.expectedToInStock -=
                                increaseStock;
                            widget.currentStock.trackingInfoList.removeAt(i);

                            widget.updateScreen();
                            _showSnackbar('삭제되었습니다.');
                          });
                          targetOrderDate = '';
                          targetOrderNumber = '';
                        }
                      }
                    },
                    icon: Icon(Icons.delete_forever)),
              )
            ])),
      ),
    );
  }

  void _showSnackbar(String alertMessage) {
    final snackBar = SnackBar(
      content: Text(alertMessage),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void updateScreen() {
    setState(() {});
  }
}
