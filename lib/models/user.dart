class User {
  final String uid;
  final String name;
  User({this.uid, this.name});
}

class UserData {
  final String uid;
  final String name;
  final String phone;
  final String address;
  final String dob;
  final String gender;

  UserData(
      {this.uid, this.name, this.phone, this.address, this.dob, this.gender});
}
