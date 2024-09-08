

abstract class AuthState{}



class InitialAuth extends AuthState{}
class SignInLoading extends AuthState{}
class SignInSuccess extends AuthState{
  final String role; // 'guide' or 'visitor'

  SignInSuccess({required this.role});
}
class SignInFailure extends AuthState{
  String message;
  SignInFailure({required this.message});
}




