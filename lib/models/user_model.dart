enum UserType { client, rider }

class User {
  int id;
  String email;
  String name;
  String lastName;
  String type;
  bool verified;
  bool active;
  int walletBalance;
  DateTime createdAt;
  DateTime updatedAt;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.lastName,
    required this.type,
    required this.verified,
    required this.active,
    required this.walletBalance,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as int,
        email: json['email'] as String,
        name: json['name'] as String,
        lastName: json['lastName'] as String,
        type: json['type'] as String,
        verified: json['verified'] as bool,
        active: json['active'] as bool,
        walletBalance: json['wallet_balance'] as int,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
        'lastName': lastName,
        'type': type,
        'verified': verified,
        'active': active,
        'wallet_balance': walletBalance,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  User copyWith({
    int? id,
    String? email,
    String? name,
    String? lastName,
    String? password,
    String? type,
    bool? verified,
    bool? active,
    int? walletBalance,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      type: type ?? this.type,
      verified: verified ?? this.verified,
      active: active ?? this.active,
      walletBalance: walletBalance ?? this.walletBalance,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
