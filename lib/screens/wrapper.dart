import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:heydoc/bottomtabnav.dart';
import 'package:heydoc/models/user.dart';
import 'package:heydoc/screens/authenticate/authenticate.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    if (user == null) {
      return Authenticate();
    } else {
      return Scaffold(
        body: ShowCaseWidget(
          onStart: (index, key) {
            log('onStart: $index, $key');
          },
          onComplete: (index, key) {
            log('onComplete: $index, $key');
          },
          builder: Builder(builder: (context) => BottomTab()),
          autoPlay: true,
          autoPlayDelay: Duration(seconds: 3),
          autoPlayLockEnable: true,
        ),
      );
    }
  }
}
