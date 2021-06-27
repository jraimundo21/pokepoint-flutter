class CheckOut {
  int id;
  int idWorkplace;
  int idTimecard;
  String timestamp;

  CheckOut(this.id, this.idWorkplace, this.idTimecard, this.timestamp);

  factory CheckOut.fromJson(Map<String, dynamic> json) {
    return CheckOut(json['id'], json['idWorkplace'], json['idCheckOutType'],
        json['idTimecard']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idWorkplace': idWorkplace,
      'idTimecard': idTimecard,
      'timestamp': timestamp
    };
  }
}
