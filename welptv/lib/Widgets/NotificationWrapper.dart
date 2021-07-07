import 'package:flutter/material.dart';
import 'package:welptv/Utils/ColorsClass.dart' as colors;

class NotificationWrapper extends StatefulWidget {
  final Widget child;
  NotificationWrapper({Key key, this.child,}) : super(key: key);
  @override
  _NotificationWrapperState createState() => _NotificationWrapperState();
}

class _NotificationWrapperState extends State<NotificationWrapper> with SingleTickerProviderStateMixin {

  dynamic _notifi = "";

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
      end: RelativeRect.fromLTRB(0, 5, 0, 0,),
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
    return Stack(
      children: [
        widget.child,
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
                    color: colors.midGrey.withOpacity(0.25,),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.people,
                    size: 20.0,
                    color: colors.purple,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }


  void _animate(){
    if(_notifi != null){
      _controller.forward().whenComplete((){ ///show current notification
        Future.delayed(Duration(seconds: 5,),).whenComplete((){ ///wait 5 seconds
          _controller.reverse().then((value){ ///remove current notification

            _notifi = null;
            if(_notifi != null){ ///if the queue is not empty, show next notification
              _animate();
            }
          });
        });
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
