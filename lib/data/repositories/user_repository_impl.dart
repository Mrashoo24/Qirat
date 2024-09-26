import 'package:dartz/dartz.dart';
import 'package:eshop/core/usecases/usecase.dart';
import 'package:eshop/data/models/user/user_model.dart';
import 'package:eshop/domain/usecases/user/sign_up_usecase.dart';

import '../../../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/user/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../data_sources/local/user_local_data_source.dart';
import '../data_sources/remote/user_remote_data_source.dart';
import '../models/user/authentication_response_model.dart';
import 'package:firebase_auth/firebase_auth.dart' as fire;

typedef _DataSourceChooser = Future<fire.UserCredential> Function();

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserModel>> signIn(params) async {
    return await _authenticate(() {
      return remoteDataSource.signInWithGoogle(params);
    });
  }

  // @override
  // Future<Either<Failure, User>> signUp(params) async {
  //   return await _authenticate(() {
  //     return remoteDataSource.signUp(params);
  //   });
  // }

  @override
  Future<Either<Failure, User>> getCachedUser() async {
    try {
      final user = await localDataSource.getUser();
      return Right(user);
    } on CacheFailure {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, NoParams>> signOut() async {
    try {
      await localDataSource.clearCache();
      return Right(NoParams());
    } on CacheFailure {
      return Left(CacheFailure());
    }
  }

  Future<Either<Failure, UserModel>> _authenticate(
    _DataSourceChooser getDataSource,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteResponse = await getDataSource();
        var userName = (remoteResponse.user?.displayName ?? "").split(" ");

        UserModel userModel = UserModel(
            id: remoteResponse.user?.uid ?? "",
            firstName: userName.length > 1 ? userName[0] : "",
            lastName: userName.length > 1 ? userName[1] : "",
            email: remoteResponse.user?.email ?? "",token: "");

        var gettingUser = await getUser(remoteResponse.user!.uid);

        UserModel? currentUser;

      var a =  await gettingUser.fold((failure) async {
          currentUser = userModel;
          await updateUser(userModel);
          return Right(userModel);
        }, (user) async {
          currentUser = user;
          await updateUser(user!);
          return Right(user);
        });

          return Right(a.value);

      } on Failure catch (failure) {
        return Left(failure);
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, User>> signUp(SignUpParams params) {
    // TODO: implement signUp
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, User>> updateUser(UserModel params) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteResponse = await remoteDataSource.updateUser(params);
        localDataSource.saveToken(remoteResponse.id);
        localDataSource.saveUser(remoteResponse);
        return Right(remoteResponse);
      } on Failure catch (failure) {
        return Left(failure);
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, UserModel?>> getUser(String uid) async {
    try {
      final remoteResponse = await remoteDataSource.getUser(uid);

      if(remoteResponse != null){
        return Right(remoteResponse);
      }else{
        return Left(AuthenticationFailure());
      }
    } on Failure catch (failure) {
      return Left(failure);
    }
  }
}
