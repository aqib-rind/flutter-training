import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  final String name = 'Aaqib';
  final int ver = 420;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalog app'),


      ),
      body: Center(
        child: Text('My name is $name & I am  not $ver'),
      ),
      drawer: const Drawer(),
    );
  }
}
