import 'dart:ui';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sad_lib/CustomWidgets.dart';
import 'package:welptv/Utils/ColorsClass.dart' as colors;
import 'package:welptv/Widgets/VideoWidget.dart';
import 'package:welptv/utils/CacheManagement.dart';
import 'package:welptv/utils/ScraperService.dart';
import 'package:welptv/utils/SeriesClass.dart';

class ViewingScreen extends StatefulWidget {
  final EpisodeClass episode;
  ViewingScreen({Key key,
    @required this.episode,
  }) : super(key: key);
  @override
  _ViewingScreenState createState() => _ViewingScreenState();
}

class _ViewingScreenState extends State<ViewingScreen> {

  CacheManagement _cacheManagement = CacheManagement();

  bool _isExpanded;
  Size _size;


  @override
  void initState() {
    _isExpanded = true;
    super.initState();
    //print(widget.episode.url);
    Provider.of<ScraperService>(context, listen: false,).scrapeEpisodeData(widget.episode.url,);
  }

  @override
  void didUpdateWidget(covariant ViewingScreen oldWidget) {
    if(widget.episode != null) {
      if(oldWidget.episode == null) {
        setState(() {
          _isExpanded = true;
          Provider.of<ScraperService>(context, listen: false,).scrapeEpisodeData(widget.episode.url,);
        });
      }else{
        if (oldWidget.episode.url != widget.episode.url) {
          setState(() {
            _isExpanded = true;
            Provider.of<ScraperService>(context, listen: false,).scrapeEpisodeData(widget.episode.url,);
          });
        }
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Material(
      color: colors.black,
      child: IndexedStack(
        alignment: Alignment.bottomRight,
        index: _isExpanded ? 0 : 1,
        children: [
          _expandedView(),
          _collapsedView(),
        ],
      ),
    );
  }

  Widget _expandedView(){
    if(widget.episode == null){
      return Container(
        width: 0.0,
        height: 0.0,
      );
    }else{
      return Container(
        color: colors.black,
        width: _size.width,
        height: _size.height,
        child: _videoFrame(),
      );
    }
  }

  Widget _collapsedView(){
    if(widget.episode == null){
      return Container(
        width: 0.0,
        height: 0.0,
      );
    }else{
      return Container(
        constraints: BoxConstraints(
          maxWidth: _size.width,
          minWidth: _size.width/5,
        ),
        margin: EdgeInsets.all(15.0,),
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0,),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0,),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ButtonView.hover(
              onPressed: (){
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              onHover: ContainerChanges(
                decoration: BoxDecoration(
                  color: colors.purple,
                  borderRadius: BorderRadius.circular(360.0,),
                  border: Border.all(color: colors.white, width: 1.5,),
                ),
              ),
              border: Border.all(
                color: colors.purple,
                width: 1.5,
              ),
              borderRadius: 360.0,
              color: Colors.transparent,
              padding: EdgeInsets.all(10.0,),
              highlightColor: colors.purple.withOpacity(0.2,),
              builder: (flag){
                return Icon(Icons.open_in_full_outlined,
                  size: 20.0,
                  color: flag == true ? colors.white : colors.purple,
                );
              },
            ),
            TextView.rich(
              textSpan: [
                TextView(text: widget.episode.seriesName + "\n",
                  size: 15.0,
                  color: colors.black,
                  fontWeight: FontWeight.w600,
                ),
                TextView(text: widget.episode.name,
                  size: 15.0,
                  letterSpacing: 0.0,
                  color: colors.midGrey,
                  fontWeight: FontWeight.w400,
                ),
              ],
              isSelectable: true,
              padding: EdgeInsets.symmetric(horizontal: 20.0,),
            ),
            ButtonView.hover(
              onPressed: (){

              },
              onHover: ContainerChanges(
                decoration: BoxDecoration(
                  color: colors.midGrey.withOpacity(0.5,),
                  borderRadius: BorderRadius.circular(360.0,),
                ),
              ),
              borderRadius: 360.0,
              color: Colors.transparent,
              padding: EdgeInsets.all(10.0,),
              highlightColor: colors.white.withOpacity(0.2,),
              builder: (flag){
                return Icon(Icons.close_outlined,
                  size: 20.0,
                  color: flag == true ? colors.black : colors.midGrey,
                );
              },
            ),
          ],
        ),
      );
    }
  }

  Widget _videoFrame(){
    return Consumer<ScraperService>(
      builder: (context, service, child){
        return FutureBuilder(
          future: service.getEpisode,
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              if(snapshot.hasData){
                return VideoWidget(
                  key: ValueKey(snapshot.data,),
                  onClose: (){
                    Beamer.of(context).beamBack();
                  },
                  title: widget.episode.name,
                  videoUrl: snapshot.data,
                  videoListener: (currentPosition, maxDuration){
                    if(currentPosition.inSeconds > (maxDuration.inSeconds/2)){
                      _cacheManagement.saveWatchedEpisode(widget.episode,);
                    }
                  },
                  children: [
                    ButtonView(
                      onPressed: (){

                      },
                      border: Border.all(color: colors.midGrey, width: 1.0,),
                      margin: EdgeInsets.symmetric(horizontal: 15.0,),
                      padding: EdgeInsets.all(5.0,),
                      highlightColor: colors.white.withOpacity(0.2,),
                      children: [
                        Icon(Icons.subscriptions_rounded,
                          color: colors.white,
                          size: 25.0,
                        ),
                        TextView(text: widget.episode.name,
                          padding: EdgeInsets.only(left: 5.0,),
                          size: 15.0,
                          color: colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ],
                );
              }else{
                return TextView(text: snapshot.error.toString(),
                  size: 17.5,
                  isSelectable: true,
                  color: colors.white,
                  fontWeight: FontWeight.w400,
                );
              }
            }else{
              return CustomLoader(
                color1: colors.white,
                color2: colors.midGrey,
              );
            }
          },
        );
      },
    );
  }

}
