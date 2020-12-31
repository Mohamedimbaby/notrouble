import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notrouble/bloc/post_repository.dart';

 class PostBloc extends Bloc<PostEvent , PostState>{
  PostBloc(PostState initialState) : super(initialState);
  PostRepository _repository ;
  @override
  Stream<PostState> mapEventToState(PostEvent event)async* {
    // TODO: implement mapEventToState
    _repository = PostRepository.getInstance();
    if (event is AddPostEvent){
      _repository.addPost(event.postModel);
      yield PostState(

      );
    }
    else if (event is GetPostEvent){
      _repository.getPosts();
      yield PostState();
    }
  }

}
abstract class PostEvent{}
class AddPostEvent extends PostEvent{
   PostModel postModel;
   AddPostEvent({this.postModel});
}
class GetPostEvent extends PostEvent{}
class PostState{
  ResultState result ;
  List<PostModel> posts ;
  PostState({this.result , this.posts});
}
enum ResultState {
   Empty , Loading , Loaded , Error
}