import 'package:flutter/material.dart';

class FeedbacksScreen extends StatefulWidget {
  const FeedbacksScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FeedbackClassState();
}

class _FeedbackClassState extends State<FeedbacksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        title: const Text('Phản hồi'),
      ),
      body: Container(),
    );
  }
}
