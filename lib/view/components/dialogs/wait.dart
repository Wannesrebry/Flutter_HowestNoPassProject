import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Wait{
  Wait(this.msg);
  final String msg;
  BuildContext context;

  Widget build(BuildContext context) {
    this.context = context;
    return new AlertDialog(
      content: Container(
          width: MediaQuery.of(context).size.width /4,
          height: MediaQuery.of(context).size.width /4,
          child: ListView(
            padding: const EdgeInsets.all(4),
            children: [
              SpinKitRotatingCircle(
                color: Colors.blue,
                size: 75,
              ),
              Text("Awaiting server response ...",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15)),
            ],
          )
      ),
    );
  }

  Future<void> init(BuildContext context)async {
    final Widget popupContent = build(context);
    showDialog(
        context: context,
        barrierDismissible: false,
      builder: (_) => popupContent
    );
    //return context;
  }
}


class WaitState extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      content: Container(
          width: MediaQuery.of(context).size.width /4,
          height: MediaQuery.of(context).size.width /4,
          child: ListView(
            padding: const EdgeInsets.all(4),
            children: [
              SpinKitRotatingCircle(
                color: Colors.blue,
                size: 75,
              ),
              Text("Awaiting server response ...",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15)),
            ],
          )
      ),
    );
  }

}

