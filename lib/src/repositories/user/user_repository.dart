import 'package:dw_barbershop/src/core/exceptions/auth_Exception.dart';
import 'package:dw_barbershop/src/core/exceptions/repository_exception.dart';
import 'package:dw_barbershop/src/core/fp/nil.dart';
import 'package:dw_barbershop/src/model/user_model.dart';

import '../../core/fp/either.dart';

abstract interface class UserRepository {
  Future<Either<AuthException, String>> login(String email, String password);

  Future<Either<RepositoryException, UserModel>> me();

  Future<Either<RepositoryException, Nil>> registerAdmin((
      {String name, String email, String password}) userData,
  );
}