class Company {
  int id;
  String name;
  String nif;
  String address;
  String email;
  String phone;

  Company(this.id, this.name, this.nif, this.address, this.email, this.phone);

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(json['id'], json['name'], json['nif'], json['address'],
        json['email'], json['phone']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'nif': nif,
      'address': address,
      'email': email,
      'phone': phone
    };
  }
}
