class MeUser {
  String? id;
  String? username;
  String? name;
  String? role;
  String? email;

  MeUser({this.id, this.username, this.name, this.role, this.email});

  MeUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    name = json['name'];
    role = json['role'];
    email = json['email'];
  }
}
