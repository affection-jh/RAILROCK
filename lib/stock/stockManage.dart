import 'package:flutter/material.dart';
import 'package:railrock/stock/stockClass.dart';
import 'package:railrock/homePage.dart';
import 'package:railrock/searchPage.dart';
import 'package:railrock/stock/stockEnroll.dart';
import 'package:railrock/stock/stockDetailInfo.dart';

class Stockmanage extends StatefulWidget {
  const Stockmanage({super.key});

  @override
  State<Stockmanage> createState() => _StockmanageState();
}

List<Stock> displayStocks = stocks;
List<Color> colorInset = [
  Color.fromRGBO(118, 118, 118, 100),
  Color.fromRGBO(255, 80, 80, 100)
];

class _StockmanageState extends State<Stockmanage> {
  Color firstCo = colorInset[1];
  Color secCo = colorInset[0];
  Color thirdCo = colorInset[0];
  Color forthCo = colorInset[0];
  Color fifthCo = colorInset[0];

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

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
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SearchPage()));
                },
                icon: Icon(
                  Icons.search,
                  size: 30,
                )),
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Stockenroll()));
                },
                icon: Icon(
                  Icons.add,
                  size: 30,
                ))
          ],
        ),
        body: body(screenSize));
  }

  void updateStock() {
    setState(() {});
  }

  Widget body(Size screenSize) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(30, 15, 0, 0),
          child: Row(
            children: [
              GestureDetector(
                  onTap: () {
                    setState(() {
                      firstCo = colorInset[1];
                      secCo = colorInset[0];
                      thirdCo = colorInset[0];
                      forthCo = colorInset[0];
                      fifthCo = colorInset[0];
                      displayStocks = stocks;
                    });
                  },
                  child: Text("전체",
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          color: firstCo,
                          fontSize: 20))),
              SizedBox(
                width: 20,
              ),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      secCo = colorInset[1];
                      firstCo = colorInset[0];
                      thirdCo = colorInset[0];
                      forthCo = colorInset[0];
                      fifthCo = colorInset[0];
                      displayStocks = locomotive;
                    });
                  },
                  child: Text("기관차",
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 20,
                          color: secCo))),
              SizedBox(
                width: 20,
              ),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      thirdCo = colorInset[1];
                      secCo = colorInset[0];
                      firstCo = colorInset[0];
                      forthCo = colorInset[0];
                      fifthCo = colorInset[0];
                      displayStocks = passenger_car;
                    });
                  },
                  child: Text("객차",
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          color: thirdCo,
                          fontSize: 20))),
              SizedBox(
                width: 20,
              ),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      forthCo = colorInset[1];
                      thirdCo = colorInset[0];
                      secCo = colorInset[0];
                      firstCo = colorInset[0];
                      fifthCo = colorInset[0];
                      displayStocks = cargo_car;
                    });
                  },
                  child: Text("화차",
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          color: forthCo,
                          fontSize: 20))),
              SizedBox(
                width: 20,
              ),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      fifthCo = colorInset[1];
                      firstCo = colorInset[0];
                      secCo = colorInset[0];
                      thirdCo = colorInset[0];
                      forthCo = colorInset[0];
                      displayStocks = accessory;
                    });
                  },
                  child: Text("악세서리",
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          color: fifthCo,
                          fontSize: 20))),
              SizedBox(
                width: 20,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          height: screenSize.height * 0.7,
          child: ListView.builder(
            itemCount: displayStocks.length,
            itemBuilder: (context, index) {
              final carrier = displayStocks[index];
              return StockCard(
                currentStock: carrier,
                updateStock: updateStock,
              );
            },
          ),
        )
      ],
    );
  }
}

class StockCard extends StatefulWidget {
  final Stock currentStock;
  final updateStock;
  StockCard({
    required this.currentStock,
    required this.updateStock,
  });

  @override
  _StockCardState createState() => _StockCardState();
}

class _StockCardState extends State<StockCard> {
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    // double screenHight = screenSize.height;

    int percentage = calculatePercentage(
        widget.currentStock.stocks, widget.currentStock.neededStocks);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 10,
      child: Stack(children: [
        Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.1), //<-EdgeInsets.only(left: 150),
          width: screenWidth * 0.75,
          height: 160,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Text(
                  widget.currentStock.title,
                  style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5),
                ),
              ),
              SizedBox(
                height: 3,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center, //반응형의 핵심
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 5),
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 3, color: Color.fromRGBO(255, 80, 80, 100)),
                        borderRadius: BorderRadius.circular(500)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(500),
                      child: Image.asset(
                        widget.currentStock.imagePath,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ), //이미지
                  SizedBox(
                    width: screenWidth * 0.1,
                  ),
                  Container(
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.currentStock.stocks.toString(),
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w300),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "재고",
                              style: TextStyle(
                                color: Color.fromRGBO(118, 118, 118, 100),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: screenWidth * 0.09,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.currentStock.expectedToInStock.toString(),
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w300),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "입고중",
                              style: TextStyle(
                                color: Color.fromRGBO(118, 118, 118, 100),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          width: screenWidth * 0.07,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.currentStock.neededStocks.toString(),
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w300),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "필요재고",
                              style: TextStyle(
                                color: Color.fromRGBO(118, 118, 118, 100),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ) //재고정보
                ],
              ),
            ],
          ),
        ),
        Positioned(
          child: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StockInfo(
                            currentstock: widget.currentStock,
                            updateStock: widget.updateStock)));
              },
              icon: Icon(Icons.menu_open)),
          right: screenWidth * 0.03,
          top: 2,
        ),
        Positioned(
          right: screenWidth / 2 + 60 + 0.13 * screenWidth,
          top: 11,
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
            width: 50,
            height: 26,
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 80, 80, 100),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                percentage.toString() + "%",
                style: TextStyle(color: Colors.white, fontFamily: 'Pretendard'),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        )
      ]),
    );
  }
}

int calculatePercentage(int a, int b) {
  double percent = 0;
  percent = a / b * 100;
  if (percent > 100) percent = 100;
  return percent.toInt();
}