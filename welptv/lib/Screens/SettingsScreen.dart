import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sad_lib/CustomWidgets.dart';
import 'package:welptv/Services/NotificationService.dart';
import 'package:welptv/Utils/ColorsClass.dart' as colors;
import 'package:welptv/Widgets/Navigation.dart';
import 'package:welptv/Widgets/NotificationWrapper.dart';
import 'package:welptv/utils/CacheManagement.dart';

class SettingsTab extends StatefulWidget {
  SettingsTab({Key key,}) : super(key: key);
  @override
  _SettingsTabState createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {

  CacheManagement _cacheManagement = CacheManagement();

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
              padding: EdgeInsets.only(top: 20.0, bottom: 40.0, right: 10.0, ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _about(),
                  _donate(),
                  _history(),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }

  Widget _about(){
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
          TextView(text: "About Us",
            padding: EdgeInsets.only(bottom: 20.0,),
            size: 20.0,
            isSelectable: true,
            color: colors.purple,
            fontWeight: FontWeight.w600,
          ),
          TextView(text: "This is WelpTV!  ",
            size: 15.0,
            isSelectable: true,
            color: colors.white,
            fontWeight: FontWeight.w400,
          ),
        ],
      ),
    );
  }

  Widget _donate(){
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
          TextView(text: "Support Us",
            padding: EdgeInsets.only(bottom: 20.0,),
            size: 20.0,
            isSelectable: true,
            color: colors.purple,
            fontWeight: FontWeight.w600,
          ),
          TextView(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            size: 15.0,
            isSelectable: true,
            color: colors.white,
            fontWeight: FontWeight.w400,
          ),
          ButtonView(
            onPressed: (){

            },
            border: Border.all(color: colors.midGrey, width: 1.0,),
            highlightColor: colors.white.withOpacity(0.2,),
            margin: EdgeInsets.symmetric(vertical: 10.0,),
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0,),
            child: TextView(text: "Donate",
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

  Widget _history(){
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
          TextView(text: "Watch History",
            padding: EdgeInsets.only(bottom: 20.0,),
            size: 20.0,
            isSelectable: true,
            color: colors.purple,
            fontWeight: FontWeight.w600,
          ),
          TextView(text: "This option will remove your most recently watched anime series. This is permanent by the way.\n"
              "\nThis option was highly requested.. for some reason..",
            size: 15.0,
            isSelectable: true,
            color: colors.white,
            fontWeight: FontWeight.w400,
          ),
          ButtonView(
            onPressed: (){
              _cacheManagement.deleteRecentList();
              Provider.of<NotificationService>(context, listen: false,).addNewNotification("deleted");
            },
            border: Border.all(color: colors.midGrey, width: 1.0,),
            highlightColor: colors.white.withOpacity(0.2,),
            margin: EdgeInsets.symmetric(vertical: 10.0,),
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0,),
            child: TextView(text: "Clear Recently Watched",
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
