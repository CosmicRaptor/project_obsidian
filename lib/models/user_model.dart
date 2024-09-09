class User {
  final String id;
  final String name;
  final String aboutme;

  User({
    required this.id,
    required this.name,
    required this.aboutme,
  });

  //toJson and fromJson
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'aboutme': aboutme,
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    name: json['name'],
    aboutme: json['aboutme'],
  );
}