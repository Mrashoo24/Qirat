import 'dart:convert';

import 'package:eshop/core/error/failures.dart';
import 'package:eshop/data/firebase/firebase_services.dart';
import 'package:eshop/data/models/user/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../../../core/constant/strings.dart';
import '../../../domain/usecases/user/sign_in_usecase.dart';
import '../../../domain/usecases/user/sign_up_usecase.dart';
import '../../models/user/authentication_response_model.dart';

abstract class UserRemoteDataSource {
  Future<UserCredential> signInWithGoogle(UserModel params);
  Future<UserModel> updateUser(UserModel params);
  Future<UserModel?> getUser(String uid);
  Future<AuthenticationResponseModel> signUp(SignUpParams params);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirebaseService client;
  UserRemoteDataSourceImpl({required this.client});

  @override
  Future<UserCredential> signInWithGoogle(UserModel params) async {
    // Trigger the authentication flow
    try {


GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();



      // final GoogleSignInAccount? googleUser =
      //     await GoogleSignIn(scopes: ["profile", "email"]).signIn();
      //
      // // Obtain the auth details from the request
      // final GoogleSignInAuthentication? googleAuth =
      //     await googleUser?.authentication;
      //
      // var googleAuthToken = googleAuth?.idToken;
      //
      // // Create a new credential
      // final credential = GoogleAuthProvider.credential(
      //   accessToken: googleAuth?.accessToken,
      //   idToken: googleAuth?.idToken,
      // );



      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithPopup(googleAuthProvider);
      // var userName = (userCredential.user?.displayName ?? "").split(" ");
      // UserModel userModel = UserModel(
      //     id: userCredential.user?.uid ?? "",
      //     firstName: userName.length > 1 ? userName[0] : "",
      //     lastName: userName.length > 1 ? userName[1] : "",
      //     email: userCredential.user?.email ?? "");

      return userCredential;
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> updateUser(UserModel params) async {
    // Trigger the authentication flow
    try {
    // var toklen =  await FirebaseMessaging.instance.getToken(vapidKey: "BDhxFp_Vov1qHsjtF65y5Q7s54DHrdclkT9vh_vTtzlE7LbMwZlegW4DDz4roGNnUndtpzOZT15Zs9fmmjtTjm8");

      UserModel userModel = UserModel(
          id: params.id ?? "",
          firstName: params.firstName,
          lastName: params.lastName,
          email: params.email,deliveryInfos: params.deliveryInfos, token:"".toString());

      await client.setDocument(collectionPath: "users", data: userModel.toJson(),merge: true,documentId:userModel.id );

      return userModel;
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<AuthenticationResponseModel> signUp(SignUpParams params) async {
    // final response =
    //     await client.post(Uri.parse('$baseUrl/authentication/local/sign-up'),
    //         headers: {
    //           'Content-Type': 'application/json',
    //         },
    //         body: json.encode({
    //           'firstName': params.firstName,
    //           'lastName': params.lastName,
    //           'email': params.email,
    //           'password': params.password,
    //         }));
    // if (response.statusCode == 201) {
    //   return authenticationResponseModelFromJson(response.body);
    // } else if (response.statusCode == 400 || response.statusCode == 401) {
    //   throw CredentialFailure();
    // } else {
      throw ServerException();
    // }
  }

  @override
  Future<UserModel?> getUser(String uid) async {
    try{
      var map = await client.getSingleDocument(
          collectionPath: "users", documentId: uid);

      if(map.data() != null){
        return UserModel.fromJson(map.data()!);
      }else{
        return null;
      }
    }

   catch(e) {
     throw ServerException();
    }
  }
}
