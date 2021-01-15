import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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