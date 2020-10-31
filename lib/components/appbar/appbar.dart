import 'package:flutter/material.dart';


class BasicAppbar extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("MarsNoPass Auth"),
      backgroundColor: Colors.blue,
    );
  }
}