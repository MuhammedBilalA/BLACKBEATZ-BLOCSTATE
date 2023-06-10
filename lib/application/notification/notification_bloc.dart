import 'dart:developer';

import 'package:black_beatz/infrastructure/db_functions/songs_db_functions/songs_db_functions.dart';
import 'package:bloc/bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meta/meta.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationInitial()) {
    on<GetNotification>((event, emit) async {
      // TODO: implement event handler

      Fetching f = Fetching();
      bool r = await f.notificationFetching();

      return emit(NotificationState(notification: r));
    });

    on<ChangeNotification>((event, emit) {
      return emit(NotificationState(notification: event.notification));
    });
  }
}
