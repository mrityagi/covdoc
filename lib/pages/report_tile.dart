import 'package:flutter/widgets.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';

class ReportTile extends StatefulWidget {
  ReportTile({this.report});
  final dynamic report;
  @override
  _ReportTileState createState() => new _ReportTileState(report);
}

class _ReportTileState extends State<ReportTile> {
  dynamic repdata;
  String _openResult = 'Unknown';
  _ReportTileState(repdata);

  @override
  void initState() {
    repdata = (widget.report);
    super.initState();
  }

  Future<void> openFile() async {
    Dio dio = Dio();
    final filePath = '/storage/emulated/0/Download/' + '${repdata['location']}';
    await [
      Permission.storage,
    ].request();
    //final filePath = '/storage/emulated/0/Download/20-21 odd mid sem soln.docx';
    await dio.download(repdata['reporturl'], filePath);

    final result = await OpenFile.open(filePath);

    setState(() {
      _openResult = "type=${result.type}  message=${result.message}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return reporttile(context, 'what kind of data?');
  }

  Widget reporttile(BuildContext context, data) {
    //print(repdata.data()['prescription']);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(left: 10, top: 20),
            child: Text(repdata.data()['reportdate'],
                style: TextStyle(fontWeight: FontWeight.bold))),
        FocusedMenuHolder(
          blurSize: 5.0,
          animateMenuItems: true,
          menuWidth: 150,
          duration: Duration(milliseconds: 100),
          blurBackgroundColor: Colors.black45,
          onPressed: () {
            openFile();
            print(_openResult);
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
          child: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.blueGrey.withOpacity(.1),
                        offset: Offset(0, 8),
                        blurRadius: 5)
                  ],
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.grey[50], Colors.white]),
                  borderRadius: BorderRadius.circular(25.0),
                  border: Border.all(color: Colors.blueGrey)),
              padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 15),
              child: Column(
                children: [
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
                                          'https://th.bing.com/th/id/OIP.AsfdVeoje1KpYXypsUNxnAHaE9?w=266&h=180&c=7&o=5&dpr=1.25&pid=1.7'),
                                      width: 72,
                                      height: 72,
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
                            repdata.data()["doctorname"],
                            style: TextStyle(
                                color: Theme.of(context).primaryColorDark,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Container(
                            padding: EdgeInsets.only(top: 2.0),
                            child: Text(
                              repdata.data()["specialization"],
                              style: TextStyle(
                                  color: Theme.of(context).primaryColorDark,
                                  fontSize: 16.0),
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () async {},
                            icon: Icon(Icons.info_rounded,
                                size: 35, color: Colors.cyan[800]),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  // Prescriptions list container
                  Container(
                      child: repdata.data()['prescription'] != null ? prescriptList(
                          /*
                      {Uploadreport
                      'a': 'paracetamol',
                      'b': 'diclobin +',
                      'c': 'ceftum glycerol'
                    }
                    */
                          repdata['prescription']) : null)
                ],
              ),
            ),
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 5)),
      ],
    );
  }

  Widget prescriptList(Map dic) {
    //print(dic.keys);
    List<Widget> widgetsList = [];
    for (var key in dic.keys) {
      widgetsList.add(Padding(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.teal[50],
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(color: Colors.blueGrey)),
              child: ListTile(
                title: Text(
                  dic[key]['name'],
                  style: TextStyle(fontSize: 20.0),
                ),
                trailing: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      dic[key]['t1'] == ""
                          ? Icons.wb_sunny_outlined
                          : Icons.wb_sunny_rounded,
                      color: dic[key]['t1'] == ""
                          ? Colors.red[600]
                          : Colors.green[900],
                    ),
                    Icon(
                      dic[key]['t2'] == ""
                          ? Icons.fastfood_outlined
                          : Icons.fastfood_rounded,
                      color: dic[key]['t2'] == ""
                          ? Colors.red[600]
                          : Colors.green[900],
                    ),
                    Icon(
                      dic[key]['t3'] == ""
                          ? Icons.nights_stay_outlined
                          : Icons.nights_stay_rounded,
                      color: dic[key]['t3'] == ""
                          ? Colors.red[600]
                          : Colors.green[900],
                    ),
                  ],
                ),
                subtitle:
                    Text("${dic[key]['durStart']} to ${dic[key]['durEnd']}"),
              ))));
    }

    return Column(
      children: widgetsList,
    );
  }
}
