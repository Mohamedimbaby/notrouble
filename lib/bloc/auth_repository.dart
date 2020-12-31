import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:notrouble/models/user.dart';
import 'package:notrouble/utils/Strings.dart';
import 'package:notrouble/utils/sharedPreference.dart';

class AuthRepository {
static AuthRepository _authRepository ;
static FirebaseAuth auth ;
CollectionReference userPreference;

AuthRepository._(){
  auth = FirebaseAuth.instance;
  }
  static AuthRepository getInstance (){
    if (_authRepository ==null ){
      _authRepository = AuthRepository._();
    }
     return _authRepository;
  }
   Future<UserCredential> login({String email , String password })async{
     UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
     return userCredential;
  }   Future<bool> logout()async{
  try {
    await auth.signOut();
  return true;
  }
  catch (ex){
    return false;
  }
  }
   Future <UserCredential> register({UserModel user})async{
     UserCredential userCredential = await AuthRepository.auth.createUserWithEmailAndPassword(email: user.email, password: user.password);
     userPreference =  Firestore.instance.collection(Strings.tableNameUsers);
     SharedPreferencesOperations.saveMyId(userCredential.user.uid);
    await addRegistrationInfo(user);
     print(userCredential.user.email);
     return userCredential;
  }

  Future<bool> addRegistrationInfo(UserModel user) async{
  bool done = false ;
  await userPreference.doc().set({
      "id": SharedPreferencesOperations.getMyId(),
      "displayName": user.displayName,
      "email": user.email
    }).then((value) => {
    done = true
    }).catchError((onError){
      done = false;
  });
  return done;
  }


}

