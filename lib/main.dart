// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:nopassauthenticationclient/screens/account.dart';
import 'package:nopassauthenticationclient/screens/home.dart';
import 'package:nopassauthenticationclient/screens/recover.dart';
import 'package:nopassauthenticationclient/screens/register.dart';

void main() => runApp(Run());

class Run extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      routes: <String, WidgetBuilder>{
        AccountScreen.routeName: (BuildContext context) => new AccountScreen(),
        RegisterScreen.routeName: (BuildContext context) => new RegisterScreen(),
        RecoverScreen.routeName: (BuildContext context) => new RecoverScreen()
      }
    );
  }

}
