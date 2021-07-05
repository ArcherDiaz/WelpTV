import 'package:flutter/material.dart';
import 'package:sad_lib/CustomWidgets.dart';
import 'package:welptv/Utils/ColorsClass.dart' as colors;

class TopPickWidget extends StatelessWidget {
  final String imageURL;
  final String seriesName;
  final void Function() onPressed;
  final Color color;
  TopPickWidget({Key key, this.imageURL, this.seriesName, this.color, this.onPressed,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonView(
      onPressed: onPressed,
      child: ImageView.network(imageKey: imageURL,
        width: MediaQuery.of(context).size.height/2.5,
        radius: 10.0,
        aspectRatio: 1.5,
        colorFilter: color == null ? Colors.green.withOpacity(0.25,) : color,
        margin: EdgeInsets.symmetric(horizontal: 10.0,),
        customLoader: CustomLoader(
          color1: colors.white,
          color2: colors.purple,
        ),
        errorView: AspectRatio(
          aspectRatio: 1.0,
          child: Container(color: colors.purple.withOpacity(0.5,),),
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextView(text: "T",
                size: 75.0,
                color: colors.black.withOpacity(0.1,),
                fontWeight: FontWeight.w600,
              ),
              TextView(text: "O",
                size: 75.0,
                color: colors.black.withOpacity(0.1,),
                fontWeight: FontWeight.w600,
              ),
              TextView(text: "P",
                size: 75.0,
                color: colors.black.withOpacity(0.1,),
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
          TextView(text: seriesName,
            size: 15.0,
            isSelectable: true,
            color: colors.white,
            fontWeight: FontWeight.w400,
          ),
        ],
      ),
    );
  }

}
