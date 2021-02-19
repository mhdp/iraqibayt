class User {
  int id;
  String name;
  String email;
  String role;
  String customToken;
  String firebaseToken;
  String updatedAt;
  String createdAt;

  User({
    this.id,
    this.name,
    this.email,
    this.role,
    this.customToken,
    this.firebaseToken,
    this.updatedAt,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      customToken: json['customToken'] as String,
      firebaseToken: json['firebaseToken'] as String,
      updatedAt: json['updated_at'] as String,
      createdAt: json['created_at'] as String,
    );
  }
}
