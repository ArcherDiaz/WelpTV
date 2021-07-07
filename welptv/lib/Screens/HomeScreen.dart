import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:sad_lib/CustomWidgets.dart';
import 'package:welptv/Services/FirebaseService.dart';
import 'package:welptv/Utils/ColorsClass.dart' as colors;
import 'package:welptv/Widgets/Navigation.dart';
import 'package:welptv/Widgets/NotificationWrapper.dart';
import 'package:welptv/Widgets/SeriesCard.dart';
import 'package:welptv/Widgets/TopPicksWidget.dart';
import 'package:welptv/utils/CacheManagement.dart';
import 'package:welptv/Services/ScraperService.dart';
import 'package:welptv/utils/SeriesClass.dart';

class HomeTab extends StatefulWidget {
  HomeTab({Key key,}) : super(key: key);
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {

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
              padding: EdgeInsets.only(top: 20.0, bottom: 40.0, right: 10.0,),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _recentlyWatched(),
                  _topPicks(),
                  _welcome(),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }

  Widget _recentlyWatched(){
    return FutureBuilder(
      future: _cacheManagement.loadRecent(),
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasData){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextView(text: "Recently Viewed Anime",
                  padding: EdgeInsets.only(top: 20.0,),
                  size: 20.0,
                  isSelectable: true,
                  color: colors.white,
                  fontWeight: FontWeight.w600,
                ),
                StaggeredGridView.countBuilder(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.only(top: 20.0, bottom: 40.0, right: 10.0, left: 10.0,),
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data.length,
                  staggeredTileBuilder: (i){
                    return StaggeredTile.fit(1,);
                  },
                  itemBuilder: (context, i){
                    return SeriesCard(
                      onPressed: (){
                        _openSeriesPanel(snapshot.data[i],);
                      },
                      cardView: CardView.horizontalView,
                      series: snapshot.data[i],
                    );
                  },
                ),
              ],
            );
          }else{
            return Container();
          }
        }else{
          return CustomLoader(
            indicator: IndicatorType.circular,
            color1: colors.white,
            color2: colors.midGrey,
          );
        }
      },
    );
  }

  Widget _topPicks(){
    return Consumer<FirebaseService>(
      builder: (context, service, child){
        return FutureBuilder(
          future: service.getTopPicks,
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              if(snapshot.hasData){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextView(text: "Top Picks By The Developers of WelpTV",
                      padding: EdgeInsets.only(top: 20.0,),
                      size: 20.0,
                      isSelectable: true,
                      color: colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.only(top: 20.0, bottom: 40.0,),
                      child: Row(
                        children: List.generate(snapshot.data.length, (i){
                          return TopPickWidget(
                            onPressed: (){
                              _openSeriesPanel(snapshot.data[i],);
                            },
                            imageURL: snapshot.data[i].image,
                            seriesName: snapshot.data[i].name,
                            color: snapshot.data[i].seriesColor,
                          );
                        }),
                      ),
                    ),
                  ],
                );
              }else{
                return Container();
              }
            }else{
              return CustomLoader(
                indicator: IndicatorType.circular,
                color1: colors.white,
                color2: colors.midGrey,
              );
            }
          },
        );
      },
    );
  }

  Widget _welcome(){
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
          TextView(text: "Welcome to WelpTV",
            padding: EdgeInsets.only(bottom: 20.0,),
            size: 20.0,
            isSelectable: true,
            color: colors.purple,
            fontWeight: FontWeight.w600,
          ),
          TextView(text: "WelpTV is an Anitguan-made project by anime watchers, for anime watchers!\n"
              "No ads! No Popups! No distractions! This is the gift WelpTV offers you, and let's make it the gift that keeps on giving by sharing it with others around the island.\n"
              "\nWelpTV can and will become the home of all anime enthusiasts in Antigua!!",
            size: 15.0,
            isSelectable: true,
            color: colors.white,
            fontWeight: FontWeight.w400,
          ),
        ],
      ),
    );
  }


  void _openSeriesPanel(SeriesClass seriesData){
    Provider.of<ScraperService>(context, listen: false,).changeCurrentSeries(seriesData,);
  }

}
