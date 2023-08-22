sealed class UserModel {
  final int id;
  final String name;
  final String email;
  final String? avatar;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatar
  });

  factory UserModel.fromMap(Map<String, dynamic> json) {
    return switch(json['profile']){
      'ADM' => UserModelADM.fromMap(json),
      'EMPLOYEE' => UserModelEmployee.fromMap(json),
      _ => throw ArgumentError('User profile not found')
    };
  }

}

class UserModelADM extends UserModel {
  final List<String>? workDays;
  final List<int>? workHours;

  UserModelADM({
  required super.id,
  required super.name,
  required super.email,
  super.avatar,
  this.workDays,
  this.workHours
  });

  factory UserModelADM.fromMap(Map<String, dynamic> json) {
    return switch(json){
    {
    'id': final int id,
    'name': final String name,
    'email': final String email,
    } => UserModelADM(
      id: id,
      name: name,
      email: email,
      avatar: json['avatar'],
      workDays: json['workDays']?.cast<String>(),
      workHours: json['workHours']?.cast<int>()
    ),
    _ => throw ArgumentError('Invalid json')
    };
  }
}

class UserModelEmployee extends UserModel{
  final int barbershopId;
  final List<String> workDays;
  final List<int> workHours;

  UserModelEmployee({
    required super.id,
    required super.name,
    required super.email,
    super.avatar,
    required this.barbershopId,
    required this.workDays,
    required this.workHours
  });

  factory UserModelEmployee.fromMap(Map<String, dynamic> json) {
    return switch(json){
    {
    'id': final int id,
    'name': final String name,
    'email': final String email,
    'barbershopId': final int barbershopId,
    'workDays': final List<String> workDays,
    'workHours': final List<int> workHours
    } => UserModelEmployee(
      id: id,
      name: name,
      email: email,
      avatar: json['avatar'],
      barbershopId: barbershopId,
      workDays: workDays.cast<String>(),
      workHours: workHours.cast<int>()
    ),
    _ => throw ArgumentError('Invalid json')
    };
  }
}