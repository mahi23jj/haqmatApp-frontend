class AuthModel {
  final String token;
  final String userId;
  final String name;
  final String phoneNumber;
  final Subcity subcity;
  final String? address;

  AuthModel({
    required this.token,
    required this.userId,
    required this.name,
    required this.phoneNumber,
    required this.subcity,
    this.address,
  });

  // from json
  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      token: json['token'],
      name: json['user']['name'],
      userId: json['user']['id'],
      phoneNumber: json['user']['phoneNumber'],
      subcity: Subcity.values.firstWhere(
        (e) => e.toString().split('.').last == json['user']['subcity'],
        orElse: () => Subcity.addisKetema,
      ),
      address: json['user']['Adress'],
    );
  }
}

enum Subcity {
  addisKetema,
  akakiKality,
  arada,
  bole,
  gullele,
  kirkos,
  kolfeKeranio,
  lideta,
  nifasSilkLafto,
  yeka,
}

//^.*phoneNumber.*\n?
