part of 'notification_bloc.dart';

 class NotificationState {
   bool notification;
  NotificationState({required this.notification});
 }

class NotificationInitial extends NotificationState {
  NotificationInitial() : super(notification: true);
}
