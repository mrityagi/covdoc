import 'package:flutter/material.dart';
import 'package:heydoc/screens/authenticate/authenticate.dart';
import 'package:heydoc/services/auth.dart';
import 'package:heydoc/shared/constants.dart';
import 'package:heydoc/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  final focus1 = FocusNode();
  String email = '';
  String password = '';
  double screenHeight;
  double screenWidth;

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
    screenWidth = MediaQuery.of(context).size.width;
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.cyan[50],
            appBar: AppBar(
              backgroundColor: Colors.blueGrey[900],
              elevation: 0.0,
              title: Text('Sign in to CovDoc'),
              actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.person),
                  label: Text('Register'),
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
                    height: screenHeight / 1.4,
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    child: Form(
                        key: _formKey,
                        child: Container(
                            child: SingleChildScrollView(
                          reverse: false,
                          child: Column(
                            children: <Widget>[
                              FittedBox(
                                fit: BoxFit.contain,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.asset(
                                      'assets/auth/patient-login.png',
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
                                      val.isEmpty ? 'Enter an email' : null,
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
                                  obscureText: true,
                                  validator: (val) => val.length < 6
                                      ? 'Enter a password 6+ chars long'
                                      : null,
                                  onChanged: (val) {
                                    setState(() => password = val);
                                  },
                                ),
                              ),
                              SizedBox(height: 15.0),
                              Container(
                                height: 50,
                                width: double.infinity,
                                child: RaisedButton(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    padding: EdgeInsets.all(12),
                                    color: Colors.cyan[900],
                                    child: Text(
                                      'Sign In',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        setState(() => loading = true);
                                        dynamic result = await _auth
                                            .signInWithEmailAndPassword(
                                                email, password);
                                        if (result == null) {
                                          setState(() {
                                            loading = false;
                                            error =
                                                'Could not sign in with those credentials';
                                          });
                                        }
                                      }
                                    }),
                              ),
                              SizedBox(height: 10.0),
                              //Center(child: GoogleButton()),
                              Text(
                                error,
                                style: TextStyle(
                                    color: Colors.red, fontSize: 14.0),
                              ),
                            ],
                          ),
                        ))),
                  ),
                ),
              ],
            ));
  }
}
