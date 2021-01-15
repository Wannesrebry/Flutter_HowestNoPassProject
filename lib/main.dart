// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:nopassauthenticationclient/view/screens/auth/account.dart';
import 'package:nopassauthenticationclient/view/screens/auth/home.dart';
import 'package:nopassauthenticationclient/view/screens/auth/seeds.dart';
import 'package:nopassauthenticationclient/view/screens/auth/toverify.dart';
import 'package:nopassauthenticationclient/view/screens/home.dart';
import 'package:nopassauthenticationclient/view/screens/recover.dart';
import 'package:nopassauthenticationclient/view/screens/register/register.dart';
import 'package:nopassauthenticationclient/view/screens/register/validate_registration.dart';

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
        ValidateRegistration.routeName: (BuildContext context) => new ValidateRegistration(),
        RecoverScreen.routeName: (BuildContext context) => new RecoverScreen(),
        SeedsScreen.routeName: (BuildContext context) => new SeedsScreen(),
        AuthHome.routeName: (BuildContext context) => new AuthHome(),
        AuthVerify.routeName: (BuildContext context) => new AuthVerify()
      }
    );
  }

}
