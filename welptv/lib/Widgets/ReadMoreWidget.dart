import 'package:flutter/material.dart';
import 'package:sad_lib/CustomWidgets.dart';

class ReadMoreWidget extends StatefulWidget {
  final bool isSelectable;
  final EdgeInsets padding;
  final String text;
  final TextAlign align;
  final double size;
  final Color color;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  final String fontFamily;
  final double letterSpacing;
  final double lineSpacing;
  final TextOverflow textOverflow;
  final int maxLines;
  final List<Shadow> shadows;

  ReadMoreWidget({Key key,
    this.isSelectable,
    this.padding,
    @required this.text,
    this.align,
    this.size,
    this.color,
    this.fontWeight,
    this.fontStyle,
    this.fontFamily,
    this.letterSpacing,
    this.lineSpacing,
    this.textOverflow,
    this.maxLines,
    this.shadows,
  }) : super(key: key);

  @override
  _ReadMoreWidgetState createState() => _ReadMoreWidgetState();
}

class _ReadMoreWidgetState extends State<ReadMoreWidget> {

  bool _isExpanded;

  @override
  void initState() {
    _isExpanded = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ButtonView(
      onPressed: (){
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      padding: EdgeInsets.all(5.0,),
      borderRadius: 10.0,
      highlightColor: Colors.white.withOpacity(0.2,),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextView(
              isSelectable: false,
              padding: widget.padding ?? EdgeInsets.zero,
              text: widget.text,
              align: widget.align,
              size: widget.size,
              color: widget.color,
              fontWeight: FontWeight.w400,
              fontStyle: widget.fontStyle,
              fontFamily: widget.fontFamily,
              letterSpacing: widget.letterSpacing,
              lineSpacing: widget.lineSpacing,
              textOverflow: widget.textOverflow == null ? TextOverflow.fade : widget.textOverflow,
              maxLines: _isExpanded == true ? widget.maxLines : 2,
              shadows: widget.shadows,
            ),
          ),
          SizedBox(width: 5.0,),
          Icon(_isExpanded == true ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            size: 25.0,
            color: widget.color,
          ),
        ],
      ),
    );
  }

}
