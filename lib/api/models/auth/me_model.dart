class MeUserModel {
  String? id;
  String? username;
  String? name;
  String? role;
  String? email;
  String? profilePictureUrl;

  MeUserModel({
    this.id,
    this.username,
    this.name,
    this.role,
    this.email,
    this.profilePictureUrl,
  });

  MeUserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    name = json['name'];
    role = json['role'];
    email = json['email'];
    profilePictureUrl = json['profilePictureUrl'];
  }
}
