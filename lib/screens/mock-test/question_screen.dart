import 'package:flutter/material.dart';
import 'package:vnrdn_tai/screens/mock-test/components/body.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [TextButton(onPressed: () => {}, child: Text("Skip"))],
      ),
      body: const Body(),
    );
  }
}
