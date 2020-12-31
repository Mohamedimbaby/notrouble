import 'package:firebase_auth/firebase_auth.dart';
import 'package:notrouble/bloc/auth_repository.dart';
import 'package:notrouble/utils/sharedPreference.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Initializer {
  static initializeAppResources ()async{
    AuthRepository.auth=  FirebaseAuth.instance;
  }
}