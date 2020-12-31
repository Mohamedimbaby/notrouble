import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notrouble/bloc/auth_repository.dart';
import 'package:notrouble/bloc/post_bloc.dart';
import 'package:notrouble/bloc/post_repository.dart';
import 'package:notrouble/models/user.dart';
import 'package:notrouble/utils/sharedPreference.dart';

 class AuthBloc extends Bloc<AuthEvent , AuthState>{
  AuthBloc(AuthState initialState) : super(initialState);
  AuthRepository _repository ;
  @override
  Stream<AuthState> mapEventToState(AuthEvent event)async* {
    // TODO: implement mapEventToState
    _repository = AuthRepository.getInstance();
    if (event is LoginEvent){
      UserCredential credential =await _repository.login(email :event.email,password: event.password);
      await SharedPreferencesOperations.saveMyId(credential.user.uid);

      yield AuthState(
            result: ResultState.Loaded
      );
    } else if (event is LogoutEvent){
      var bool = await _repository.logout();
      if(bool)
      yield AuthState(
            result: ResultState.Loaded
      );
      else yield AuthState(
          result: ResultState.Error
      );
    }
    else if (event is RegisterEvent){
      try{
      UserCredential credintials  =await  _repository.register(user: UserModel(email: event.user.email ,password: event.user.password , displayName: event.user.displayName ,))
          .catchError((onError)async*{
        yield AuthState(result: ResultState.Error);
      });
      if(credintials.user != null ){
        await SharedPreferencesOperations.saveMyId(credintials.user.uid);
        yield AuthState(result: ResultState.Loaded,userCredential: credintials);

      }}
      catch(ex){
        print(ex.toString());
      }

    }
  }

}
abstract class AuthEvent{}
class LoginEvent extends AuthEvent{
   String email , password ;
   LoginEvent({this.email, this.password});
}class LogoutEvent extends AuthEvent{
}
class RegisterEvent extends AuthEvent{
  UserModel user;
  RegisterEvent({ this.user});
}
class AuthState{
  ResultState result ;
  AuthState({this.result , this.userCredential});
  UserCredential userCredential;
}
