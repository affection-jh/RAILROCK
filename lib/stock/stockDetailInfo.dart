import 'package:flutter/material.dart';
import 'stockClass.dart';

TextEditingController _textController = new TextEditingController();

class StockInfo extends StatefulWidget {
  final Stock currentstock;
  final VoidCallback updateStock;

  const StockInfo(
      {Key? key, required this.currentstock, required this.updateStock})
      : super(key: key);
  @override
  State<StockInfo> createState() => _StockInfoState();
}

class _StockInfoState extends State<StockInfo> {
  int changedValue = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            widget.currentstock.title,
            style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 28,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            child: Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    changedValue =
                        await _showQtyChangeDialog(widget.currentstock.stocks);
                    if (changedValue != -1) {
                      setState(() {
                        widget.currentstock.stocks = changedValue;
                        widget.updateStock();
                        changedValue = -1;
                      });
                    }
                  },
                  child: Column(
                    children: [
                      Text(
                        widget.currentstock.stocks.toString(),
                        style: TextStyle(
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
                        widget.updateStock();
                        changedValue = -1;
                      });
                    }
                  },
                  child: Column(
                    children: [
                      Text(
                        widget.currentstock.expectedToInStock.toString(),
                        style: TextStyle(
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
                        widget.updateStock();
                        changedValue = -1;
                      });
                    }
                  },
                  child: Column(
                    children: [
                      Text(
                        widget.currentstock.neededStocks.toString(),
                        style: TextStyle(
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
                decoration: InputDecoration(hintText: qty.toString()),
                keyboardType: TextInputType.number,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("취소")),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(_textController.text);
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

  void _showSnackbar(String alertMessage) {
    final snackBar = SnackBar(
      content: Text(alertMessage),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
