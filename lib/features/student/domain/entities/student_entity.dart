import 'package:equatable/equatable.dart';

class StudentEntity extends Equatable {
  final String? studentId;
  final String batchId;
  final String name;
  final String email;
  final String username;
  final String password;
  final String? phoneNumber;
  final String? profilePicture;
  final String? status;

  const StudentEntity({
    this.studentId,
    required this.batchId,
    required this.name,
    required this.email,
    required this.username,
    required this.password,
    this.phoneNumber,
    this.profilePicture,
    this.status,
  });

  @override
  List<Object?> get props => [
    studentId,
    batchId,
    name,
    email,
    username,
    password,
    phoneNumber,
    profilePicture,
    status,
  ];
}
