import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SerchPageState();
}

class _SerchPageState extends State<SearchPage> {
  final TextEditingController _textController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
            child: TextField(
                controller: _textController,
                decoration: InputDecoration(hintText: "7400 호대"))),
      ),
    );
  }
}
