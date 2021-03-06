import 'package:flutter/material.dart';
import 'file:///C:/Users/wannes-nzxt/AndroidStudioProjects/nopassauthenticationclient/lib/controller/register_controller.dart';
import 'package:nopassauthenticationclient/view/components/drawer/basic_drawer.dart';
import 'package:nopassauthenticationclient/view/screens/auth/home.dart';
import 'package:nopassauthenticationclient/view/screens/register/register.dart';

class HomeScreen extends StatefulWidget{
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>{

  @override
  Widget build(BuildContext context) {
    checkIfLogged(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text("MarsNoPass Auth"),
          backgroundColor: Colors.blue,
        ),
        drawer: BasicDrawer(),
        body: Column(
          children: [
            Image.asset('assets/images/banner.jpg',
                fit: BoxFit.cover
            ),
            Text("Register to gain access to all mars-application!",
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
                padding: EdgeInsets.all(10),
                child: OutlineButton(
                  child: Text("Register"),
                  onPressed: (){
                    Navigator.of(context).pushNamed(RegisterScreen.routeName);
                  },
                )
            )
          ],
        ),
      );
  }

  void checkIfLogged(BuildContext context) async{
    final userRepo = LocalUserRepo();
    bool isAuth = await userRepo.isUserAuth();
    if(isAuth){
      Navigator.of(context).pushNamed(AuthHome.routeName);
    }
  }

}