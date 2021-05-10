import 'dart:math';
import 'package:flutter/material.dart';
import 'package:heydoc/models/call.dart';
import 'package:heydoc/models/user.dart';
import 'call_methods.dart';
import 'package:heydoc/screens/callscreen.dart';

class CallUtils {
  static final CallMethods callMethods = CallMethods();

  static dial({User from, User to, context}) async {
    Call call = Call(
      callerId: from.uid,
      callerName: from.name,
      receiverId: to.uid,
      receiverName: to.name,
      channelId: Random().nextInt(1000000).toString(),
    );

    bool callMade = await callMethods.makeCall(call: call);

    call.hasDialled = true;

    if (callMade) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallScreen(call: call),
          ));
    }
  }
}
