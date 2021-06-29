class CheckIn {
  int id;
  int idWorkplace;
  int idCheckInType;
  int idTimecard;
  String timestamp;
  bool offline;

  CheckIn(int id, int idWorkplace, int idCheckInType, int idTimecard,
      String timestamp,
      [int offline = 0]) {
    this.id = id;
    this.idWorkplace = idWorkplace;
    this.idCheckInType = idCheckInType;
    this.idTimecard = idTimecard;
    this.timestamp = timestamp;
    this.offline = offline == 0 ? false : true;
  }

  factory CheckIn.fromJson(Map<String, dynamic> json) {
    return json == null
        ? json
        : CheckIn(json['id'], json['idWorkplace'], json['idCheckInType'],
            json['idTimecard'], json['timestamp']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idWorkplace': idWorkplace,
      'idCheckInType': idCheckInType,
      'idTimecard': idTimecard,
      'timestamp': timestamp,
      'offline': offline ? 1 : 0
    };
  }
}
