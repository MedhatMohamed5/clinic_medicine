class UserModel {
  late String name;
  String? uid;
  late String email;
  late String phone;
  late String bio;
  late String coverImage;
  late String image;
  late bool isEmailVerified;

  UserModel({
    this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.image,
    required this.coverImage,
    required this.bio,
    required this.isEmailVerified,
  });

  UserModel.fromJson(String uid, Map<String, dynamic>? json) {
    this.uid = uid;
    this.name = json?['name'] ?? '';
    this.email = json?['email'] ?? '';
    this.phone = json?['phone'] ?? '';
    this.image = json?['image'] ?? '';
    this.bio = json?['bio'] ?? '';
    this.coverImage = json?['coverImage'] ?? '';
    this.isEmailVerified = json?['isEmailVerified'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['isEmailVerified'] = this.isEmailVerified;
    data['image'] = this.image;
    data['bio'] = this.bio;
    data['coverImage'] = this.coverImage;
    return data;
  }
}
