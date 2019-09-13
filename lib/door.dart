class Door{
  final String name;
  final String key;

  Door({this.name, this.key});

  factory Door.fromJson(Map<String, dynamic> json) {
    return Door(name: json['name'], key: json['key']);
  }
}