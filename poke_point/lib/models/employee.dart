class Employee {
  int id;
  int idCompany;
  String name;
  String nif;
  String address;
  String email;
  String phone;

  Employee(this.id, this.idCompany, this.name, this.nif, this.address,
      this.email, this.phone);

  factory Employee.fromJson(Map<String, dynamic> json) {
    return json == null
        ? json
        : Employee(json['id'], json['idCompany'], json['name'], json['nif'],
            json['address'], json['email'], json['phone']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idCompany': idCompany,
      'name': name,
      'nif': nif,
      'address': address,
      'email': email,
      'phone': phone
    };
  }
}
