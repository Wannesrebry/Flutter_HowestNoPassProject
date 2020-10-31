import 'package:flutter/material.dart';
import 'package:nopassauthenticationclient/components/drawer/drawer.dart';

class HomeScreen extends StatefulWidget{
  @override
  HomeScreenState createState() => HomeScreenState();

}

class HomeScreenState extends State<HomeScreen>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("MarsNoPass Auth"),
          backgroundColor: Colors.blue,
        ),
        drawer: LoadDrawer(),
        body: Column(
          children: [
            Image.asset('assets/images/banner.jpg',
                fit: BoxFit.cover
            ),
            Text("Mars NoPass Auth",
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
  }
}