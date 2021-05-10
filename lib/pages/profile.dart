import 'package:heydoc/models/user.dart';
import 'package:heydoc/services/database.dart';
import 'package:heydoc/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:heydoc/shared/loading.dart';
import '../bottomtabnav.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart'; // For Image Picker

class Profile extends StatefulWidget {
  Profile({this.isfromdrawer});
  final bool isfromdrawer;
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();
  File _image;
  String _uploadedFileURL;
  auth.User user;
  // form values
  String _currentName;
  String _currentPhone;
  String _currentDob;
  String _currentAddress;
  String _currentGender;
  @override
  void initState() {
    super.initState();
    this.user = auth.FirebaseAuth.instance.currentUser;
    _uploadedFileURL = 'https://image.flaticon.com/icons/png/512/50/50446.png';
    try {
      StorageReference storageReference =
          FirebaseStorage.instance.ref().child('profiles/${user.uid}.jpg');
      downloadS(storageReference).then((String result) {
        setState(() {
          _uploadedFileURL = result;
        });
      });
    } catch (error) {}
  }

  Future<String> downloadS(StorageReference s) async {
    return await s.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Scaffold(
              appBar: (widget.isfromdrawer == true)
                  ? AppBar(
                      title: const Text('profile'),
                    )
                  : null,
              body: Container(
                color: Colors.grey[100],
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: Container(
                          alignment: Alignment.center,
                          child: SingleChildScrollView(
                            // new line
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                InkWell(
                                  child: Container(
                                    width: 120,
                                    height: 120,
                                    margin: EdgeInsets.all(12.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: NetworkImage(_uploadedFileURL),
                                          fit: BoxFit.fill),
                                    ),
                                  ),
                                  onTap: () async {
                                    _image = await ImagePicker.pickImage(
                                        source: ImageSource.gallery,
                                        imageQuality: 25);
                                    StorageReference storageReference =
                                        FirebaseStorage.instance
                                            .ref()
                                            .child('profiles/${user.uid}.jpg');
                                    StorageUploadTask uploadTask =
                                        storageReference.putFile(_image);
                                    uploadTask.onComplete;
                                    print('File Uploaded');

                                    //_uploadedFileURL = await storageReference.getDownloadURL();
                                  },
                                ),
                                Text(
                                  'Click update to change photo/data.',
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                SizedBox(height: 20.0),
                                TextFormField(
                                  initialValue: userData.name,
                                  decoration: textInputDecoration.copyWith(
                                      hintText: 'Your Name'),
                                  validator: (val) => val.isEmpty
                                      ? 'Please enter a name'
                                      : null,
                                  onChanged: (val) =>
                                      setState(() => _currentName = val),
                                ),
                                SizedBox(height: 20.0),
                                TextFormField(
                                  initialValue: userData.phone,
                                  decoration: textInputDecoration.copyWith(
                                      hintText: 'phone_number'),
                                  validator: (val) => val.isEmpty
                                      ? 'Please enter a valid Phone no.'
                                      : null,
                                  onChanged: (val) =>
                                      setState(() => _currentPhone = val),
                                ),
                                SizedBox(height: 20.0),
                                TextFormField(
                                  initialValue: userData.address,
                                  decoration: textInputDecoration.copyWith(
                                      hintText: 'Your complete Address'),
                                  validator: (val) => val.isEmpty
                                      ? 'Address can not be empty!'
                                      : null,
                                  onChanged: (val) =>
                                      setState(() => _currentAddress = val),
                                ),
                                SizedBox(height: 20.0),
                                TextFormField(
                                  initialValue: userData.gender,
                                  decoration: textInputDecoration.copyWith(
                                      hintText: 'Male/Female'),
                                  validator: (val) => val.isEmpty
                                      ? 'Gender can not be empty!'
                                      : null,
                                  onChanged: (val) =>
                                      setState(() => _currentGender = val),
                                ),
                                SizedBox(height: 20.0),
                                TextFormField(
                                  initialValue: userData.dob.toString(),
                                  decoration: textInputDecoration.copyWith(
                                      hintText: 'Your Date of Birth'),
                                  onChanged: (val) =>
                                      setState(() => _currentDob = val),
                                ),
                                Divider(),
                                SizedBox(
                                  width: 300,
                                  height: 50,
                                  child: RaisedButton(
                                      color: Colors.teal[400],
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(30.0)),
                                      child: Text(
                                        'Update',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                      onPressed: () async {
                                        if (_formKey.currentState.validate()) {
                                          await DatabaseService(uid: user.uid)
                                              .updateData(
                                            _currentName ?? snapshot.data.name,
                                            _currentPhone ??
                                                snapshot.data.phone,
                                            _currentAddress ??
                                                snapshot.data.address,
                                            _currentGender ??
                                                snapshot.data.gender,
                                            _currentDob ?? snapshot.data.dob,
                                          );
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    BottomTab()),
                                          );
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    BottomTab()),
                                          );
                                        }
                                      }),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
