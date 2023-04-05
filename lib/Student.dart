class Student {
  String? id;
  String? firstName;
  String? lastName;
  String? apematerno;
  String? telefono;
  String? correo;

  Student({this.id, this.firstName, this.lastName, this.apematerno, this.telefono, this.correo});

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      apematerno: json['apematerno'] as String?,
      telefono: json['telefono'] as String?,
      correo: json['correo'] as String?,
    );
  }
}