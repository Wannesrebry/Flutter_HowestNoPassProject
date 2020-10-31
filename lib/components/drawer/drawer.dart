import 'package:flutter/material.dart';
import 'package:nopassauthenticationclient/screens/account.dart';
import 'package:nopassauthenticationclient/screens/recover.dart';
import 'package:nopassauthenticationclient/screens/register.dart';
import 'package:nopassauthenticationclient/user/user.dart';


class LoadDrawer extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // load user at start of app-boot
    User u = new User();
    //
    if(u.hasValidCredentials()){
      return AuthDrawer();
    }else{return BasicDrawer();}
  }

}

class AuthDrawer extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    NavItemFactory navItemFactory = new NavItemFactory(context);
   return DrawerTemplate().create([
     navItemFactory.create(Icons.home, "Home", "/"),
     navItemFactory.create(Icons.account_box_rounded, "Account", AccountScreen.routeName),
     navItemFactory.create(Icons.settings, "Settings", AccountScreen.routeName),
     navItemFactory.create(Icons.article_outlined, "Logs", AccountScreen.routeName)
   ]);
  }
}

class BasicDrawer extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    NavItemFactory navItemFactory = new NavItemFactory(context);
    return DrawerTemplate().create([
      navItemFactory.create(Icons.home, "Home", "/"),
      navItemFactory.create(Icons.account_box_rounded, "Register", RegisterScreen.routeName),
      navItemFactory.create(Icons.settings, "Recover", RecoverScreen.routeName),
    ]);
  }
}

class DrawerTemplate{

  create(List<ListTile> navItems){
    List<Widget> listItems = [];
    // Add Menu header:
    listItems.add(
        DrawerHeader(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/banner.jpg"), fit: BoxFit.cover),
          ), child: Text('Menu',
            style: TextStyle(
                color: Colors.white,
                fontSize: 24
            )
        ),
      )
    );
    // Add costume ListItems:
    listItems.addAll(navItems);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: listItems
      ),
    );
  }
}

class NavItemFactory{
  BuildContext __context;

  NavItemFactory(BuildContext context){
    __context = context;
  }

  ListTile create(var icon, String title, String routeName){
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: (){
        // pop closes the drawer
        Navigator.of(__context).pop();
        //navigate to route
        Navigator.of(__context).pushNamed(routeName);
      },

    );
  }
}


