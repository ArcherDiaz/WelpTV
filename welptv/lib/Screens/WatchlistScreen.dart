import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:sad_lib/CustomWidgets.dart';
import 'package:welptv/Utils/ColorsClass.dart' as colors;
import 'package:welptv/Widgets/Navigation.dart';
import 'package:welptv/Widgets/SeriesCard.dart';
import 'package:welptv/utils/CacheManagement.dart';
import 'package:welptv/Services/ScraperService.dart';
import 'package:welptv/utils/SeriesClass.dart';

class WatchlistTab extends StatefulWidget {
  WatchlistTab({Key key,}) : super(key: key);
  @override
  _WatchlistTabState createState() => _WatchlistTabState();
}

class _WatchlistTabState extends State<WatchlistTab> {

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
      child: Navigation(
        child: FutureBuilder(
          future: _cacheManagement.loadWatchlist(),
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(),
                  if(snapshot.hasData)
                    _savedView(snapshot.data,),
                ],
              );
            }else{
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0,),
                child: CustomLoader(
                  indicator: IndicatorType.linear,
                  color1: colors.white,
                  color2: colors.midGrey,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _header(){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0,),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextView(text: "Series Watchlist",
              size: 20.0,
              isSelectable: true,
              color: colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          Icon(Icons.keyboard_arrow_down_outlined,
            size: 25.0,
            color: colors.midGrey,
          ),
        ],
      ),
    );
  }

  Widget _savedView(List<SeriesClass> savedList){
    return Expanded(
      child: Scrollbar(
        controller: _scrollController,
        child: StaggeredGridView.countBuilder(
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          itemCount: savedList.length,
          crossAxisCount: 4,
          padding: EdgeInsets.only(top: 20.0, bottom: 40.0,),
          staggeredTileBuilder: (index){
            return StaggeredTile.fit(1);
          },
          itemBuilder: (context, i){
            return SeriesCard(
              onPressed: (){
                _openSeriesPanel(savedList[i],);
              },
              series: savedList[i],
            );
          },
        ),
      ),
    );
  }


  void _openSeriesPanel(SeriesClass seriesData){
    Provider.of<ScraperService>(context, listen: false,).changeCurrentSeries(seriesData,);
  }


}
