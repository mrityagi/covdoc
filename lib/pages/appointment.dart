import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:heydoc/models/user.dart';

class Appointment extends StatefulWidget {
  @override
  ProfileState createState() {
    return ProfileState();
  }
}

class ProfileState extends State<Appointment> {
  List appointmentlist = [];
  List pastappointments = [];
  List nextappointments = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget appointmentcard(data) {
    // print(data.data);
    return InkWell(
      splashColor: Colors.blue.withAlpha(30),
      onTap: () {
        //print(data);
        /*
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DocPage(
                    title: data['specialization'],
                    clickedDoc: data.documentID,
                  )),
        );
        */
      },
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 5,
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: [
                  Container(
                    width: 110,
                    child: Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Image(
                        height: 90,
                        width: 90,
                        image: NetworkImage(
                            'https://icons.iconarchive.com/icons/aha-soft/free-large-boss/512/Head-Physician-icon.png'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10, right: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dr. ' + data['docname'],
                            style: TextStyle(
                              fontSize: 21,
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            data['docspecialization'],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color.fromRGBO(0, 0, 0, 0.9),
                            ),
                          ),
                          Text(
                            '10 Years Experience',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color.fromRGBO(0, 0, 0, 0.9),
                            ),
                          ),
                          //ratingBar(3.67),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.only(right: 10, top: 5),
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: data['appointmenttype'] != 'video'
                                        ? Colors.cyan[600]
                                        : Colors
                                            .pink, //Color.fromRGBO(28, 195, 217, 1),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: FlatButton(
                                    child: Text(data['appointmenttime'],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                        )),
                                    onPressed: () {},
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  //width: 130,
                                  margin: EdgeInsets.only(right: 10, top: 5),
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: data['appointmenttype'] != 'video'
                                        ? Colors.teal
                                        : Colors.purple[
                                            400], //Color.fromRGBO(28, 195, 217, 1),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: FlatButton(
                                    child: Text(data['appointmentdate'],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                        )),
                                    onPressed: () {},
                                  ),
                                ),
                              )
                            ],
                          ),
                          //Expanded(child:
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(right: 10, top: 5),
                            height: 50,
                            decoration: BoxDecoration(
                              color: data['appointmenttype'] != 'video'
                                  ? Colors.blue[900]
                                  : Colors.deepPurple[700],
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: FlatButton(
                              child: Text(
                                  data['appointmenttype'] != 'video'
                                      ? 'In Person Appointment'
                                      : 'Video consultation',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                  )),
                              onPressed: () {},
                            ),
                          ),
                          // )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }

  Widget _buildBody(BuildContext context) {
    // const i=0;
    User user = Provider.of<User>(context);
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('patients')
          .doc(user.uid)
          .collection('appointments')
          .orderBy('appointmenttime')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        appointmentlist = snapshot.data.docs.toList();
        for (int i = 0; i < appointmentlist.length; i++) {
          var datesplit = appointmentlist[i]['appointmentdate'].split('-');
          var thisdate = datesplit[2] + '-' + datesplit[1] + '-' + datesplit[0];
          var thistime = appointmentlist[i]['appointmenttime'] + ':00.000';
          var thisdatetime = thisdate + ' ' + thistime;
          var now = DateTime.now();
          if (now.isAfter(DateTime.parse(thisdatetime))) {
            pastappointments.add(appointmentlist[i]);
          } else
            nextappointments.add(appointmentlist[i]);
        }
        return SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 10.0),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 25.0,
                    backgroundImage: NetworkImage(
                        'https://icons.iconarchive.com/icons/aha-soft/free-large-boss/512/Head-Physician-icon.png'),
                  ),
                  title: Text(
                    "Upcoming Appointments",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Container(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Here we show you your Active Appointment",
                      style: TextStyle(color: Colors.black, fontSize: 15.0),
                    ),
                  ),
                ),
              ),
              nextappointments.length == 0
                  ? SizedBox(
                      height: 100,
                      child: Text(
                        'You have no active Appointments',
                        style: TextStyle(
                            color: Colors.green[900],
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  : Column(
                      children: nextappointments.map((element) {
                        return appointmentcard(element);
                      }).toList(),
                    ),
              Divider(
                color: Theme.of(context).primaryColor,
              ),
              Container(
                padding: EdgeInsets.only(top: 10.0),
                child: ListTile(
                  title: Text(
                    "Past Appointments",
                    style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Container(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Here we show your previous bookings",
                      style: TextStyle(color: Colors.grey, fontSize: 15.0),
                    ),
                  ),
                ),
              ),
              appointmentlist.length == 0
                  ? SizedBox(
                      height: 100,
                      child: Text('You have no prior Appointments with HeyDoc',
                          style: TextStyle(
                              color: Colors.green[900],
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold)))
                  : Column(
                      children: pastappointments.map((element) {
                        return appointmentcard(element);
                      }).toList(),
                    ),
            ],
          ),
        );
      },
    );
  }
}
