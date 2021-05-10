import 'package:flutter/material.dart';
import 'package:heydoc/screens/authenticate/authenticate.dart';
import 'package:heydoc/services/auth.dart';
import 'package:heydoc/shared/constants.dart';
import 'package:heydoc/shared/loading.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  double screenHeight;

  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final focus4 = FocusNode();
  final focus5 = FocusNode();

  String email = '';
  String password = '';
  String name = '';
  String phone = '';
  String address = '';
  String gender = '';
  String dob = '';

  int genderRadio;
  @override
  void initState() {
    super.initState();
    genderRadio = 0;
    fromregistered = true;
  }

  DateTime selectedDate = DateTime.now();
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1920, 1),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        dob = selectedDate.day.toString() +
            '/' +
            selectedDate.month.toString() +
            '/' +
            selectedDate.year.toString();
      });
  }

  Widget upperHalf(BuildContext context) {
    return Container(
      height: screenHeight / 3,
      decoration: BoxDecoration(
        color: Colors.blueGrey[900],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(35),
          bottomRight: Radius.circular(35),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.cyan[50],
            appBar: AppBar(
              backgroundColor: Colors.blueGrey[900],
              elevation: 0.0,
              title: Text('Register with CovDoc'),
              actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.person),
                  label: Text('Sign In'),
                  textColor: Colors.white,
                  onPressed: () => widget.toggleView(),
                ),
              ],
            ),
            body: Stack(
              children: <Widget>[
                upperHalf(context),
                Padding(
                  padding:
                      EdgeInsets.only(left: 15, right: 15, top: 30, bottom: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    height: screenHeight / 1.2,
                    child: Form(
                      key: _formKey,
                      child: Container(
                        child: SingleChildScrollView(
                          reverse: false,
                          child: Column(
                            children: <Widget>[
                              FittedBox(
                                fit: BoxFit.fill,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.asset(
                                      'assets/auth/patient-register.jpg',
                                      width: 400.0,
                                      height: 300),
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: TextFormField(
                                  decoration: textInputDecoration.copyWith(
                                    hintText: 'Email',
                                    enabledBorder: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(15.0),
                                      borderSide:
                                          BorderSide(color: Colors.teal[50]),
                                    ),
                                    focusedBorder: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(15.0),
                                      borderSide:
                                          BorderSide(color: Colors.teal[900]),
                                    ),
                                  ),
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (v) {
                                    FocusScope.of(context).requestFocus(focus1);
                                  },
                                  validator: (val) =>
                                      RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                              .hasMatch(val)
                                          ? null
                                          : 'Enter a Valid Email',
                                  onChanged: (val) {
                                    setState(() => email = val);
                                  },
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: TextFormField(
                                  focusNode: focus1,
                                  decoration: textInputDecoration.copyWith(
                                    hintText: 'Password',
                                    enabledBorder: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(15.0),
                                      borderSide:
                                          BorderSide(color: Colors.teal[50]),
                                    ),
                                    focusedBorder: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(15.0),
                                      borderSide:
                                          BorderSide(color: Colors.teal[900]),
                                    ),
                                  ),
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (v) {
                                    FocusScope.of(context).requestFocus(focus2);
                                  },
                                  obscureText: true,
                                  validator: (val) => val.length < 6
                                      ? 'Enter a password 6+ chars long'
                                      : null,
                                  onChanged: (val) {
                                    setState(() => password = val);
                                  },
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: TextFormField(
                                  focusNode: focus2,
                                  decoration: textInputDecoration.copyWith(
                                    hintText: 'Your Name',
                                    enabledBorder: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(15.0),
                                      borderSide:
                                          BorderSide(color: Colors.teal[50]),
                                    ),
                                    focusedBorder: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(15.0),
                                      borderSide:
                                          BorderSide(color: Colors.teal[900]),
                                    ),
                                  ),
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (v) {
                                    FocusScope.of(context).requestFocus(focus3);
                                  },
                                  validator: (val) => val.length < 3
                                      ? 'Name aleast should be 3 characters!'
                                      : null,
                                  onChanged: (val) {
                                    setState(() => name = val);
                                  },
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: TextFormField(
                                  focusNode: focus3,
                                  decoration: textInputDecoration.copyWith(
                                    hintText: 'Phone No .',
                                    enabledBorder: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(15.0),
                                      borderSide:
                                          BorderSide(color: Colors.teal[50]),
                                    ),
                                    focusedBorder: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(15.0),
                                      borderSide:
                                          BorderSide(color: Colors.teal[900]),
                                    ),
                                  ),
                                  keyboardType: TextInputType.phone,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (v) {
                                    FocusScope.of(context).requestFocus(focus4);
                                  },
                                  validator: (val) => val.length != 10
                                      ? 'Not a valid Phone No.'
                                      : null,
                                  onChanged: (val) {
                                    setState(() => phone = val);
                                  },
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: TextFormField(
                                  focusNode: focus4,
                                  decoration: textInputDecoration.copyWith(
                                    hintText: 'Address ',
                                    enabledBorder: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(15.0),
                                      borderSide:
                                          BorderSide(color: Colors.teal[50]),
                                    ),
                                    focusedBorder: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(15.0),
                                      borderSide:
                                          BorderSide(color: Colors.teal[900]),
                                    ),
                                  ),
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (v) {
                                    FocusScope.of(context).requestFocus(focus5);
                                  },
                                  validator: (val) => val.isEmpty
                                      ? 'Address can not be empty!'
                                      : null,
                                  onChanged: (val) {
                                    setState(() => address = val);
                                  },
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: TextFormField(
                                  focusNode: focus5,
                                  readOnly: true,
                                  enabled: true,
                                  decoration: textInputDecoration.copyWith(
                                    hintStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0,
                                    ),
                                    hintText:
                                        'Date of Birth :   ${selectedDate.day}/${selectedDate.month}/${selectedDate.year} ',
                                    prefixIcon: Icon(Icons.calendar_today),
                                    enabledBorder: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(15.0),
                                      borderSide:
                                          BorderSide(color: Colors.teal[50]),
                                    ),
                                    focusedBorder: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(15.0),
                                      borderSide:
                                          BorderSide(color: Colors.teal[900]),
                                    ),
                                  ),
                                  onTap: () => _selectDate(context),
                                  onChanged: (val) {
                                    setState(() => dob = val);
                                  },
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                'Gender :',
                                style: new TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                              new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Radio(
                                    value: 1,
                                    groupValue: genderRadio,
                                    onChanged: (val) {
                                      setState(() {
                                        genderRadio = val;
                                        gender = 'Male';
                                      });
                                    },
                                  ),
                                  new Text(
                                    'Male',
                                    style: new TextStyle(fontSize: 15.0),
                                  ),
                                  Radio(
                                    value: 2,
                                    groupValue: genderRadio,
                                    onChanged: (val) {
                                      setState(() {
                                        genderRadio = val;
                                        gender = 'Female';
                                      });
                                    },
                                  ),
                                  new Text(
                                    'Female',
                                    style: new TextStyle(
                                      fontSize: 15.0,
                                    ),
                                  ),
                                  Radio(
                                    value: 3,
                                    groupValue: genderRadio,
                                    onChanged: (val) {
                                      setState(() {
                                        genderRadio = val;
                                        gender = 'Other';
                                      });
                                    },
                                  ),
                                  Text(
                                    'Other',
                                    style: new TextStyle(
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.0),
                              SizedBox(height: 10.0),
                              Container(
                                height: 50,
                                width: double.infinity,
                                child: RaisedButton(
                                    color: Colors.cyan[900],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    padding: EdgeInsets.all(12),
                                    child: Text(
                                      'Register',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        setState(() => loading = true);
                                        dynamic result = await _auth
                                            .registerWithEmailAndPassword(
                                                email,
                                                password,
                                                name,
                                                phone,
                                                address,
                                                gender,
                                                dob);
                                        if (result == null) {
                                          setState(() {
                                            setState(() => loading = true);
                                            error =
                                                'Please supply a valid email';
                                          });
                                        }
                                      }
                                    }),
                              ),
                              SizedBox(height: 5.0),
                              Text(
                                error,
                                style: TextStyle(
                                    color: Colors.red, fontSize: 10.0),
                              ),
                              SizedBox(height: 5.0),
                              //Center(child: GoogleButton()),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ));
  }
}
