import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:heydoc/models/dawai.dart';
import 'package:heydoc/models/user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference videoCollection =
      FirebaseFirestore.instance.collection('videos');
  final CollectionReference paitentCollection =
      FirebaseFirestore.instance.collection('patients');

  Future<void> updateData(String name, String phone, String address,
      String gender, String dob) async {
    return await paitentCollection.doc(uid).set({
      'name': name,
      'phone': phone,
      'address': address,
      'dob': dob,
      'gender': gender,
    });
  }

  Future<void> deleteDawai(String docid) async {
    return await paitentCollection
        .doc(uid)
        .collection('dawai')
        .doc(docid)
        .delete();
  }

  Future<void> addDawai(
      String temp,
      String name,
      String dosage,
      String durStart,
      String durEnd,
      bool notify,
      bool afterMeal,
      bool morning,
      bool afternoon,
      bool night) async {
    TimeOfDay t1 = TimeOfDay(hour: 7, minute: 0);
    TimeOfDay t2 = TimeOfDay(hour: 12, minute: 30);
    TimeOfDay t3 = TimeOfDay(hour: 19, minute: 30);
    if (afterMeal) {
      t1 = TimeOfDay(hour: 9, minute: 0);
      t2 = TimeOfDay(hour: 14, minute: 30);
      t3 = TimeOfDay(hour: 21, minute: 30);
    }
    final dawaiCollection = paitentCollection.doc(uid).collection('dawai');
    return await dawaiCollection.doc(temp).set({
      'uid': temp,
      'name': name,
      'dosage': dosage,
      'durStart': durStart,
      'durEnd': durEnd,
      'notify': notify,
      'afterMeal': afterMeal,
      't1': morning ? t1.toString() : '',
      't2': afternoon ? t2.toString() : '',
      't3': night ? t3.toString() : '',
    });
  }

  List<Dawai> _dawaiListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Dawai(
        uid: doc.data()['uid'] ?? '',
        name: doc.data()['name'] ?? '',
        dosage: doc.data()['dosage'] ?? '',
        durStart: doc.data()['durStart'] ?? '',
        durEnd: doc.data()['durEnd'] ?? '',
        notify: doc.data()['notify'] ?? false,
        afterMeal: doc.data()['afterMeal'] ?? true,
        t1: doc.data()['t1'] ?? '',
        t2: doc.data()['t2'] ?? '',
        t3: doc.data()['t3'] ?? '',
      );
    }).toList();
  }

  Stream<List<Dawai>> get dawais {
    return paitentCollection
        .doc(uid)
        .collection('dawai')
        .snapshots()
        .map(_dawaiListFromSnapshot);
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data()['name'],
      phone: snapshot.data()['phone'],
      address: snapshot.data()['address'],
      dob: snapshot.data()['dob'],
      gender: snapshot.data()['gender'],
    );
  }

  Stream<UserData> get userData {
    return paitentCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}
