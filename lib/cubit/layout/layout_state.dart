import 'package:guidanclyflutter/models/user_model.dart';

abstract class LayoutState{}
class LayoutInitializer extends LayoutState{}
class LayoutLoading extends LayoutState{}
class LayoutSuccess extends LayoutState {
  final UserModel user;

  LayoutSuccess(this.user);
}

class LayoutFailure extends LayoutState{
  String message;
  LayoutFailure({required this.message});
}