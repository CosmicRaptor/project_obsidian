class User {
  final String? id;
  final String? name;
  final String? aboutme;

  User({
    this.id,
    this.name,
    this.aboutme,
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

  User copyWith({
    String? id,
    String? name,
    String? aboutme,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      aboutme: aboutme ?? this.aboutme,
    );
  }
}