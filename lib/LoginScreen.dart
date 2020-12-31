import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notrouble/bloc/post_bloc.dart';
import 'package:notrouble/models/user.dart';
import 'package:notrouble/utils/Strings.dart';
import 'package:notrouble/utils/sharedPreference.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'Home/home_screen.dart';
import 'bloc/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isObscure = false ;
  bool inVisiable = false;
  AuthBloc _authBloc;
  ProgressDialog _dialog ;
  GoogleSignInAccount _currentUser ;
  TextEditingController _emailController  , _passwordController , _dispalyNameController;
  bool _isKeepMeLogined = false;

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  void initGmail() {
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {

      }
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleSignIn() async {
    try {
      _currentUser =   await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _dialog =  ProgressDialog(context);
    _emailController = TextEditingController();
    _dispalyNameController = TextEditingController();
    _passwordController = TextEditingController();
    _dialog.style(child: Text("Registering " , style: TextStyle(
        color: Colors.green
    ),));
    initGmail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc,AuthState>(
        builder: (BuildContext context,AuthState state){
          if(state.result == ResultState.Loaded){
            if (_isKeepMeLogined) {
              SharedPreferencesOperations.saveMyUserName(
                  _emailController.text);
              SharedPreferencesOperations.saveMyPassword(
                  _passwordController.text);
            }
            return HomeScreen();
          }
          else if(state.result == ResultState.Loading){
            _dialog.show();
          }
          else if(state.result == ResultState.Error){
            return Container(child: Text("Error"),);
          }

          return loginWidget();
        },
      ),
    );
  }
  loginWidget (){
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Column (
                    children: [
                      Container(
                          margin: EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15.0, right: 15, top: 20),
                            child: TextFormField(
                                enabled: true,
                                controller: _emailController,
                                style: TextStyle(color: Colors.green),
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (String) =>
                                    FocusScope.of(context).requestFocus(new FocusNode()),
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(color: Colors.green)
                                    ),
                                    hintStyle: TextStyle(fontSize: 20.0),
                                    labelText: Strings.USERNAME,
                                    labelStyle: TextStyle(color: Colors.green)
                                )),
                          )),
                      Container(
                          margin: EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15.0, right: 15, top: 20),
                            child: TextFormField(
                                enabled: true,
                                controller: _dispalyNameController,
                                style: TextStyle(color: Colors.green),
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (String) =>
                                    FocusScope.of(context).requestFocus(new FocusNode()),
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(color: Colors.green)
                                    ),
                                    hintStyle: TextStyle(fontSize: 20.0),
                                    labelText: Strings.DISPLAYNAME,
                                    labelStyle: TextStyle(color: Colors.green)
                                )),
                          )),
                    ],
                  )),
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Column (
              children: [
                Stack(
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0, right: 15, top: 20),
                          child: TextFormField(
                              enabled: true,
                              style: TextStyle(color: Colors.green),
                              textInputAction: TextInputAction.next,
                              controller: _passwordController,
                              obscureText: isObscure,
                              onFieldSubmitted: (String) =>
                                  FocusScope.of(context).requestFocus(new FocusNode()),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30)
                                  ),
                                  hintStyle: TextStyle(fontSize: 20.0),
                                  suffixIcon: IconButton(
                                    alignment: Alignment.topRight,
                                    icon: (inVisiable)
                                        ? Icon(
                                      Icons.visibility_off,
                                      color: Colors.green,
                                    )
                                        : Icon(
                                      Icons.visibility,
                                      color: Colors.green,
                                    ),
                                    onPressed: () {
                                      if (inVisiable == true) {
                                        setState(() {

                                          isObscure = !isObscure;
                                          inVisiable = false;
                                        });
                                      } else {
                                        setState(() {
                                          isObscure = !isObscure;
                                          inVisiable = true;
                                        });
                                      }
                                    },
                                  ),
                                  labelText: Strings.PASSWORD,
                                  labelStyle: TextStyle(color: Colors.green)
                              )),
                        )),
                  ],

                ),
                Switch(
                  activeColor: Colors.blue,
                  value: _isKeepMeLogined,
                  onChanged: (value){
                    setState(() {
                      _isKeepMeLogined = value;
                    });
                  },
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: RaisedButton(
                    color: Colors.green,
                    child: Text("Login"),

                    onPressed: (){
                      _authBloc.add(LoginEvent(email: _emailController.text, password: _passwordController.text));
                    },
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: RaisedButton(
                    color: Colors.green,
                    child: Text("Register"),

                    onPressed: (){
                      _authBloc.add(RegisterEvent(user:UserModel(email: _emailController.text, password: _passwordController.text, displayName: _dispalyNameController.text)));
                    },
                  ),
                ),
              ],
            ),

          ),

          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: RaisedButton(
              color: Colors.blue,
              child: Text("GMAIL Login"),
              onPressed: (){
                _handleSignIn();
              },
            ),
          ),

        ],
      ),
    );
  }
}