import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'dart:math';

import 'package:heydoc/pages/report_tile.dart';

/// This Widget is the main application widget.
class Report extends StatefulWidget {
  @override
  ReportState createState() {
    return ReportState();
  }
}

class ReportState extends State<Report> {
  File samplefile;
  auth.User user;
  String error;
  List reportslist = [];

  void setUser(auth.User user) {
    setState(() {
      this.user = user;
      this.error = null;
    });
  }

  void setError(e) {
    setState(() {
      this.user = null;
      this.error = e.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    setUser(auth.FirebaseAuth.instance.currentUser);
  }

  Future getDataFile() async {
    var tempfile = await FilePicker.getFile(
      type: FileType.image,
      //allowedExtensions: ['jpg', 'pdf', 'doc'],
    );

    setState(() {
      samplefile = tempfile;
      // printf('what the $samplefile');
    });
  }

  Future<void> _addReportPathToDatabase(String text) async {
    try {
      // Get image URL from firebase
      final ref = FirebaseStorage().ref().child(text);
      var imageString = await ref.getDownloadURL();
      if (FirebaseFirestore.instance
              .collection('patients')
              .doc(user.uid)
              .collection('reports') ==
          null) {
        FirebaseFirestore.instance
            .collection('patients')
            .doc(user.uid)
            .collection('reports')
            .add({});
      } else {
        // Add location and url to database
        await FirebaseFirestore.instance
            .collection('patients')
            .doc(user.uid)
            .collection('reports')
            .doc()
            .set({'url': imageString, 'location': text});
      }
    } catch (e) {
      print(e.message);

      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message),
            );
          });
    }
  }

  Widget uploadreport() {
    return Container(
      child: Column(
        children: <Widget>[
          Image.file(samplefile, height: 300, width: 400),
          RaisedButton(
            elevation: 5,
            color: Colors.blue,
            child: Text('upload'),
            onPressed: () async {
              int randomNumber = Random().nextInt(100000);
              String imageLocation =
                  'reports/patients.${user.uid}.$randomNumber.jpg';
              final StorageReference firebaseStorageRef =
                  FirebaseStorage.instance.ref().child(imageLocation);
              final StorageUploadTask task =
                  firebaseStorageRef.putFile(samplefile);
              await task.onComplete;
              _addReportPathToDatabase(imageLocation);
              setState(() {
                samplefile = null;
              });
            },
          )
        ],
      ),
    );
  }

  Widget reporttile(data) {
    return Column(
      children: <Widget>[
        FocusedMenuHolder(
          blurSize: 5.0,
          animateMenuItems: true,
          menuWidth: 150,
          duration: Duration(milliseconds: 100),
          blurBackgroundColor: Colors.black45,
          onPressed: () {
            // printf(data.documentID);
          },
          menuItems: <FocusedMenuItem>[
            FocusedMenuItem(
                title: Text("Open"),
                trailingIcon: Icon(Icons.open_in_new),
                onPressed: () {}),
            FocusedMenuItem(
                title: Text("Share"),
                trailingIcon: Icon(Icons.share),
                onPressed: () {}),
            FocusedMenuItem(
                backgroundColor: Colors.redAccent,
                title: Text(
                  "Delete",
                  style: TextStyle(color: Colors.white),
                ),
                trailingIcon: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                onPressed: () {}),
          ],
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 2,
            color: Theme.of(context).primaryColorDark,
            child: Container(
              padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 15),
              child: Column(children: [
                Row(
                  children: <Widget>[
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Container(
                          padding: const EdgeInsets.all(3),
                          child: Column(
                            children: <Widget>[
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image(
                                    image: NetworkImage(data['url']),
                                    width: 100,
                                    height: 110,
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),
                    Expanded(
                      child: ListTile(
                        isThreeLine: true,
                        title: Text(
                          "Patient",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Container(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text(
                            "Report      I am a Doctor who knows this that blabla..bla..bla",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 3)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('patients')
            .doc(user.uid)
            .collection('reports')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          for (int i = 0; i < snapshot.data.docs.length; i++) {
            // printf('${snapshot.data.documents.length}');
            reportslist = snapshot.data.docs.toList();
          }

          return Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 10, top: 20),
                        child: Text(
                          'Reports',
                          style: TextStyle(
                            fontFamily: "Montserrat-Bold",
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 10,
                        ),
                        child: Text(
                          'All your reports are safely stored here',
                          style: TextStyle(
                            fontFamily: "Montserrat-Bold",
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Container(
                        //margin: EdgeInsets.only( top: 5),

                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  Colors.white,
                                  Colors.grey[50],
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30)),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.blueGrey.withOpacity(.35),
                                  offset: Offset(0, 8),
                                  blurRadius: 8)
                            ]),
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.asset('assets/onboard/report.png',
                                width: 450.0, height: 250),
                          ),
                        ),
                      ),
                      Container(
                        child: samplefile == null
                            ? SizedBox(height: 5)
                            : uploadreport(),
                      ),
                      ListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: reportslist.map((element) {
                          return ReportTile(report: element);
                        }).toList(),
                      ),
                      SizedBox(
                        height: 100,
                      )
                    ],
                  ),
                )),

            // Container(
            //   child: samplefile==null ? Text('add reports to upload',style:TextStyle(color: Colors.white)):uploadreport(),
            // ),

            floatingActionButton: FloatingActionButton.extended(
              hoverElevation: 10,
              label: Text(
                "Add Reports",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: getDataFile,
              // final StorageReference firebaseStorageRef =FirebaseStorage.instance.ref().child("reports/report");
              // final StorageUploadTask task = firebaseStorageRef.putFile(samplefile);
              //printf("tapped");

              icon: Icon(
                Icons.add_photo_alternate,
                size: 25,
                color: Colors.white,
              ),
              backgroundColor: Colors.blueGrey[900],
            ),
          );
        });
  }

  /// This is the stateless widget that the main application instantiates
}
