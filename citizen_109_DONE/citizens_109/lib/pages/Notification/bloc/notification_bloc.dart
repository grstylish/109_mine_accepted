import 'package:citizens01/pages/Notification/ApiNotificationServices/notification_repository.dart';
import 'package:citizens01/pages/Notification/bloc/notification_event.dart';
import 'package:citizens01/pages/Notification/bloc/notification_state.dart';
import 'package:citizens01/pages/Notification/models/notification_news.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationRepository notificationRepository = NotificationRepository();
  NotificationBloc() : super(InitialNotificationState());

  @override
  Stream<NotificationState> mapEventToState(NotificationEvent event) async* {
    print('$event');
    if (event is LoadNotificationEvent) {
      yield LoadingNotificationState();
      try {
        final List<NotificationNews> _notificationnews =
            await notificationRepository.getNotificationNewsProvider();
        yield LoadedNotificationState(loadnotificationnews: _notificationnews);
      } catch (e) {
        print("Try Error: $e");
        yield FailureNotificationState(e.toString());
      }
    }
  }
}

///
///
///

class NotfActionBloc extends Bloc<NotfActionEvent, NotfActionState> {
  NotificationRepository notificationRepository = NotificationRepository();
  NotfActionBloc() : super(NotfActionInitial());

  @override
  Stream<NotfActionState> mapEventToState(NotfActionEvent event) async* {
    if (event is CheckNotfActionEvent) {
      bool value = await notificationRepository.getNotfication();
      yield CheckedNotfActionState(value);
    }
    if (event is ConfigNotfActionEvent) {
      await notificationRepository.setNotification(event.value);
      await notificationRepository.getSendConfigNotification(event.value);
      yield CheckedNotfActionState(true);
    }
  }
}
