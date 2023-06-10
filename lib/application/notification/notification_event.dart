part of 'notification_bloc.dart';

@immutable
abstract class NotificationEvent {}

class GetNotification extends NotificationEvent {}

class ChangeNotification extends NotificationEvent {
  bool notification;
  ChangeNotification({required this.notification});
}
