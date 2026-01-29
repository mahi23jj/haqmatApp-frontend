import 'package:haqmate/features/cart/model/cartmodel.dart';

class Profile {
  final String id;
  String name;
  String email;
  String phone;
  LocationModel address;
  DateTime? createdAt;

  Profile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    this.createdAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phoneNumber'] ?? '',
      address: LocationModel.fromJson(json['area'] ?? {}),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'phoneNumber': phone, 'location': address.id};
  }

  String get nameInitials {
    if (name.isEmpty) return 'U';

    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();

    if (parts.isEmpty) return 'U';

    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }

    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}

class ChangePasswordRequest {
  final String email;
  final String code;
  final String newPassword;

  ChangePasswordRequest({
    required this.email,
    required this.code,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {'email': email, 'otp': code, 'newPassword': newPassword};
  }
}
