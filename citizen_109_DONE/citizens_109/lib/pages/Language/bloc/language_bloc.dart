import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:citizens01/pages/Language/ApiLanguageServices/language_repository.dart';
import 'package:citizens01/pages/Language/model/language.dart';
import 'package:equatable/equatable.dart';
part 'language_event.dart';
part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(LanguageInitial());
  LanguageRepository _repository = LanguageRepository();

  @override
  Stream<LanguageState> mapEventToState(LanguageEvent event) async* {
    if (event is FetchLanguageEvent) {
      yield LanguageInitial();
      final String type = await _repository.fetchLanguage();
      Language lang = await Language.kaz();
      if (type == Language.ru) lang = await Language.rus();
      yield FetchedLanguageState(type, lang);
    }
    if (event is ChangeLanguageEvent) {
      yield LanguageInitial();
      await _repository.changeLanguage(event.language);
      Language lang = await Language.kaz();
      if (event.language == Language.ru) lang = await Language.rus();
      yield FetchedLanguageState(event.language, lang);
    }
  }
}
