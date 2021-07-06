import 'package:flutter/foundation.dart';

class NotificationService extends ChangeNotifier{

  List<dynamic> queue = [];

  NotificationService(){
    // nothingIsBeingShown = true
    // when we receive a notification object, then add it the list
    // list = [blah1, blah2]

    // if nothingIsBeingShown, then show the next notification in the list
    // (show blah1)
    // nothingIsBeingShown = false

    // when blah1 is done, then remove it from the list
    // list = [blah2]
  }

  void addNewNotification(){
    queue.add(0,);
    notifyListeners();
  }

}
