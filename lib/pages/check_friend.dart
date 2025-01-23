import 'package:flutter/material.dart';

class CheckFriendPage extends StatelessWidget {
  const CheckFriendPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Friend'),
      ),
      body: const Center(
        child: Text(
          'This is the Check Friend page.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
