class NotificationPayload{
   var notificationType;
   var userId;
   var bookId;
   var message;
   var title;
   var type;
   var notificationId;

   NotificationPayload({this.notificationType, this.userId, this.bookId, this.message, this.title, this.type, this.notificationId});

   factory NotificationPayload.fromJson(Map<String, dynamic> json) {
     return NotificationPayload(
       notificationType: json['notification_type'],
       userId: json['user_id'],
       bookId: json['book_id'],
       message: json['message'],
       title: json['title'] ,
       type: json['type'],
       notificationId: json['notification_id'],
     );
   }

}