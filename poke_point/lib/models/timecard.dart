class Timecard {
  int id;
  int idEmployee;
  int worktime;

  Timecard(this.id, this.idEmployee, this.worktime);

  factory Timecard.fromJson(Map<String, dynamic> json) {
    return Timecard(json['id'], json['employee'], json['time_work']);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'idEmployee': idEmployee, 'worktime': worktime};
  }
}
