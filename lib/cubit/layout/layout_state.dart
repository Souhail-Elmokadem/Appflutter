import 'package:guidanclyflutter/models/user_model.dart';

abstract class LayoutState{}
class LayoutInitializer extends LayoutState{}
class LayoutLoading extends LayoutState{}
class LayoutSuccess<T> extends LayoutState {
  final UserModel user;
  final T userdetail;

  LayoutSuccess(this.user,this.userdetail);
}

class LayoutFailure extends LayoutState{
  String message;
  LayoutFailure({required this.message});
}