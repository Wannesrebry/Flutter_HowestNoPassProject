


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

// ignore: must_be_immutable
class VerifyDataDialog extends StatefulWidget{

  VerifyDataDialog({Key key, this.firstNameBlurred, this.lastNameBlurred, this.mainContext}) : super(key: key);
  final String firstNameBlurred;
  final String lastNameBlurred;
  final BuildContext mainContext;
  BuildContext current;
  String _firstName;
  String _lastName;
  DateTime _birthDate;

  @override
  Widget build(BuildContext context) {

    showDialog(
      context: mainContext,
      barrierDismissible: false, // set false for not closing on outside border.
      builder: (_) => new AlertDialog(
        content: Container(
            width: MediaQuery.of(mainContext).size.width,
            height: MediaQuery.of(mainContext).size.height,
            child: ListView(
                padding: const EdgeInsets.all(4),
                children: [
                  Text("Verify data",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text("Complete the data in order to succeed registration.",
                    textAlign: TextAlign.center,
                  ),
                  Text("First name: $firstNameBlurred",
                    textAlign: TextAlign.left,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'First name',
                      ),
                      onChanged: (value){
                        _firstName = value;
                      },
                    ),
                  ),
                  Text("Last name: $lastNameBlurred",
                    textAlign: TextAlign.left,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Last name',
                      ),
                      onChanged: (value){
                        _lastName = value;
                      },
                    ),
                  ),
                  Text("BirthDate:",
                    textAlign: TextAlign.left,
                  ),
                  Container(
                    child: SfDateRangePicker(
                        onSelectionChanged: (args){
                          //update selected birthDate.
                          _birthDate = args.value;
                        },
                        view: DateRangePickerView.year
                    ),
                  ),
                  RaisedButton(
                      color: Colors.green,
                      child: Text('Verify',
                          style: TextStyle(color: Colors.white)),
                      onPressed: ()async {
                        //todo
                        // send to server.
                        /*
                        showValidatedData(
                            _firstName,
                            _lastName,
                            _birthDate,
                            mainContext);
                         */
                      })
                ])
        ), actions: [
        FlatButton(
            child: Text('Cancel',
                style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.of(mainContext).pop();
            })
      ],
      ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }

}