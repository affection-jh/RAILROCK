import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:railrock/homePage.dart';
import 'package:railrock/stock/stockManage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:railrock/stock/fireMethods.dart';
import 'stockClass.dart';

TextEditingController _textController = new TextEditingController();
Color defaultCol = Color.fromRGBO(118, 118, 118, 100);
Color enrolledCol = Color.fromRGBO(0, 0, 0, 0.886);
Color enrolledHighlitedColor = Color.fromRGBO(255, 80, 80, 100);

class Stockenroll extends StatefulWidget {
  final VoidCallback updateStock;
  const Stockenroll({required this.updateStock, super.key});
  @override
  State<Stockenroll> createState() => _StockenrollState();
}

class _StockenrollState extends State<Stockenroll> {
  late Uint8List imageByte;
  String imagePath = '';
  String category = "카테고리";
  String title = "상품이름";
  String result = '';
  String url = '';
  String imagecode = '';
  var needed_stock = "필요재고";
  var stocknum = "현재재고";

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
                          final Uint8List bytes = await image.readAsBytes();
                          setState(() {
                            imagePath = image.path;
                            imageByte = bytes;
                          });

                          url = await upLoadImages();
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
                                : kIsWeb
                                    ? Image.memory(imageByte)
                                    : Image.file(
                                        File(imagePath),
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
                              if (result != '') {
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
                              if (result != '') {
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
                        Stock stock = Stock(
                          category: category,
                          imageUrl: url,
                          imageCode: imagecode,
                          title: title,
                          trackingInfoList: [],
                          stocks: int.parse(stocknum),
                          expectedToInStock: 0,
                          neededStocks: int.parse(needed_stock),
                        );
                        saveStockToFirestore(stock);
                        allStocks.add(stock);
                        categorizeFromlastElement();

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

  Future<String> upLoadImages() async {
    final storageRef = FirebaseStorage.instance.ref();
    String url;
    String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    try {
      final imagesRef = storageRef.child('post').child(currentTime);
      imagecode = currentTime;

      kIsWeb
          ? await imagesRef.putData(imageByte)
          : await imagesRef.putFile(File(imagePath));

      url = await imagesRef.getDownloadURL();

      return url;
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') {
        print('파일을 찾을 수 없습니다');
        _showSnackbar('파일을 찾을 수 없습니다');
      } else if (e.code == 'unauthorized') {
        print('권한이 없습니다');
        _showSnackbar('파일 업로드 권한이 없습니다.');
      } else {
        print('오류 발생: ${e.message}');
        _showSnackbar('서버 오류: ${e.message}');
      }
      return '';
    }
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
