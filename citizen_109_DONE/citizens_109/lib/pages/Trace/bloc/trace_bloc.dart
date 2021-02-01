import 'package:citizens01/pages/Trace/ApiTraceServices/trace_repository.dart';
import 'package:citizens01/pages/Trace/bloc/trace_event.dart';
import 'package:citizens01/pages/Trace/bloc/trace_state.dart';
import 'package:citizens01/pages/Trace/models/active_tracename.dart';
import 'package:citizens01/pages/Trace/models/search_tracename.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TraceBloc extends Bloc<TraceEvent, TraceState> {
  TraceRepository traceRepository = TraceRepository();
  TraceBloc() : super(InitialTraceState());

  @override
  Stream<TraceState> mapEventToState(TraceEvent event) async* {
    print("EVENT $event");
    if (event is LoadTraceNameEvent) {
      yield LoadingTraceState();
      try {
        final List<ActiveTraceName> getActiveTraceName =
            await traceRepository.getActiveTraceNameProvider();
        yield LoadActiveTraceNameState(
            loadedactivetracename: getActiveTraceName);
      } catch (e) {
        yield FailureTraceState(e.toString());
      }
    }

    if (event is LoadSearchTraceNameEvent) {
      yield LoadingTraceState();
      try {
        final List<SearchTraceName> searchtracename =
            await traceRepository.getSearchNameProvider(event.track_number);
        yield LoadSearchTraceNameState(loadedsearchtracename: searchtracename);
      } catch (e) {
        yield FailureTraceState(e.toString());
      }
    }

//FailureTraceState
    if (event is LoadSendEvaluationEvent) {
      yield LoadingTraceState();
      try {
        await traceRepository.getSendRequest(
            event.rating, event.comment, event.track_number);
        yield LoadSendRequestState();
      } catch (e) {
        yield FailureTraceState(e.toString());
      }
    }
  }
}
