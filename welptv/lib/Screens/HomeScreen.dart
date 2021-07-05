import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sad_lib/CustomWidgets.dart';
import 'package:welptv/Utils/ColorsClass.dart' as colors;
import 'package:welptv/Widgets/Navigation.dart';
import 'package:welptv/Widgets/SeriesCard.dart';
import 'package:welptv/Widgets/TopPicksWidget.dart';
import 'package:welptv/utils/CacheManagement.dart';
import 'package:welptv/utils/ScraperService.dart';
import 'package:welptv/utils/SeriesClass.dart';

class HomeTab extends StatefulWidget {
  HomeTab({Key key,}) : super(key: key);
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {

  CacheManagement _cacheManagement = CacheManagement();

  ScrollController _scrollController;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<List<SeriesClass>> _topPicksFuture;
  List<SeriesClass> _resultsList = [];


  Future<List<SeriesClass>> _getTopPicks(){
    String url = "https://gogoscraper.glitch.me/picks";
    // make the api request to the server to retrieve search results
    return http.get(Uri.parse(url),).then((response){
      _resultsList.clear();
      List<dynamic> data = json.decode(response.body);
      // using the response from the api, parse the json data into SeriesClass objects
      // and populate the resultsList variable with these objects
      data.forEach((element) {
        _resultsList.add(SeriesClass.fromJSON(element,),);
      });

      Map<String, dynamic> map = {};
      _resultsList.forEach((element) {
        map.putIfAbsent(element.name, () => element.toMap());
      });
      _firestore.collection("OurTopPicks").doc("tops").set(map,);

      return _resultsList;
    }).catchError((onError){
      print(onError.toString());
      return _resultsList;
    });
  }


  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
    _topPicksFuture = _getTopPicks();
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
    return FutureBuilder(
      future: _topPicksFuture,
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
                    children: List.generate(_resultsList.length, (i){
                      return TopPickWidget(
                        onPressed: (){
                          _openSeriesPanel(_resultsList[i],);
                        },
                        imageURL: _resultsList[i].image,
                        seriesName: _resultsList[i].name,
                        color: _resultsList[i].seriesColor,
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
