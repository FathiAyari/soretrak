class Cusers {
  String? uid;
  String name;
  String last_name;
  String role;
  String email;
  String? password;

  Cusers({
    this.uid,
    required this.name,
    required this.last_name,
    required this.email,
    required this.role,
    this.password,
  });

  factory Cusers.fromJson(Map<String, dynamic> json) {
    return Cusers(
      uid: json["uid"],
      name: json["name"],
      last_name: json["last_name"],
      email: json["email"],
      role: json["role"],
    );
  }
  Map<String, dynamic> Tojson(String id) {
    return {
      "uid": id,
      "name": name,
      "last_name": last_name,
      "email": email,
      "role": role,
      "password": password,
    };
  }
}
