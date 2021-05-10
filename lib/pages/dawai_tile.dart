import 'package:flutter/material.dart';
import 'package:heydoc/models/dawai.dart';
import 'package:heydoc/models/user.dart';
import 'package:heydoc/services/database.dart';
import 'package:heydoc/pages/prescriptions.dart';
import 'package:provider/provider.dart';

class DawaiTile extends StatelessWidget {
  final Dawai dawai;
  DawaiTile({this.dawai});

  @override
  Widget build(BuildContext context) {
    String leading = dawai.afterMeal ? 'After Meal' : 'Before Meal';
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        child: Container(
          //height: 175,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.blueGrey.withOpacity(.3),
                    offset: Offset(0, 8),
                    blurRadius: 5)
              ],
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Colors.grey[50], Colors.white]),
              borderRadius: BorderRadius.circular(25.0),
              border: Border.all(color: Colors.blueGrey)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                isThreeLine: true,
                title: Text(
                  "${dawai.name}",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: Container(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Take     $leading ",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold),
                        ),
                        Text("From    ${dawai.durStart} ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                            ) //fontWeight: FontWeight.bold),
                            ),
                        Text("Till        ${dawai.durEnd} ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                            ) //fontWeight: FontWeight.bold),
                            ),
                      ]),
                ),
                trailing: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new IconButton(
                      icon: new Icon(dawai.t1 == ""
                          ? Icons.wb_sunny_outlined
                          : Icons.wb_sunny_rounded),
                      color:
                          dawai.t1 == "" ? Colors.red[600] : Colors.green[900],
                      padding: new EdgeInsets.only(top: 10, bottom: 20),
                      iconSize: 30,
                      onPressed: () {},
                    ),
                    new IconButton(
                        icon: new Icon(dawai.t2 == ""
                            ? Icons.fastfood_outlined
                            : Icons.fastfood_rounded),
                        disabledColor: Colors.grey,
                        color: dawai.t2 == ""
                            ? Colors.red[600]
                            : Colors.green[900],
                        padding: new EdgeInsets.only(top: 10, bottom: 20),
                        iconSize: 30,
                        onPressed: () {}),
                    new IconButton(
                      icon: new Icon(dawai.t3 == ""
                          ? Icons.nights_stay_outlined
                          : Icons.nights_stay_rounded),
                      iconSize: 30,
                      color:
                          dawai.t3 == "" ? Colors.red[600] : Colors.green[900],
                      padding: new EdgeInsets.only(top: 10, bottom: 20),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class DawaiList extends StatefulWidget {
  @override
  _DawaiListState createState() => _DawaiListState();
}

class _DawaiListState extends State<DawaiList> {
  void remove(List<Dawai> dawais, int index, uid) async {
    await plugin.cancelNotification(int.parse(dawais[index].uid));
    await DatabaseService(uid: uid).deleteDawai(dawais[index].uid);
    setState(() {
      dawais.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    final dawais = Provider.of<List<Dawai>>(context) ?? [];

    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: dawais.length,
      itemBuilder: (context, index) {
        Dawai item = dawais[index];
        List<String> end = dawais[index].durEnd.split('-');
        if (DateTime.now().isAfter(DateTime(
            int.parse(end[2]),
            int.parse(end[1]),
            int.parse(end[0]),
            23,
            59,
            59))) remove(dawais, index, user.uid);
        return Dismissible(
          key: Key(item.name),
          onDismissed: (direction) => remove(dawais, index, user.uid),
          background: Container(color: Colors.red),
          child: DawaiTile(
            dawai: item,
          ),
        );
      },
    );
  }
}
