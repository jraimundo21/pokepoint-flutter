class Workplace {
  int id;
  int idCompany;
  String name;
  String address;
  String latitude;
  String longitude;

  Workplace(this.id, this.idCompany, this.name, this.address, this.latitude,
      this.longitude);

  factory Workplace.fromJson(Map<String, dynamic> json) {
    return Workplace(json['id'], json['idCompany'], json['name'],
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
