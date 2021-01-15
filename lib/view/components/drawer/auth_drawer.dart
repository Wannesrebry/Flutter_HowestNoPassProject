import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nopassauthenticationclient/view/screens/auth/account.dart';
import 'package:nopassauthenticationclient/view/screens/auth/seeds.dart';

import 'drawer_template.dart';
import 'nav_item_factory.dart';

class AuthDrawer extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    NavItemFactory navItemFactory = new NavItemFactory(context);
    return DrawerTemplate().create([
      navItemFactory.create(Icons.home, "Home", "/"),
      navItemFactory.create(Icons.settings, "Account", SeedsScreen.routeName),
      navItemFactory.create(Icons.settings, "Settings", AccountScreen.routeName),
    ]);
  }
}


