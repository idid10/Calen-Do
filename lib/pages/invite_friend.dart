import 'package:flutter/material.dart';

class InviteFriendPage extends StatelessWidget {
  const InviteFriendPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invite Friend'),
      ),
      body: const Center(
        child: Text(
          'This is the Invite Friend page.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
