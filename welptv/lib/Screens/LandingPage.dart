import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sad_lib/CustomWidgets.dart';
import '../utils/ColorsClass.dart' as colors;

class LandingPage extends StatefulWidget {
  const LandingPage({Key key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                TextView(
                  text: "WelpTv.",
                  color: colors.white,
                  size: 45.0,
                  fontWeight: FontWeight.w700,
                  padding: EdgeInsets.only(right: 5.0),
                ),
                SvgPicture.asset(
                  "assets/logo.svg",
                  width: 50.0,
                  height: 50.0,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    TextView(
                      text: "An Anime App",
                      color: colors.white,
                      size: 35.0,
                      fontWeight: FontWeight.w500,
                      padding: EdgeInsets.only(bottom: 30.0),
                    ),
                    TextView(
                      text: "Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.",
                      color: colors.white,
                      size: 55.0,
                      fontWeight: FontWeight.w400,
                      padding: EdgeInsets.only(bottom: 50.0),
                    ),
                    ButtonView(
                      onPressed: () {},
                      color: colors.purple,
                      borderRadius: 10.0,
                      child: TextView(
                        text: "Install App",
                        color: colors.white,
                        size: 20.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Container(
                  child: SvgPicture.asset(
                    "assets/display.svg",
                    width: 500.0,
                    height: 400.0,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
