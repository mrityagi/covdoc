import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heydoc/services/database.dart';
import 'package:provider/provider.dart';
import 'package:heydoc/models/user.dart';
import 'package:heydoc/shared/loading.dart';
import 'package:heydoc/services/notification_plugin.dart';

class Bookingscreen extends StatefulWidget {
  Bookingscreen(
      {Key key,
      this.details,
      this.dateDoc,
      this.selecslot,
      this.bookingtype,
      this.docaddress})
      : super(key: key);
  final dynamic details;
  final String dateDoc;
  final String selecslot;
  final String bookingtype;
  final String docaddress;
  @override
  _BookingscreenState createState() =>
      _BookingscreenState(details, dateDoc, selecslot, bookingtype, docaddress);
}

class _BookingscreenState extends State<Bookingscreen> {
  dynamic doctordetails;
  String date;
  String slot;
  String appointmenttype;
  String doctorworkplaceaddress;
  _BookingscreenState(
      doctordetails, date, slot, appointmenttype, doctorworkplaceaddress);
  NotificationPlugin plugin = new NotificationPlugin();

  @override
  void initState() {
    doctordetails = (widget.details);
    date = (widget.dateDoc);
    slot = (widget.selecslot);
    appointmenttype = (widget.bookingtype);
    doctorworkplaceaddress = (widget.docaddress);
    super.initState();
  }

  Future<void> _addBookingToDatabase(String uid, String did, String dat,
      String tim, String docname, String type) async {
    try {
      int appId = DateTime.now().hashCode;
      plugin.appointment(
          RecievedNotification(
              id: ((appId ~/ 10) * 10 + 1),
              title: "Appointment with Dr. " + docname,
              body: "Reminder for your appointment today in an hour",
              payload: "test"),
          tim,
          dat,
          docname);
      if (FirebaseFirestore.instance
              .collection('patients')
              .doc(uid)
              .collection('appointments') ==
          null) {
        FirebaseFirestore.instance
            .collection('patients')
            .doc(uid)
            .collection('appointments')
            .add({});
      } else {
        // Add location and url to database
        await FirebaseFirestore.instance
            .collection('doctor')
            .doc(did)
            .collection('bookings')
            .doc(dat)
            .update({
          "booked_slots.$tim": {
            "app_use": true,
            "booking": 'true',
            "pid": uid,
            "completion": "",
            "reporting": 0,
          }
        });
        await FirebaseFirestore.instance
            .collection('doctor')
            .doc(did)
            .update({"patients_count.$dat": FieldValue.increment(1)});
        await FirebaseFirestore.instance
            .collection('patients')
            .doc(uid)
            .collection('appointments')
            .doc()
            .set({
          'doctorid': did,
          'docspecialization': doctordetails['specialization'],
          'docname': doctordetails['name'],
          'patientid': uid,
          'appointmenttime': tim,
          'appointmentdate': dat,
          'appointmenttype': type
        });
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

  Widget bookingpage(data) {
    User user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Container(
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
                                    image: NetworkImage(
                                        'https://icons.iconarchive.com/icons/aha-soft/free-large-boss/512/Head-Physician-icon.png'),
                                    width: 100,
                                    height: 110,
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),
                    Expanded(
                        child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(bottom: 5, left: 15),
                          child: Text(
                            "Dr ${data['name']}",
                            style: TextStyle(
                                color: Theme.of(context).primaryColorDark,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(bottom: 5, left: 15),
                          child: Text(
                            data['specialization'],
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(bottom: 5, left: 15),
                          child: Text(
                            doctorworkplaceaddress,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ],
                    ))
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(top: 5, bottom: 5, left: 15),
                    child: Text(
                        appointmenttype != "video"
                            ? 'In Person one-to-one Appointment'
                            : 'Video Consultation Appointment',
                        style: TextStyle(
                            color: appointmenttype != "video"
                                ? Colors.cyan[800]
                                : Colors.purple[800],
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold))),
                
                Divider(color: Colors.black38),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 5, bottom: 5, left: 15),
                  child: Text(
                    'Time of  Appointment ',
                    style: TextStyle(
                      color: Colors.blueGrey[700],
                      fontSize: 18.0,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 5, bottom: 5, left: 15),
                  child: Text(
                    slot,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Divider(color: Colors.black38),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 5, bottom: 5, left: 15),
                  child: Text(
                    'Your Details  :',
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 5, bottom: 5, left: 15),
                  child: Text(
                    'Name : ${userData.name} ',
                    style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 5, bottom: 5, left: 15),
                  child: Text(
                    'Ph No : ${userData.phone} ',
                    style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 5, bottom: 5, left: 15),
                  child: Text(
                    'Date of birth : ${userData.dob} ',
                    style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 5, bottom: 5, left: 15),
                  child: Text(
                    'Address : ${userData.address} ',
                    style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ]),
            );
          }
          return Loading();
        });
  }

  @override
  Widget build(BuildContext context) {
    print(date);

    User user = Provider.of<User>(context);
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          title: Text('Booking Details'),
          elevation: 0,
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Container(
                height: screenHeight,
                color: Theme.of(context).primaryColor,
                child: SingleChildScrollView(
                  child: bookingpage(doctordetails),
                )),
            Positioned(
                bottom: 8,
                right: 5,
                left: 5,
                child: Container(
                    height: 55,
                    child: RaisedButton(
                      //highlightElevation: 10,
                      elevation: 1,
                      highlightColor: Colors.green,
                      onPressed: () {
                        _addBookingToDatabase(
                            user.uid,
                            doctordetails.documentID,
                            date,
                            slot,
                            doctordetails['name'],
                            appointmenttype);
                        Navigator.pop(context);
                      },
                      //borderSide: BorderSide(color: gridslot[id][index][1]),
                      //color: pressAttention ? Colors.green : Colors.blue,
                      color: appointmenttype != "video"
                          ? Colors.cyan[800]
                          : Colors.deepPurple[700],
                      textColor: Colors.white,
                      child: Text(
                        "Confirm Booking",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                      padding: EdgeInsets.all(5),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(12.0)),
                    ))),
          ],
        ));
  }
}
