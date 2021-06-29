class Workplace {
  int id;
  int idCompany;
  String name;
  String address;
  double latitude;
  double longitude;

  Workplace.stringCoords(int id, int idCompany, String name, String address,
      String latitude, String longitude) {
    this.id = id;
    this.idCompany = idCompany;
    this.name = name;
    this.address = address;
    this.latitude = latitude != null ? double.parse(latitude) : 0;
    this.longitude = longitude != null ? double.parse(longitude) : 0;
  }

  Workplace(int id, int idCompany, String name, String address, double latitude,
      double longitude) {
    this.id = id;
    this.idCompany = idCompany;
    this.name = name;
    this.address = address;
    this.latitude = latitude;
    this.longitude = longitude;
  }

  factory Workplace.fromJson(Map<String, dynamic> json) {
    return json == null
        ? json
        : Workplace(json['id'], json['idCompany'], json['name'],
            json['address'], json['latitude'], json['longitude']);
  }

  factory Workplace.fromJsonStringCoords(Map<String, dynamic> json) {
    return json == null
        ? json
        : Workplace.stringCoords(json['id'], json['idCompany'], json['name'],
            json['address'], json['latitude'], json['longitude']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idCompany': idCompany,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude
    };
  }
}
