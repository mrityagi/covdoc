import 'package:flutter/material.dart';
import 'package:heydoc/models/call.dart';
import 'package:heydoc/services/call_methods.dart';
import 'package:heydoc/screens/callscreen.dart';
import 'package:permission_handler/permission_handler.dart';

class PickupScreen extends StatelessWidget {
  final Call call;
  final CallMethods callMethods = CallMethods();

  PickupScreen({
    @required this.call,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Incoming...",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            SizedBox(height: 50),
            Text(
              "Video consult with",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 50),
            Text(
              'Dr ${call.callerName}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 75),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.call_end),
                  color: Colors.redAccent,
                  onPressed: () async {
                    await callMethods.endCall(call: call);
                  },
                ),
                SizedBox(width: 25),
                IconButton(
                    icon: Icon(Icons.call),
                    color: Colors.green,
                    onPressed: () async {
                      await [Permission.camera, Permission.microphone]
                          .request();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CallScreen(call: call),
                        ),
                      );
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
