import 'package:dartz/dartz.dart';
import 'package:eshop/data/models/user/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart' as fire;

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../entities/user/user.dart';
import '../../repositories/user_repository.dart';

class SignInUseCase implements UseCase<UserModel, UserModel> {
  final UserRepository repository;
  SignInUseCase(this.repository);

  @override
  Future<Either<Failure, UserModel>> call(UserModel params) async {
    return await repository.signIn(params);
  }

  Future<Either<Failure, User>> updateUser(UserModel params) async {
    return await repository.updateUser(params);
  }

  Future<Either<Failure, User?>> getUser(String uid) async {
    return await repository.getUser(uid);
  }
}

class SignInParams {
  final String username;
  final String password;
  const SignInParams({
    required this.username,
    required this.password,
  });
}