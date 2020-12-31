import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notrouble/Home/home_screen.dart';
import 'package:notrouble/LoginScreen.dart';
import 'package:notrouble/bloc/auth_bloc.dart';
import 'package:notrouble/bloc/auth_repository.dart';
import 'package:notrouble/bloc/post_bloc.dart';
import 'package:notrouble/utils/sharedPreference.dart';
import 'package:progress_dialog/progress_dialog.dart';

void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<PostBloc>(
          create: (c)=> PostBloc(PostState(result: ResultState.Empty)),
         ),
      BlocProvider<AuthBloc>(
          create: (c)=> AuthBloc(AuthState(result: ResultState.Empty)),
          )
    ],
    child:MyApp() ,
  ));
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(hintColor: Colors.green, primaryColor: Colors.green),
      home:   MyHomePage(title: 'Flutter Demo Home Page')
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
 final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AuthBloc _authBloc;
  ProgressDialog _dialog ;
  TextEditingController _emailController  , _passwordController , _dispalyNameController;
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initFirebaseApp();

  }
  initFirebaseApp ()async{
    var initializeApp = await Firebase.initializeApp();
    print(initializeApp.name);
  }
 Future<bool>initShared ()async{
  return await SharedPreferencesOperations.initializeShared();
  }
bool Loaded =false;
  @override
  Widget build(BuildContext context) {
    setState(() {
      initShared().then((value) => {
        if(value){
          Loaded = true
        }
      });
    });
 Future.delayed(Duration(
   seconds: 3
 ), (){
   if(isSaved()) {
     AuthRepository auth = AuthRepository.getInstance();
     auth.login(email: SharedPreferencesOperations.getMyUserName(),
         password: SharedPreferencesOperations.getMyPassword());
   }
 }) ;
    return Scaffold
      (
      body: Center(
          child:  !Loaded ? Container(color: Colors.red,) :  isSaved() ? BlocProvider(
              create: (c)=> AuthBloc(AuthState(result: ResultState.Empty)),
              child: HomeScreen()) : LoginScreen()
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );

  }


  Future <bool> getBoolean (){
    Future.delayed(Duration(seconds: 4),(){
      if (_dialog.isShowing()){
        _dialog.hide();
      }
    });
  }



  isSaved() {
    var myUserName = SharedPreferencesOperations.getMyUserName();
    return (myUserName != null && myUserName != "")  ? true: false;
  }
  }





