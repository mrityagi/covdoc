import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:heydoc/models/call.dart';
import 'package:heydoc/models/user.dart';
import 'package:heydoc/services/call_methods.dart';
import 'package:heydoc/screens/pickup/pickup_screen.dart';

class PickupLayout extends StatelessWidget {
  final Widget scaffold;
  final CallMethods callMethods = CallMethods();

  PickupLayout({
    @required this.scaffold,
  });
  Future<bool> check(uid) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("video_consulting")
        .doc(uid)
        .get();

    if (documentSnapshot.exists) {
      return true;
    } else
      return false;
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    return (user.uid != null)
        ? StreamBuilder<DocumentSnapshot>(
            stream: callMethods.callStream(uid: user.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data.exists) {
                Call call = Call.fromMap(snapshot.data.data());
                if (!call.hasDialled) {
                  return PickupScreen(call: call);
                }
              }
              return scaffold;
            },
          )
        : Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
