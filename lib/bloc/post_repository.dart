import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:notrouble/utils/Strings.dart';
import 'package:notrouble/utils/sharedPreference.dart';

class PostRepository {
static PostRepository _postRepository ;
   CollectionReference postsPreference;

PostRepository._(){
    postsPreference = Firestore.instance.collection(Strings.tableNamePosts);
  }
  static PostRepository getInstance (){
    if (_postRepository ==null ){
      _postRepository = PostRepository._();
    }
     return _postRepository;
  }
   addPost(PostModel model)async{
    var future = await postsPreference.doc().set({
      "content": model.content,
      "date":model.date,
      "ownerId": SharedPreferencesOperations.getMyId()
    }).then((value) => {
    print("done")
    }).catchError((err){
      print(err);
    });

  }
   getPosts()async{
     var future =await postsPreference.getDocuments();
     for(QueryDocumentSnapshot item in future.docs ){
       print(item.data());
     }
  }
   getMyPosts(){

  }

}

class PostModel {
  String content ,  date , id  , ownerId;
  PostModel({this.content, this.date, this.id, this.ownerId});
}