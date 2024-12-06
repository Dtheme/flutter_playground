class Area {
  final String code;
  final String name;
  final List<City> cityList;

  Area({
    required this.code,
    required this.name,
    required this.cityList,
  });

  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      cityList: (json['cityList'] as List<dynamic>?)
              ?.map((item) => City.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class City {
  final String code;
  final String name;
  final List<Area> areaList;

  City({
    required this.code,
    required this.name,
    required this.areaList,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      areaList: (json['areaList'] as List<dynamic>?)
              ?.map((item) => Area.fromJson(item))
              .toList() ??
          [],
    );
  }
}
