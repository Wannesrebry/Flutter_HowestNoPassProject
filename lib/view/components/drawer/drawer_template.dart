import 'package:flutter/material.dart';

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

