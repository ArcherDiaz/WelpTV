import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:sad_lib/CustomWidgets.dart';
import 'package:welptv/Utils/ColorsClass.dart' as colors;
import 'package:welptv/Widgets/ReadMoreWidget.dart';
import 'package:welptv/utils/CacheManagement.dart';
import 'package:welptv/utils/ScraperService.dart';
import 'package:welptv/utils/SeriesClass.dart';

class SeriesPanel extends StatefulWidget {
  SeriesPanel({Key key,}) : super(key: key);
  @override
  _SeriesPanelState createState() => _SeriesPanelState();
}

class _SeriesPanelState extends State<SeriesPanel> {

  CacheManagement _cacheManagement = CacheManagement();

  Size _size;

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Material(
      color: Colors.black,
      child: Container(
        height: _size.height,
        decoration: BoxDecoration(
          color: colors.white.withOpacity(0.05,),
          borderRadius: BorderRadius.circular(20.0,),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0,),
            child: Consumer<ScraperService>(
              builder: (context, service, child){
                return FutureBuilder(
                  future: service.getSeriesData,
                  builder: (context, snapshot){
                    if(snapshot.connectionState == ConnectionState.done){
                      if(snapshot.hasData){
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _details(snapshot.data,),
                            TextView(text: "EPISODES",
                              padding: EdgeInsets.only(top: 30.0, bottom: 5.0,),
                              size: 10.0,
                              isSelectable: true,
                              color: colors.midGrey,
                              fontWeight: FontWeight.w500,
                            ),
                            _episodes(snapshot.data,),
                          ],
                        );
                      }else{
                        return TextView(text: snapshot.error.toString(),
                          size: 17.5,
                          align: TextAlign.center,
                          isSelectable: true,
                          color: colors.white,
                          fontWeight: FontWeight.w400,
                        );
                      }
                    }else{
                      return CustomLoader(
                        alignment: Alignment.center,
                        color1: colors.white,
                        color2: colors.midGrey,
                      );
                    }
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _details(SeriesClass _seriesData){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(_seriesData.containsImage)
              ImageView.network(imageKey: _seriesData.image,
                height: _size.height/4,
                radius: 10.0,
                margin: EdgeInsets.only(right: 15.0,),
                customLoader: CustomLoader(
                  color1: colors.white,
                  color2: colors.purple,
                ),
                errorView: AspectRatio(
                  aspectRatio: 1.0,
                  child: Container(color: colors.purple.withOpacity(0.5,),),
                ),
              ),

            if(_seriesData.containsName)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextView(text: _seriesData.name.toUpperCase(),
                      padding: EdgeInsets.only(bottom: 20.0,),
                      size: 20.0,
                      isSelectable: true,
                      color: colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    TextView(text: _seriesData.genres.toString(),
                      padding: EdgeInsets.only(bottom: 20.0,),
                      size: 15.0,
                      isSelectable: true,
                      color: colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                    if(_seriesData.containsRelease)
                      TextView(text: _seriesData.release.toString(),
                        padding: EdgeInsets.only(bottom: 20.0,),
                        size: 17.5,
                        isSelectable: true,
                        color: colors.white,
                        fontWeight: FontWeight.w500,
                      ),

                    ButtonView(
                      onPressed: (){
                        if(_seriesData.isSavedToWatchlist == true){
                          _cacheManagement.deleteFromWatchlist(_seriesData,);
                          setState(() {
                            _seriesData.isSavedToWatchlist = false;
                          });
                        }else {
                          _cacheManagement.saveToWatchlist(_seriesData,);
                          setState(() {
                            _seriesData.isSavedToWatchlist = true;
                          });
                        }
                      },
                      border: Border.all(color: colors.midGrey, width: 1.0,),
                      highlightColor: colors.white.withOpacity(0.2,),
                      margin: EdgeInsets.symmetric(vertical: 10.0,),
                      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0,),
                      child: TextView(text: _seriesData.isSavedToWatchlist == true ? "Remove From Watchlist" : "Save To Watchlist",
                        size: 15.0,
                        letterSpacing: 0.0,
                        align: TextAlign.center,
                        color: colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        TextView(text: "PLOT",
          padding: EdgeInsets.only(top: 20.0, bottom: 5.0,),
          size: 10.0,
          isSelectable: true,
          color: colors.midGrey,
          fontWeight: FontWeight.w500,
        ),
        ReadMoreWidget(text: _seriesData.plot,
          size: 15.0,
          isSelectable: true,
          color: colors.white,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }

  Widget _episodes(SeriesClass _seriesData){
    return FutureBuilder(
      future: _cacheManagement.loadWatchedEpisodes(_seriesData,),
      builder: (context, AsyncSnapshot<List<EpisodeClass>> snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          return StaggeredGridView.countBuilder(
            scrollDirection: Axis.vertical,
            itemCount: _seriesData.episodes.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            padding: EdgeInsets.only(bottom: 40.0,),
            staggeredTileBuilder: (index){
              return StaggeredTile.fit(1);
            },
            itemBuilder: (context, i){
              bool _isWatched = snapshot.data.any((element) => element.url == _seriesData.episodes[i].url);
              return ButtonView(
                onPressed: (){
                  Beamer.of(context).beamToNamed("/watch",
                    data: {"episode": _seriesData.episodes[i],},
                  );
                },
                color: _isWatched
                    ? colors.midGrey.withOpacity(0.2,)
                    : Colors.transparent,
                border: Border.all(color: colors.midGrey, width: 1.0,),
                highlightColor: colors.white.withOpacity(0.2,),
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0,),
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0,),
                children: [
                  Expanded(
                    child: TextView(text: (i+1).toString(),
                      size: 15.0,
                      letterSpacing: 0.0,
                      align: TextAlign.center,
                      color: _isWatched ? colors.purple : colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Tooltip(
                    message: "Play episode ${(i+1)}",
                    child: Icon(_isWatched ? Icons.check : Icons.play_arrow_outlined,
                      color: _isWatched ? colors.purple : colors.white,
                      size: 25.0,
                    ),
                  ),
                ],
              );
            },
          );
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

}
