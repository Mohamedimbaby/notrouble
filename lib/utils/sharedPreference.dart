import 'package:notrouble/utils/Strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesOperations {
static  SharedPreferences sharedPreferences;
static Future<bool> initializeShared()async{
  sharedPreferences = await  SharedPreferences.getInstance();
  return true;
}
static saveMyId (String id )async{
  sharedPreferences = await  SharedPreferences.getInstance();

  await sharedPreferences.setString(Strings.sharedPrefKeyMyId, id);
  }
  static String getMyId (){
      return sharedPreferences.getString(Strings.sharedPrefKeyMyId);
  }
  static saveMyUserName (String username)async{
    await sharedPreferences.setString(Strings.sharedPrefKeyUsername, username);

  }
  static saveMyPassword (String password )async{
    await sharedPreferences.setString(Strings.sharedPrefKeyPassword, password);

  }
  static String getMyUserName (){

    return sharedPreferences.getString(Strings.sharedPrefKeyUsername);
  }
  static getMyPassword ( ){
    return sharedPreferences.getString(Strings.sharedPrefKeyPassword);

  }

}