import 'package:flutter/material.dart';

class SettingWtmPage extends StatelessWidget {
  const SettingWtmPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting Wtm'),
      ),
      body: const Center(
        child: Text(
          'This is the Setting When to Meet page.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

