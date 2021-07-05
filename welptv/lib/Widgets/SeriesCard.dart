import 'package:flutter/material.dart';
import 'package:sad_lib/CustomWidgets.dart';
import 'package:welptv/Utils/ColorsClass.dart' as colors;
import 'package:welptv/utils/SeriesClass.dart';

enum CardView {verticalView, horizontalView}

class SeriesCard extends StatelessWidget {

  final CardView cardView;
  final void Function() onPressed;
  final SeriesClass series;
  SeriesCard({Key key, this.cardView = CardView.verticalView, @required this.onPressed, @required this.series,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: cardView == CardView.verticalView ? 5.0 : 10.0,
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10.0,),
        highlightColor: colors.white.withOpacity(0.2,),
        hoverColor: colors.white.withOpacity(0.05,),
        splashColor: Colors.transparent,
        child: cardView == CardView.verticalView
            ? _verticalView()
            : _horizontalView(),
      ),
    );
  }

  Widget _verticalView(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if(series.containsImage)
          ImageView.network(imageKey: series.image,
            width: double.infinity,
            radius: 10.0,
            margin: EdgeInsets.only(bottom: 10.0,),
            customLoader: AspectRatio(
              aspectRatio: 1.0,
              child: CustomLoader(
                color1: colors.white,
                color2: colors.purple,
              ),
            ),
            errorView: AspectRatio(
              aspectRatio: 1.0,
              child: Container(color: colors.purple.withOpacity(0.5,),),
            ),
          ),

        if(series.containsName)
          TextView(text: series.name,
            padding: EdgeInsets.symmetric(vertical: 10.0,),
            align: TextAlign.center,
            size: 15.0,
            color: colors.white,
            fontWeight: FontWeight.w400,
          ),

        if(series.containsRelease)
          TextView(text: series.release,
            padding: EdgeInsets.only(bottom: 10.0,),
            size: 15.0,
            color: colors.white,
            fontWeight: FontWeight.w400,
          ),
      ],
    );
  }

  Widget _horizontalView(){
    return LayoutBuilder(
      builder: (context, constraints){
        return SizedBox(
          width: constraints.maxWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if(series.containsImage)
                ImageView.network(imageKey: series.image,
                  width: constraints.maxWidth/5,
                  aspectRatio: 1.0,
                  radius: 10.0,
                  margin: EdgeInsets.only(right: 10.0,),
                  customLoader: AspectRatio(
                    aspectRatio: 1.0,
                    child: CustomLoader(
                      color1: colors.white,
                      color2: colors.purple,
                    ),
                  ),
                  errorView: AspectRatio(
                    aspectRatio: 1.0,
                    child: Container(color: colors.purple.withOpacity(0.5,),),
                  ),
                ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if(series.containsName)
                      TextView(text: series.name,
                        padding: EdgeInsets.only(right: 10.0, bottom: 10.0,),
                        size: 15.0,
                        maxLines: 1,
                        color: colors.white,
                        fontWeight: FontWeight.w600,
                      ),

                    if(series.containsRelease)
                      TextView(text: series.release,
                        padding: EdgeInsets.only(right: 10.0,),
                        size: 15.0,
                        maxLines: 1,
                        color: colors.midGrey,
                        fontWeight: FontWeight.w400,
                      ),

                    if(series.hasGenres)
                      TextView(text: series.genres.toString(),
                        padding: EdgeInsets.only(right: 10.0,),
                        size: 15.0,
                        maxLines: 1,
                        color: colors.midGrey,
                        fontWeight: FontWeight.w400,
                      ),
                  ],
                ),
              ),

              if(series.hasEpisodes)
                TextView(text: series.episodes.length.toString() + " Eps",
                  padding: EdgeInsets.symmetric(horizontal: 10.0,),
                  size: 15.0,
                  maxLines: 1,
                  color: colors.midGrey,
                  fontWeight: FontWeight.w600,
                ),
            ],
          ),
        );
      },
    );
  }

}
