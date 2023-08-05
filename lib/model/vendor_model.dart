class VendorModel {
  String name;
  String email;
  // String bio;
  String profilePic;
  // String createdAt;
  String phoneNumber;
  String pincode;
  String service;
  String city;
  String uid;
  var services;

  VendorModel({
    required this.name,
    required this.email,
    // required this.bio,
    required this.profilePic,
    // required this.createdAt,
    required this.phoneNumber,
    required this.pincode,
    required this.service,
    required this.city,
    required this.uid,
    required this.services,
  });

  // from map
  factory VendorModel.fromMap(Map<String, dynamic> map) {
    return VendorModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      // bio: map['bio'] ?? '',
      uid: map['uid'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      pincode: map['pincode'] ?? '',
      service: map['service'] ?? '',
      city: map['city'] ?? '',
      // createdAt: map['createdAt'] ?? '',
      profilePic: map['profilePic'] ?? '',
      services: map['services'] ?? '',
    );
  }

  // to map
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      "uid": uid,
      // "bio": bio,
      "profilePic": profilePic,
      "phoneNumber": phoneNumber,
      "pincode": pincode,
      "service": service,
      "city": city,
      // "createdAt": createdAt,
      "services": services,
    };
  }
}
