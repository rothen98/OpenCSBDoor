class Door{
  final String name;
  final String key;
  final String image;

  Door({this.name, this.key, this.image});

  factory Door.fromJson(Map<String, dynamic> json) {
    return Door(name: json['name'], key: json['key'], image:json['image']);
  }
}