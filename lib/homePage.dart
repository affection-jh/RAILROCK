import 'package:flutter/material.dart';
import 'package:railrock/searchPage.dart';
import 'package:railrock/stock/stockManage.dart';
import 'package:railrock/dispatch/outBound.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Container(
              child: Column(
                children: [
                  Text(
                    textAlign: TextAlign.center,
                    "RAILROCK",
                    style: TextStyle(
                        letterSpacing: 2,
                        fontSize: 30,
                        color: Colors.black,
                        fontFamily: 'Pretendard'),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 30),
                    child: Text(
                      textAlign: TextAlign.center,
                      "손쉬운 재고관리",
                      style: TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(118, 118, 118, 100),
                          fontFamily: 'Pretendard'),
                    ),
                  )
                ],
              ),
            ),
            actions: [
              Container(
                  margin: EdgeInsets.only(right: 30),
                  child: IconButton(
                      iconSize: 40,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SearchPage()),
                        );
                      },
                      icon: Icon(Icons.search_rounded))),
            ]),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OutBound()),
                );
              },
              child: BranchCard(
                  imagePath: 'assets/images/ssong.png',
                  title: '출고',
                  subTitle: '구매자 정보, 주문 목록'),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Stockmanage()),
                );
              },
              child: BranchCard(
                  imagePath: 'assets/images/tarri.png',
                  title: '입고',
                  subTitle: '입고 예정품, 재고'),
            ),
            GestureDetector(
              onTap: () {},
              child: BranchCard(
                  imagePath: 'assets/images/nneng.jpg',
                  title: '판매 관리',
                  subTitle: '매출, 구매자 정보'),
            ),
          ],
        ));
  }
}

class BranchCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subTitle;

  BranchCard(
      {Key? key,
      required this.imagePath,
      required this.title,
      required this.subTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16.0)),
            child: Image.asset(
              imagePath,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
