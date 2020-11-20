import 'package:flutter/material.dart';
import 'file:///C:/Users/wannes-nzxt/AndroidStudioProjects/nopassauthenticationclient/lib/view/components/drawer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';



class RecoverScreen extends StatelessWidget{
  static const routeName = "/recover";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recover"),
        backgroundColor: Colors.blue,
      ),
      drawer: LoadDrawer(),
      body: Column(
            children: [

            ],
      )
    );
  }


  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    print(args.value);
  }



}

