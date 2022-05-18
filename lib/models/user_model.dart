class UserModel {
  String userId;
  String? name;
  String email;
  String? phone;
  String? picture;
  String? deliveryAddress;

  UserModel(
      {required this.userId,
      this.name,
      required this.email,
      this.phone,
      this.picture,
      this.deliveryAddress});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
      'userId' : userId,
      'name' : name,
      'email' : email,
      'phone' : phone,
      'picture' : picture,
      'deliveryAddress' : deliveryAddress,
    };
    return map;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    userId: map['userId'],
    name: map['name'],
    email: map['email'],
    phone: map['phone'],
    picture: map['picture'],
    deliveryAddress: map['deliveryAddress'],
  );
}