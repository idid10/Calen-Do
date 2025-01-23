import 'package:flutter/material.dart';

class RequireWtmPage extends StatelessWidget {
  const RequireWtmPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Require Wtm'),
      ),
      body: const Center(
        child: Text(
          'This is the Require When to Meet page.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

