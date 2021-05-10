import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heydoc/screens/bookingsequence/offlinebooking.dart';

/*var hours = [
  {'start': '8:47', 'end': '12:00'},
  {'start': '15:50', 'end': '18:25'}
];
*/
//var bookedSlots = ['08:48', '11:00', '11:24', '16:00'];
/*
var bookedSlots = {
  "10:00": {"completion": '', "booking": '', "pid": '', "reporting": ''},
  "09:00": {"completion": '', "booking": '', "pid": '', "reporting": ''},
  "08:48": {"completion": '', "booking": '', "pid": '', "reporting": ''},
  "16:00": {"completion": '', "booking": '', "pid": '', "reporting": ''},
};
*/
bool inrange(var rng, var thishr, var thismn, var slotdur) {
  int shrslot = int.parse(rng['start'].split(':')[0]);
  int smnslot = int.parse(rng['start'].split(':')[1]);
  int ehrslot = int.parse(rng['end'].split(':')[0]);
  int emnslot = int.parse(rng['end'].split(':')[1]);
  double x = thishr + (thismn / 60.0);
  double y = thishr + (thismn + slotdur) / 60.0;
  double s = shrslot + (smnslot / 60.0);
  double e = ehrslot + (emnslot / 60.0);
  bool ans = false;
  if ((x >= s) & (y <= e)) {
    ans = true;
  }
  return ans;
}

List generateGridslot(
    var workinghrs, int slotsPerHour, Map bookedslots, String type) {
  int n = workinghrs.length;
  int slotdur = (60.0 / slotsPerHour).round();
  int starthr = int.parse(workinghrs[0]['start'].split(':')[0]);
  int endhr = int.parse(workinghrs[n - 1]['end'].split(':')[0]);
  List valhrs = [];
  for (int i = 0; i < endhr - starthr + 1; i++) {
    var mnslot = [];
    for (int j = 0; j < slotsPerHour; j++) {
      for (int k = 0; k < n; k++) {
        var thishr = i + starthr;
        var thismn = j * slotdur;
        if (inrange(workinghrs[k], thishr, thismn, slotdur)) {
          mnslot.add(thishr.toString().padLeft(2, '0') +
              ':' +
              thismn.toString().padLeft(2, '0'));
          break;
        }
      }
    }
    if (mnslot.length > 0) {
      valhrs.add(mnslot);
    }
  }
  var rhrs = [];
  for (int i = 0; i < valhrs.length; i++) {
    int idx = 0;
    for (int j = 0; j < slotsPerHour; j++) {
      Color active = Colors.grey;
      String smin = (j * slotdur).toString().padLeft(2, '0');
      String stime = valhrs[i][0].split(':')[0] + ':' + smin;
      if (idx < valhrs[i].length) {
        String valmin = valhrs[i][idx].split(':')[1];
        if (valmin == smin) {
          idx += 1;
          if (type == "offline") {
            active = Colors.green[100];
          } else {
            active = Colors.pink[100];
          }
        }
      }
      /*
      if (idy < bookedSlots.length) {
        String bktime = bookedSlots[idy];
        if (bktime == stime) {
          idy += 1;
          active = Colors.red;
        }
      }
      */
      if ((bookedslots) != null) {
        if (bookedslots.containsKey(stime)) {
          if (type == "offline") {
            active = Colors.red;
          } else {
            active = Colors.deepPurpleAccent;
          }
        }
      }
      rhrs.add([stime, active]);
    }
  }
  return rhrs;
}

class Offlineslottable extends StatefulWidget {
  final int docslotperhr;
  final Map bslots;
  final List timings;
  final dynamic docuidoffline;
  final String date;
  final String type;
  Offlineslottable(
      {this.docslotperhr,
      this.timings,
      this.bslots,
      this.docuidoffline,
      this.date,
      this.type});
  @override
  _OfflineBookslotState createState() => _OfflineBookslotState(
      docslotperhr, timings, bslots, docuidoffline, date, type);
}

class _OfflineBookslotState extends State<Offlineslottable> {
  int docofflineslot;
  Map docofflinebookedslots;
  List doctimings;
  dynamic uidoffline;
  String dateuid;
  String typeofslot;
  _OfflineBookslotState(docofflineslot, doctimings, docofflinebookedslots,
      uidoffline, dateuid, typeofslot);

