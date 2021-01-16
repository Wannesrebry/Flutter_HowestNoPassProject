import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nopassauthenticationclient/view/screens/recover.dart';
import 'package:nopassauthenticationclient/view/screens/register/register.dart';
import 'drawer_template.dart';
import 'nav_item_factory.dart';

class BasicDrawer extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    NavItemFactory navItemFactory = new NavItemFactory(context);
    return DrawerTemplate().create([
      navItemFactory.create(Icons.home, "Home", "/"),
      navItemFactory.create(Icons.account_box_rounded, "Register", RegisterScreen.routeName),
      navItemFactory.create(Icons.settings, "Recover", RecoveryScreen.routeName),
    ]);
  }
}

