abstract class AuthEvent {
  const AuthEvent();
}

//Когда только открылся приложение
// class AppLoadedEvent extends AuthEvent {}

class GetCodeAuthEvent extends AuthEvent {
  final String username;
  final String lastname;
  final String email;
  final String phone;

  GetCodeAuthEvent(this.username, this.lastname, this.email, this.phone);
}

class ConfirmCodeAuthEvent extends AuthEvent {
  final String code;
  ConfirmCodeAuthEvent(this.code);
}
