import 'package:dartz/dartz.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/student/domain/entities/student_entity.dart';

abstract interface class IStudentRepository {
  Future<Either<Failure, List<StudentEntity>>> getAllStudents();
  Future<Either<Failure, StudentEntity>> getStudentById(String studentId);
  Future<Either<Failure, StudentEntity>> createStudent(StudentEntity student);
  Future<Either<Failure, StudentEntity>> updateStudent(StudentEntity student);
  Future<Either<Failure, void>> deleteStudent(String studentId);
}
