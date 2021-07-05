import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:sad_lib/CustomWidgets.dart';
import 'package:welptv/Screens/SeriesPanel.dart';
import 'package:welptv/Utils/ColorsClass.dart' as colors;
import 'package:welptv/utils/Icon.dart';

class Navigation extends StatefulWidget {
  final Widget child;
  Navigation({Key key, @required this.child,}) : super(key: key);
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {

  Size _size;

  final List<Map<String, dynamic>> _navIcons = [
    {
      "icon": Icons.home_outlined,
      "location": "/home",
    },
    {
      "icon": Icons.search_outlined,
      "location": "/search",
    },
    {
      "icon": Icons.live_tv_outlined,
      "location": "/live",
    },
    {
      "icon": Icons.bookmark_border_outlined,
      "location": "/watchlist",
    },
    {
      "icon": Icons.settings_outlined,
      "location": "/settings",
    },
  ];

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    if(_size.width > 1000 || _size.height > 1000){
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _desktopNavBar(),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0,),
              child: widget.child,
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(right: 20.0, top: 20.0, bottom: 20.0,),
              child: SeriesPanel(),
            ),
          ),
        ],
      );
    }else{
      return Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0,),
                  child: widget.child,
                ),

              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0,),
            decoration: BoxDecoration(
              color: colors.midGrey.withOpacity(0.25,),
              borderRadius: BorderRadius.vertical(top: Radius.circular(10.0,),),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(_navIcons.length, (i){
                return _navButton(i, isMobile: true,);
              }),
            ),
          ),
        ],
      );
    }
  }



  Widget _desktopNavBar(){
    return Container(
      margin: EdgeInsets.only(left: 20.0, top: 20.0, bottom: 20.0,),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: colors.black,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(10.0,),
            margin: EdgeInsets.all(15.0,),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.purple,
            ),
            child: CustomPaint(
              size: Size(20, (20*1.8378947368421052).toDouble(),), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
              painter: IconSvg(),
            ),
          ),
          _panel(),
        ],
      ),
    );
  }

  Widget _panel(){
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints){
          double buttonHeight = constraints.maxHeight/_navIcons.length;
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(_navIcons.length, (i){
              return ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 40,
                  maxHeight: buttonHeight,
                ),
                child: _navButton(i,),
              );
            },),
          );
        },
      ),
    );
  }

  Widget _navButton(int i, {bool isMobile = false,}){
    return ButtonView.hover(
      onPressed: (){
        Beamer.of(context).beamToNamed(_navIcons[i]["location"],);
      },
      onHover: ContainerChanges(),
      borderRadius: 0.0,
      color: (!isMobile && isCurrentScreen(i,)) ? colors.midGrey.withOpacity(0.2,) : Colors.transparent,
      border: (!isMobile && isCurrentScreen(i,))
          ? Border(left: BorderSide(color: colors.purple, width: 5.0,),)
          : Border(),
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: isMobile ? 5.0 : 25.0,),
      builder: (isHovering){
        return Icon(
          _navIcons[i]["icon"],
          color: isCurrentScreen(i,) || isHovering == true ? colors.purple : colors.white,
          size: isMobile ? 25.0 : 30.0,
        );
      },
    );
  }


  bool isCurrentScreen(int i){
    List<dynamic> pathBlueprints = Beamer.of(context).currentBeamLocation.pathBlueprints;
    if(pathBlueprints.contains(_navIcons[i]["location"])){
      // if the path blueprints of the current beam location contains this navigation component's location title
      // then this is the current screen/bem location of the app
      return true;
    }else{
      return false;
    }
  }

}
