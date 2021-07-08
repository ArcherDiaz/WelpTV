import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sad_lib/CustomWidgets.dart';
import 'package:welptv/Services/NotificationService.dart';
import 'package:welptv/Utils/ColorsClass.dart' as colors;
import 'package:welptv/Utils/NotificationClass.dart';
import 'package:welptv/Widgets/Navigation.dart';
import 'package:welptv/Widgets/NotificationWrapper.dart';

class LiveTab extends StatefulWidget {
  LiveTab({Key key,}) : super(key: key);
  @override
  _LiveTabState createState() => _LiveTabState();
}

class _LiveTabState extends State<LiveTab> {

  ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colors.black,
      child: NotificationWrapper(
        child: Navigation(
          child: Scrollbar(
            controller: _scrollController,
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.only(top: 20.0, bottom: 40.0, right: 10.0,),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _helpUs(),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }

  Widget _helpUs(){
    return Container(
      margin: EdgeInsets.only(top: 20.0, bottom: 40.0,),
      padding: EdgeInsets.all(15.0,),
      decoration: BoxDecoration(
        color: colors.midGrey.withOpacity(0.2,),
        borderRadius: BorderRadius.circular(20.0,),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextView(text: "Feature Not Yet Implemented!",
            padding: EdgeInsets.only(bottom: 20.0,),
            size: 20.0,
            isSelectable: true,
            color: colors.purple,
            fontWeight: FontWeight.w600,
          ),
          TextView(text: "WelpTV's Live Rooms tab will be a feature that allows all of our users to communicate in live voice chat rooms!\n"
              "Make em private! Make em public! Join a room of 20 guys arguing over who could beat Goku! The Live Rooms tab is where the anime community comes to be ALIVE.\n"
              "\nIf you're a developer who thinks that they have what it takes to implement this feature or simply help us with the implementation, don't be afraid to contact us.\n"
              "If you're a developer who simply wants to contribute to this project in anyway possible, still.. contact us ;) We don't bite.",
            size: 15.0,
            isSelectable: true,
            color: colors.white,
            fontWeight: FontWeight.w400,
          ),
          ButtonView(
            onPressed: (){
              Provider.of<NotificationService>(context, listen: false,).addNewNotification(
                  NotificationClass(icon: Icons.pending_actions_outlined, text: "Love the energy! but nah this button not ready yet.."),
              );
            },
            border: Border.all(color: colors.midGrey, width: 1.0,),
            highlightColor: colors.white.withOpacity(0.2,),
            margin: EdgeInsets.symmetric(vertical: 10.0,),
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0,),
            child: TextView(text: "Contact Us",
              size: 15.0,
              letterSpacing: 0.0,
              align: TextAlign.center,
              color: colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

}
