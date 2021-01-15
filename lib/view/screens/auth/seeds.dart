import 'package:flutter/material.dart';
import 'package:nopassauthenticationclient/controller/encrypter/store_encryption.dart';
import 'file:///C:/Users/wannes-nzxt/AndroidStudioProjects/nopassauthenticationclient/lib/controller/register_controller.dart';
import 'package:nopassauthenticationclient/data/user.dart';
import 'package:nopassauthenticationclient/view/components/drawer/auth_drawer.dart';

class SeedsScreen extends StatefulWidget{
  static const routeName = "/seeds";

  @override
  SeedsScreenState createState() => SeedsScreenState();
}

class SeedsScreenState extends State<SeedsScreen>{
  final userRepo = LocalUserRepo();
  final encRepo = LocalStoreKeyPair();

  Scaffold mainScaffold;
  String firstNameValue;
  String identifier;
  List<String> seedsValues;

  @override
  Widget build(BuildContext context) {

    mainScaffold = Scaffold(
      appBar: AppBar(
        title: const Text("MarsNoPass Auth"),
        backgroundColor: Colors.blue,
      ),
      drawer: AuthDrawer(),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Text("Welcome, $firstNameValue"
              + "\n You can login to all mars sites using:"
              + "\n $identifier",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Text("Please write down, remember the seeds below. \n"+
                "In case of device lost you will need them to retrieve your account."+
                "\n Note: Order is important",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.blue
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Text("seeds : \n$seedsValues",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black
              ),
            ),
          ),
        ],
      ),
    );
    setUserData();
    return mainScaffold;
  }

  void setUserData()async{
    User user = await userRepo.getUser();
    List<String> seeds = await encRepo.getSeeds();
    setState((){
      firstNameValue = user.firstName;
      identifier = user.identifier;
      seedsValues = seeds;
    });
  }
}