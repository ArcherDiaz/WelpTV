import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sad_lib/CustomWidgets.dart';
import 'package:welptv/Services/NotificationService.dart';
import 'package:welptv/Utils/ColorsClass.dart' as colors;
import 'package:welptv/Utils/NotificationClass.dart';

class NotificationWrapper extends StatefulWidget {
  final Widget child;
  NotificationWrapper({Key key, this.child,}) : super(key: key);
  @override
  _NotificationWrapperState createState() => _NotificationWrapperState();
}

class _NotificationWrapperState extends State<NotificationWrapper> with SingleTickerProviderStateMixin {

  NotificationClass _notification;

   AnimationController _controller;
   Animation<RelativeRect> _offsetAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      duration: Duration(seconds: 2,),
      reverseDuration: Duration(seconds: 1,),
      vsync: this,
    );

    _offsetAnimation = RelativeRectTween(
      begin: RelativeRect.fromLTRB(0, -100, 0, 0,),
      end: RelativeRect.fromLTRB(0, 15, 0, 0,),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.bounceOut,
        reverseCurve: Curves.ease,
      ),
    );
    super.initState();

    _animate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    NotificationClass next = Provider.of<NotificationService>(context).getNextNotification;
    if(_notification != next){
      _notification = next;
      _animate();
    }
    return Stack(
      children: [
        widget.child,
        if(_notification != null)
          PositionedTransition(
            rect: _offsetAnimation,
            child: _notificationBox(),
          ),
      ],
    );
  }

  Widget _notificationBox(){
    return Align(
      alignment: Alignment.topCenter,
      child: LayoutBuilder(
        builder: (context, constraints){
          return AnimatedContainer(
            duration: Duration(seconds: 1,),
            width: isMobile ? constraints.maxWidth : constraints.maxWidth/2.5,
            margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0,),
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0,),
            decoration: BoxDecoration(
              color: colors.black,
              border: Border.all(color: colors.purple, width: 0.5,),
              borderRadius: BorderRadius.circular(5.0,),
            ),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.0,),
                  padding: EdgeInsets.all(10.0,),
                  decoration: BoxDecoration(
                    color: colors.midGrey.withOpacity(0.35,),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(_notification.icon,
                    size: 25.0,
                    color: colors.purple,
                  ),
                ),
                Expanded(
                  child: TextView(text: _notification.text,
                    padding: EdgeInsets.only(left: 10.0,),
                    size: 15.0,
                    isSelectable: true,
                    color: colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                ButtonView(
                  onPressed: (){
                    reverseNow(isDismissed: true,);
                  },
                  borderRadius: 360.0,
                  //border: Border.all(width: 1.0, color: colors.white,),
                  margin: EdgeInsets.symmetric(horizontal: 10.0,),
                  padding: EdgeInsets.all(5.0,),
                  child: Icon(Icons.close,
                    size: 25.0,
                    color: colors.white,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }


  void _animate(){
    if(_notification != null){
      _controller.forward().whenComplete((){ ///show current notification
        Future.delayed(Duration(seconds: 3,),).whenComplete((){ ///wait 3 seconds
          reverseNow(isDismissed: false,);
        });
      });
    }
  }

  void reverseNow({bool isDismissed = false}){
    if(mounted){
      if(isDismissed){
        _controller.reverseDuration = Duration(milliseconds: 500,);
      }
      _controller.reverse().then((value){ ///remove current notification
        _notification = null;
        if(isDismissed){
          _controller.reverseDuration = Duration(seconds: 1,);
        }
        Provider.of<NotificationService>(context, listen: false,).removeFirstNotification();
      });
    }
  }

  bool get isMobile {
    Size _size = MediaQuery.of(context,).size;
    if(_size.width > 1000 || _size.height > 1000){
      return false;
    }else{
      return true;
    }
  }

}