  String selectedslot = '';

  @override
  void initState() {
    docofflineslot = (widget.docslotperhr);
    doctimings = (widget.timings);
    docofflinebookedslots = (widget.bslots);
    uidoffline = (widget.docuidoffline);
    dateuid = (widget.date);
    typeofslot = (widget.type);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var gridslot = generateGridslot(
        doctimings, docofflineslot, docofflinebookedslots, typeofslot);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FlatButton(
                onPressed: () {},
                //borderSide: BorderSide(color: gridslot[id][index][1]),
                color: (typeofslot == "offline")
                    ? Colors.green[100]
                    : Colors.pink[100],
                textColor: Colors.black,
                child: Text('Available'),
                padding: EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              ),
              SizedBox(
                width: 10,
              ),
              FlatButton(
                onPressed: () {},
                //borderSide: BorderSide(color: gridslot[id][index][1]),
                color: (typeofslot == "offline")
                    ? Colors.red
                    : Colors.deepPurpleAccent,
                textColor: Colors.white,
                child: Text('Booked'),
                padding: EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              ),
            ],
          ),
        ),
        Divider(
          color: Colors.blueGrey,
        ),
        Container(
          height: (typeofslot == "offline")
              ? docofflineslot * 50.0
              : (gridslot.length / docofflineslot) * 70,
          child: GridView.count(
            scrollDirection:
                (typeofslot == "offline") ? Axis.horizontal : Axis.vertical,
            crossAxisSpacing: 4,
            childAspectRatio: (typeofslot == "offline") ? .6 : 1.6,
            mainAxisSpacing: 20,
            crossAxisCount: docofflineslot,
            children: List.generate(gridslot.length, (index) {
              if (typeofslot == "offline") {
                return (gridslot[index][1] == Colors.green[100])
                    ? RaisedButton(
                        //highlightElevation: 10,
                        elevation: 1,
                        highlightColor: Colors.green,
                        onPressed: () {
                          setState(() {
                            selectedslot = gridslot[index][0];
                          });

                          //selectedslot = gridslot[index][0];
                          print(selectedslot);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Bookingscreen(
                                      details: uidoffline,
                                      dateDoc: dateuid,
                                      selecslot: selectedslot,
                                      bookingtype: "",
                                      docaddress: "offline",
                                    )),
                          );
                        },
                        //borderSide: BorderSide(color: gridslot[id][index][1]),
                        //color: pressAttention ? Colors.green : Colors.blue,
                        color: gridslot[index][1],
                        textColor: Colors.black,
                        child: Text(gridslot[index][0]),
                        padding: EdgeInsets.all(5),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                      )
                    : FlatButton(
                        onPressed: () {},
                        //borderSide: BorderSide(color: gridslot[id][index][1]),
                        color: gridslot[index][1],
                        textColor: Colors.white,
                        child: Text(gridslot[index][0]),
                        padding: EdgeInsets.all(5),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                      );
              } else {
                return (gridslot[index][1] == Colors.pink[100])
                    ? RaisedButton(
                        //highlightElevation: 10,
                        elevation: 1,
                        highlightColor: Colors.pinkAccent,
                        onPressed: () {
                          setState(() {
                            selectedslot = gridslot[index][0];
                          });

                          //selectedslot = gridslot[index][0];
                          print(selectedslot);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Bookingscreen(
                                      details: uidoffline,
                                      dateDoc: dateuid,
                                      selecslot: selectedslot,
                                      bookingtype: "video",
                                      docaddress: "online",
                                    )),
                          );
                        },
                        //borderSide: BorderSide(color: gridslot[id][index][1]),
                        //color: pressAttention ? Colors.green : Colors.blue,
                        color: gridslot[index][1],
                        textColor: Colors.black,
                        child: Text(gridslot[index][0]),
                        padding: EdgeInsets.all(5),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                      )
                    : FlatButton(
                        onPressed: () {},
                        //borderSide: BorderSide(color: gridslot[id][index][1]),
                        color: gridslot[index][1],
                        textColor: Colors.white,
                        child: Text(gridslot[index][0]),
                        padding: EdgeInsets.all(5),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                      );
              }
              //robohash.org api provide you different images for any number you are giving
            }),
          ),
        )
      ],
    );
  }
}
