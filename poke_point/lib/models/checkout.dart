class CheckOut {
  int id;
  int idWorkplace;
  int idTimecard;
  String timestamp;
  bool offline;

  CheckOut(int id, int idWorkplace, int idTimecard, String timestamp,
      [int offline = 0]) {
    this.id = id;
    this.idWorkplace = idWorkplace;
    this.idTimecard = idTimecard;
    this.offline = offline == 0 ? false : true;
  }

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
