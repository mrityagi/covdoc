// Flutter code sample for BottomNavigationBar

// This example shows a [BottomNavigationBar] as it is used within a [Scaffold]
// widget. The [BottomNavigationBar] has three [BottomNavigationBarItem]
// widgets and the [currentIndex] is set to index 0. The selected item is
// amber. The `_onItemTapped` function changes the selected item's index
// and displays a corresponding message in the center of the [Scaffold].
//
// ![A scaffold with a bottom navigation bar containing three bottom navigation
// bar items. The first one is selected.](https://flutter.github.io/assets-for-api-docs/assets/material/bottom_navigation_bar.png)

import 'package:flutter/material.dart';
import 'package:heydoc/screens/pickup/pickup_layout.dart';
import 'package:heydoc/services/auth.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:showcaseview/showcaseview.dart';
import 'pages/doc.dart';
import 'pages/profile.dart';
import 'pages/prescriptions.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import 'shared/constants.dart';

/// This Widget is the main application widget.
class BottomTab extends StatelessWidget {
  static const String _title = 'Heydoc';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(
        primaryColorDark: Colors.blueGrey[900],
        primaryColor: Colors.white,
        accentColor: Colors.black,
      ),
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget>
    with SingleTickerProviderStateMixin {
  TabController controller;
  final AuthService _auth = AuthService();
  String qrCodeResult = "Not Yet Scanned";

  @override
  void initState() {
    super.initState();
    initDynamicLinks();
    controller = TabController(initialIndex: 0, length: 2, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;
      final String uid = deepLink.queryParameters['refId'];
      print(uid);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DocPage(
            title: 'Doctor',
            clickedDoc: uid,
          ),
        ),
      );
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
  }

  void fixfromreg() {
    setState(() {
      fromregistered = false;
    });
  }

  GlobalKey _one = GlobalKey();
  GlobalKey _two = GlobalKey();
  GlobalKey _three = GlobalKey();
  GlobalKey _four = GlobalKey();
  GlobalKey _five = GlobalKey();
  GlobalKey _six = GlobalKey();

  @override
  Widget build(BuildContext context) {
    if (fromregistered) {
      WidgetsBinding.instance.addPostFrameCallback((_) =>
          ShowCaseWidget.of(context)
              .startShowCase([_one, _two]));
      fixfromreg();
    }
    return PickupLayout(
        scaffold: Scaffold(
      appBar: AppBar(
          elevation: 0,
          title: Text("CovDoc",
                    style: TextStyle(fontSize: 25.0, color: Colors.blueGrey[900] , fontWeight: FontWeight.bold),),
          actions: <Widget>[
            /*
          IconButton(
            onPressed: () async {
              await [Permission.camera, Permission.microphone]
                          .request();
                Navigator.push(context,
                 CallUtils.dial(
                    from: searchedUser,
                    to:seaUser,
                    context: context,
                  )
                );
              },
            icon: Icon(Icons.video_call,
                color: Theme.of(context).primaryColorDark),
          ),
          */
            Showcase(
              key: _six,
              overlayColor: Colors.white,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              title: "Share",
              titleTextStyle: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              descTextStyle: TextStyle(fontSize: 13, color: Colors.grey[200]),
              description: 'Scan QR codes',
              showcaseBackgroundColor: Colors.blueGrey[800],
              textColor: Colors.white,
              shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: IconButton(
                onPressed: () async {
                  String codeSanner =
                      await BarcodeScanner.scan(); //barcode scnner
                  setState(() {
                    qrCodeResult = codeSanner;
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DocPage(
                              title: 'Doctor',
                              clickedDoc: "xH3e5OUc63ZrohLgxsAy1u9zZBj1",
                            )),
                  );
                },
                icon: Icon(Icons.qr_code_scanner,
                    color: Theme.of(context).primaryColorDark),
              ),
            ),
            IconButton(
              onPressed: () async {
                await _auth.signOut();
              },
              icon: Icon(Icons.exit_to_app,
                  color: Theme.of(context).primaryColorDark),
            ),
          ],
          centerTitle: true,
          leading: Builder(
              builder: (context) => IconButton(
                    icon: Icon(
                      Icons.menu_rounded,
                      color: Theme.of(context).primaryColorDark,
                      size: 33,
                    ),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ))),
      drawer: Drawer(
        child: Container(
          color: Theme.of(context).primaryColor,
          child: ListView(
            children: <Widget>[
              Container(
                child: Image.asset('assets/inside/images.png'),
              ),
              Divider(
                height: 5.0,
                color: Colors.black45,
              ),
              Container(
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Profile(
                                isfromdrawer: true,
                              )),
                    );
                  },
                  title: Text(
                    "Profile",
                    style: TextStyle(fontSize: 18.0, color: Colors.black),
                  ),
                  leading: Icon(Icons.person),
                ),
              ),
              Divider(
                height: 5.0,
                color: Colors.black45,
              ),
              Container(
                child: ListTile(
                  title: Text(
                    "Legal",
                    style: TextStyle(fontSize: 18.0, color: Colors.black),
                  ),
                  leading: Icon(Icons.list),
                ),
              ),
              Divider(
                height: 5.0,
                color: Colors.black45,
              ),
              Container(
                child: ListTile(
                  title: Text(
                    "About Us",
                    style: TextStyle(fontSize: 18.0, color: Colors.black),
                  ),
                  leading: Icon(Icons.bookmark_border),
                ),
              ),
              Divider(
                height: 5.0,
                color: Colors.black45,
              ),
              Container(
                child: ListTile(
                  title: Text(
                    "Feedback",
                    style: TextStyle(fontSize: 18.0, color: Colors.black),
                  ),
                  leading: Icon(Icons.flash_on),
                ),
              ),
              Divider(
                height: 2.0,
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          //Appointment(),
          DocPage(clickedDoc: "xH3e5OUc63ZrohLgxsAy1u9zZBj1",),
          Prescription(),
        ],
        controller: controller,
      ),
      bottomNavigationBar: new Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
        elevation: 5,
        color: Theme.of(context).primaryColor,
        child: new TabBar(
          indicatorColor: Colors.white,
          tabs: <Widget>[
            Showcase(
              key: _one,
              overlayColor: Colors.white,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              title: "Appointments",
              titleTextStyle: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              descTextStyle: TextStyle(fontSize: 13, color: Colors.grey[200]),
              description: 'Find your upcoming appointments here',
              showcaseBackgroundColor: Colors.teal[800],
              textColor: Colors.white,
              shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: new Tab(
                icon: new Icon(
                  Icons.notifications,
                  size: 30.0,
                ),
              ),
            ),
            Showcase(
              key: _two,
              overlayColor: Colors.white,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              title: "Prescriptions",
              titleTextStyle: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              descTextStyle: TextStyle(fontSize: 13, color: Colors.grey[200]),
              description: 'Never loose track of your course',
              showcaseBackgroundColor: Colors.cyan[900],
              textColor: Colors.white,
              shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: new Tab(
                icon: new Icon(
                  Icons.local_parking,
                  size: 30.0,
                ),
              ),
            ),
          ],
          controller: controller,
        ),
      ),
    ));
  }
}
