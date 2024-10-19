import 'package:charla_vertex_gemini/const/assets.dart';
import 'package:flutter/material.dart';

class ScaffoldTecylab extends StatelessWidget {
  final Widget body;
  final Widget? floatingActionButton;
  const ScaffoldTecylab(
      {super.key, required this.body, this.floatingActionButton});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        backgroundColor: Colors.red,
        title: Center(child: Image.asset(R.tecylabLogo, height: 80)),
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
