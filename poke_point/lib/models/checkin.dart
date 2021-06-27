class CheckIn {
  int id;
  int idWorkplace;
  int idCheckInType;
  int idTimecard;
  String timestamp;

  CheckIn(this.id, this.idWorkplace, this.idCheckInType, this.idTimecard,
      this.timestamp);

  factory CheckIn.fromJson(Map<String, dynamic> json) {
    return CheckIn(json['id'], json['idWorkplace'], json['idCheckInType'],
        json['idTimecard'], json['timestamp']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idWorkplace': idWorkplace,
      'idCheckInType': idCheckInType,
      'idTimecard': idTimecard,
      'timestamp': timestamp
    };
  }
}
