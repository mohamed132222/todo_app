class MyUser {
  static const String collectionName = "user";
  String? id;
  String? email;
  String? username;

  MyUser({required this.id, required this.email, required this.username});

  Map<String, dynamic> toFireStore() {
    return {"id": id, "email": email, "username": username};
  }

  MyUser.fromFireStore(Map<String, dynamic>? data)
    : this(id: data?['id'], email: data?['email'], username: data?['username']);
}
