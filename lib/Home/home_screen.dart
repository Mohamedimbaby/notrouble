import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notrouble/LoginScreen.dart';
import 'package:notrouble/bloc/auth_bloc.dart';
import 'package:notrouble/bloc/auth_repository.dart';
import 'package:notrouble/bloc/post_bloc.dart';
import 'package:notrouble/bloc/post_repository.dart';
import 'package:notrouble/utils/sharedPreference.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PostBloc _bloc;
  AuthBloc _authBloc;
  MyTextController _controller ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = BlocProvider.of<PostBloc>(context);
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _controller = MyTextController();

  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      cubit: _authBloc,
     listener: (context , state )async{
       if (state.result == ResultState.Loaded){
         await SharedPreferencesOperations.saveMyUserName("");
         Navigator.push(context, MaterialPageRoute(
           builder: (context){return LoginScreen();}
         ));
       }
     },
     child: home(),
    );
  }
  home (){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextFormField(
            controller: _controller,
         validator: (value){
             return value.length < 15 ? "Enter more than 15 characters " :  null;
         },
        ),
        RaisedButton(
          child: Text(
            'Add post',
          ),
          onPressed: (){
            _bloc.add(AddPostEvent(postModel: PostModel(content: _controller.text ,date: DateTime.now().toString(), ownerId: SharedPreferencesOperations.getMyId())));
          },
        ),
        RaisedButton(
          onPressed: (){
            _bloc.add(GetPostEvent());
          },
          child: Text(
            'Show all posts',
          ),
        ),
        RaisedButton(
          onPressed: (){},
          child: Text(
            'Show my posts',
          ),
        ),RaisedButton(
          onPressed: (){
          _authBloc.add(LogoutEvent());
          },
          child: Text(
            'Log out',
          ),
        ),
      ],
    );
  }

}

class MyTextController extends TextEditingController {
  @override
  TextSpan buildTextSpan({TextStyle style, bool withComposing}) {
    List<InlineSpan> children = [];
    if(text.contains('#')){
      children.add(TextSpan(style: TextStyle(color: Colors.black), text: text.substring(0, text.indexOf('#'))));
      children.add(TextSpan(style: TextStyle(color: Colors.blue),text: text.substring(text.indexOf('#'))));
      String statement = text .substring(text.indexOf('#'), text.length);
      if(statement.contains(' ')){
        children.add(TextSpan(style: TextStyle(color: Colors.black),text: text.substring(statement.indexOf(' '), text.length)));
      }
    } else {
      children.add(TextSpan(style: TextStyle(color: Colors.black), text: text));
    }
    return TextSpan(style: style, children: children);
  }
}