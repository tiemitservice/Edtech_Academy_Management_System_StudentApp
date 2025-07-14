import 'package:flutter/material.dart';

class HistoryPermission extends StatelessWidget {
  const HistoryPermission({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History Permission'),
      ),
      body: const Center(
        child: Text('History Permission Screen'),
      ),
    );
  }
}