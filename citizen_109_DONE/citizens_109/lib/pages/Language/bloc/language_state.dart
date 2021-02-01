part of 'language_bloc.dart';

abstract class LanguageState extends Equatable {
  final String type;

  var error;
  LanguageState(this.type);

  @override
  List<Object> get props => [];
}

class LanguageInitial extends LanguageState {
  LanguageInitial() : super(Language.ru);
}

class FetchedLanguageState extends LanguageState {
  final String type;
  final Language language;
  FetchedLanguageState(this.type, this.language) : super(type);
}
