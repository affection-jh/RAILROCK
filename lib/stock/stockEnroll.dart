import 'package:railrock/stock/stockClass.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:railrock/homePage.dart';
import 'package:railrock/stock/stockManage.dart';

class Stockenroll extends StatefulWidget {
  const Stockenroll({super.key});
  @override
  State<Stockenroll> createState() => _StockenrollState();
}

TextEditingController _textController = new TextEditingController();

Color defaultCol = Color.fromRGBO(118, 118, 118, 100);
Color enrolledCol = Color.fromRGBO(0, 0, 0, 0.886);
Color enrolledHighlitedColor = Color.fromRGBO(255, 80, 80, 100);

class _StockenrollState extends State<Stockenroll> {
  String imagePath = '';
  String category = "카테고리";
  String title = "상품이름";
  var stocknum = "현재재고";
  int predicted_stock = 0;
  var needed_stock = "필요재고";
  String result = '';

  Color categoryColor = defaultCol;
  Color titleColor = defaultCol;
  Color neededStockColor = defaultCol;
  Color stockColor = defaultCol;
  Color buttonColor = defaultCol;
  Color imageBorderColor = defaultCol;
  Color enrolledImageBoarderColor = enrolledHighlitedColor;
  Color buttonEnrolledColer = enrolledHighlitedColor;

  var imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    //double screenHeight = screenSize.height;
    return Scaffold(
      appBar: AppBar(
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
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                  margin: EdgeInsets.fromLTRB(70, 0, 0, 0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "상품을 등록해주세요",
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 2),
                    ),
                  )),
              Container(
                width: screenWidth * 0.8,
                height: 300,
                margin: EdgeInsets.only(top: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        var image = await imagePicker.pickImage(
                            source: ImageSource.gallery);

                        if (image != null) {
                          setState(() {
                            imagePath = image.path;
                          });
                        }
                      },
                      child: Container(
                        width: screenWidth * 0.4,
                        height: screenWidth * 0.4,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: imageBorderColor,
                              width: 5,
                            ),
                            borderRadius: BorderRadius.circular(500)),
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(500),
                            ),
                            child: imagePath.isEmpty
                                ? Icon(Icons.add)
                                : kIsWeb // 웹일 때
                                    ? Image.network(imagePath)
                                    // 웹에서는 Image.network 사용
                                    : Image.file(
                                        File(imagePath), // 모바일에서는 Image.file 사용
                                        fit: BoxFit.cover,
                                      )),
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * 0.01,
                    ),
                    Container(
                      width: screenWidth * 0.3,
                      padding: EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              result = await _showCategotyDiaglog();
                              if (result != Null) {
                                setState(() {
                                  isCheckoutValid();
                                  category = result;
                                  categoryColor = enrolledCol;
                                  result = '';
                                });
                              }
                            },
                            child: Text(
                              category,
                              style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: 35,
                                  color: categoryColor),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              result = await _showAddDiaglog('상품이름');
                              if (result != Null) {
                                setState(() {
                                  title = result;
                                  titleColor = enrolledCol;
                                  result = '';
                                  isCheckoutValid();
                                });
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                title,
                                style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: 35,
                                    color: titleColor),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              result = await _showAddDiaglog('필요재고');
                              if (int.tryParse(result) != null &&
                                  int.parse(result) >= 0) {
                                setState(() {
                                  needed_stock = result;
                                  neededStockColor = enrolledCol;
                                  result = '';
                                  isCheckoutValid();
                                });
                              } else {
                                _showSnackbar("올바른 수량을 입력하세요");
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                needed_stock,
                                style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: 35,
                                    color: neededStockColor),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              result = await _showAddDiaglog('현재재고');
                              if (int.tryParse(result) != null &&
                                  int.parse(result) >= 0) {
                                setState(() {
                                  stocknum = result;
                                  stockColor = enrolledCol;
                                  result = '';
                                  isCheckoutValid();
                                });
                              } else {
                                _showSnackbar("올바른 수량을 입력하세요");
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                stocknum,
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: 35,
                                  color: stockColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 30,
            right: 30,
            child: IconButton(
                icon: Icon(
                  Icons.add,
                  size: 60,
                  color: buttonColor,
                ),
                onPressed: (buttonColor == buttonEnrolledColer)
                    ? () {
                        Stock stock = new Stock(
                            category: category,
                            imagePath: imagePath,
                            title: title,
                            stocks: int.parse(stocknum),
                            expectedToInStock: predicted_stock,
                            neededStocks: int.parse(needed_stock));
                        stocks.add(stock);
                        if (stock.category == "기관차")
                          locomotive.add(stock);
                        else if (stock.category == "객차")
                          passenger_car.add(stock);
                        else if (stock.category == "화차")
                          cargo_car.add(stock);
                        else if (stock.category == "악세서리") accessory.add(stock);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Stockmanage()));
                      }
                    : null),
          )
        ],
      ),
    );
  }

  void isCheckoutValid() {
    if (categoryColor != defaultCol &&
        titleColor != defaultCol &&
        neededStockColor != defaultCol &&
        stockColor != defaultCol) {
      setState(() {
        buttonColor = buttonEnrolledColer;
        imageBorderColor = buttonEnrolledColer;
      });
    }
  }

  Future<String> _showCategotyDiaglog() async {
    List<String> categories = ['기관차', "객차", "화차", "악세서리"];
    String? selectedCategory = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("카테고리선택"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: categories
                .map(
                  (option) => ListTile(
                    title: Text(option),
                    onTap: () {
                      Navigator.pop(context, option);
                    },
                  ),
                )
                .toList(),
          ),
        );
      },
    );
    if (selectedCategory == null) {
      throw Exception('카테고리가 선택되지 않았습니다.');
    }
    return selectedCategory;
  }

  Future<String> _showAddDiaglog(final String _msg) async {
    String msg = _msg;
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(msg),
          content: TextField(
            controller: _textController,
            decoration: InputDecoration(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("취소",
                  style:
                      TextStyle(color: Colors.black, fontFamily: 'Pretendard')),
            ),
            TextButton(
              onPressed: () {
                if (_textController.text.isNotEmpty) {
                  msg = _textController.text;
                  Navigator.of(context).pop(_textController.text);
                  setState(() {});
                }
              },
              child: Text(
                '추가',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    ).then((value) {
      _textController.clear();

      return value ?? Null;
    });
  }

  void _showSnackbar(String alertMessage) {
    final snackBar = SnackBar(
      content: Text(alertMessage),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
