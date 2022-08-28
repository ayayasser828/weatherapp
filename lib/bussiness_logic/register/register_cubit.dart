import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constant/global_variables.dart';
import '../../data/models/user_model.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  void userRegister(String email, String password, String vPassword,
      String fName, String lName) {
    emit(RegisterLoading());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print(value.user!.email);
      print(value.user!.uid);
      createUser(email, fName, lName, value.user!.uid);
    }).catchError((error) {
      emit(RegisterError(error.toString()));
    });
  }

  void createUser(String email, String fName, String lName, String uId) {
    emit(CreateLoading());
    UserModel model =
        UserModel(uId: uId, email: email, fName: fName, lName: lName);
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      prefs.setString('token', uId);
      prefs.setBool("ISLOGGED", true);
      emit(CreateSuccess());
    }).catchError((error) {
      emit(CreateError(error.toString()));
    });
  }

  UserModel? userModel;

  void getUserData(String uId) {
    emit(UserDataLoading());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      userModel = UserModel.fromJson(value.data()!);
      emit(UserDataSuccess(userModel!));
    }).catchError((e) {
      emit(UserDataError(e));
    });
  }

  void updateUser(String email, String fName, String lName) {
    emit(UpdateUserLoading());
    UserModel model = UserModel(
        uId: userModel!.uId, email: email, fName: fName, lName: lName);
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .update(model.toMap())
        .then((value) {
          getUserData(userModel!.uId!);
    })
        .catchError((e) {
          emit(UpdateUserError(e));
    });
  }

  void userLogin(String email, String password) {
    emit(LoginLoading());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print(value.user?.email);
      print(value.user?.uid);
      prefs.setString('token', value.user!.uid);
      prefs.setBool("ISLOGGED", true);
      emit(LoginSuccess());
    }).catchError((error) {
      emit(LoginError(error.toString()));
    });
  }

  Icon suffix = const Icon(
    Icons.visibility_outlined,
    color: Colors.grey,
  );
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix = isPassword
        ? const Icon(
            Icons.visibility_outlined,
            color: Colors.grey,
          )
        : const Icon(
            Icons.visibility_off_outlined,
            color: Colors.grey,
          );
    emit(PasswordVisibility());
  }
}
