import 'package:dartz/dartz.dart';
import 'package:eshop/data/models/user/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart' as fire;

import '../../../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/user/user.dart';
import '../usecases/user/sign_in_usecase.dart';
import '../usecases/user/sign_up_usecase.dart';

abstract class UserRepository {
  Future<Either<Failure, UserModel>> signIn(UserModel params);
  Future<Either<Failure, UserModel?>> getUser(String uid);
  Future<Either<Failure, User>> signUp(SignUpParams params);
  Future<Either<Failure, NoParams>> signOut();
  Future<Either<Failure, User>> getCachedUser();
  Future<Either<Failure, User>> updateUser(UserModel params);
}
