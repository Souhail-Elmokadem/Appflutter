

abstract class AuthState{}



class InitialAuth extends AuthState{}
class SignInLoading extends AuthState{}
class SignInSuccess extends AuthState{}
class SignInFailure extends AuthState{
  String message;
  SignInFailure({required this.message});
}




