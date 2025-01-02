import 'package:flutter/material.dart';
import 'package:railrock/stock/stockClass.dart';
import 'package:railrock/homePage.dart';
import 'package:railrock/searchPage.dart';
import 'package:railrock/stock/stockEnroll.dart';
import 'package:railrock/stock/stockDetailInfo.dart';
import 'package:cached_network_image/cached_network_image.dart';

List<Stock> displayStocks = allStocks; // Main List
List<Color> colorInset = [
  //Color List
  Color.fromRGBO(118, 118, 118, 100),
  Color.fromRGBO(255, 80, 80, 100)
];

class Stockmanage extends StatefulWidget {
  const Stockmanage({super.key});

  @override
  State<Stockmanage> createState() => _StockmanageState();
}

class _StockmanageState extends State<Stockmanage> {
  @override
  void initState() {
    super.initState();
    updateScreen();
  }

  void updateScreen() {
    setState(() {});
  }

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
          automaticallyImplyLeading: false,
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Stockenroll(updateStock: updateScreen)));
                },
                icon: Icon(
                  Icons.add,
                  size: 30,
                ))
          ],
        ),
        body: Container(child: body(screenSize)));
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
                      displayStocks = allStocks;
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
                updateStock: updateScreen,
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
  const StockCard({
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
              Text(
                widget.currentStock.title,
                style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5),
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
                            width: 3, color: imageBoarderColor(percentage)),
                        borderRadius: BorderRadius.circular(500)),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(500),
                        child: widget.currentStock.imageUrl == ''
                            ? Image.asset(
                                'assets/images/ssong.png',
                                fit: BoxFit.cover,
                              )
                            : CachedNetworkImage(
                                imageUrl: widget.currentStock.imageUrl,
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              )),
                  ), //이미지
                  SizedBox(
                    width: screenWidth * 0.1,
                  ),
                  Row(
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
                            updateScreen: widget.updateStock)));
              },
              icon: Icon(Icons.menu)),
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
              color: imageBoarderColor(percentage),
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

Color imageBoarderColor(int percentage) {
  if (90 < percentage) {
    return const Color.fromARGB(255, 47, 179, 27);
  } else if (60 < percentage) {
    return Color.fromARGB(255, 26, 151, 234);
  } else if (35 < percentage) {
    return const Color.fromARGB(255, 255, 109, 42);
  } else {
    return const Color.fromARGB(255, 255, 72, 72);
  }
}

int calculatePercentage(int a, int b) {
  double percent = 0;
  percent = a / b * 100;
  if (percent > 100) percent = 100;
  return percent.toInt();
}
