class Profile {
  final String id;
  String name;
  String email;
  String phone;
  String address;
  String? profileImageUrl;
  DateTime? createdAt;

  Profile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    this.profileImageUrl,
    this.createdAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      profileImageUrl: json['profileImageUrl'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  String get nameInitials {
    if (name.isEmpty) return '?';
    final parts = name.split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts.last[0]}'.toUpperCase();
  }
}

class ChangePasswordRequest {
  final String email;
  final String code;
  final String newPassword;
  final String confirmPassword;

  ChangePasswordRequest({
    required this.email,
    required this.code,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'verificationCode': code,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    };
  }
}
