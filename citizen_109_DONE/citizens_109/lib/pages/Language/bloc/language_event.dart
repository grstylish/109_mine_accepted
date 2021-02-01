part of 'language_bloc.dart';

abstract class LanguageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchLanguageEvent extends LanguageEvent {}

class ChangeLanguageEvent extends LanguageEvent {
  final String language;
  ChangeLanguageEvent(this.language);
}
