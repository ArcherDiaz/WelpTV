import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:sad_lib/CustomWidgets.dart';
import 'package:welptv/Utils/ColorsClass.dart' as colors;
import 'package:welptv/Widgets/Navigation.dart';
import 'package:welptv/Widgets/SeriesCard.dart';
import 'package:welptv/Services/ScraperService.dart';
import 'package:welptv/utils/SeriesClass.dart';

class SearchTab extends StatefulWidget {
  SearchTab({Key key,}) : super(key: key);
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {

  TextEditingController _textController;
  ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colors.black,
      child: Navigation(
        child: Consumer<ScraperService>(
          builder: (context, service, child){
            return FutureBuilder(
              future: service.getSearch,
              builder: (context, snapshot){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _searchBar(
                      isLoading: snapshot.connectionState != ConnectionState.done,
                    ),
                    _resultsHeader(
                      resultsLength: snapshot.data == null ? 0 : snapshot.data.length,
                      isLoading: snapshot.connectionState != ConnectionState.done,
                    ),
                    _results(snapshot.data == null ? [] : snapshot.data,),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _searchBar({bool isLoading = false}){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: HoverWidget(
            idle: ContainerChanges(
              margin: EdgeInsets.symmetric(vertical: 20.0,),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(45.0,),
                border: Border.all(color: colors.midGrey, width: 1.0,),
              ),
            ),
            onHover: ContainerChanges(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(45.0,),
                border: Border.all(color: colors.white, width: 1.0,),
              ),
            ),
            child: TextField(
              controller: _textController,
              readOnly: isLoading, // if there is a search loading right now, disable the textfield
              autocorrect: true,
              autofocus: false,
              enableSuggestions: true,
              maxLines: 1,
              textAlignVertical: TextAlignVertical.center,
              textCapitalization: TextCapitalization.words,
              toolbarOptions: ToolbarOptions(selectAll: true, copy: true, paste: true, cut: true,),
              style: TextStyle(color: colors.white, fontSize: 17.5, fontWeight: FontWeight.w400,),
              cursorColor: colors.white,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              onSubmitted: (text){
                Provider.of<ScraperService>(context, listen: false,).searchForSeries(text,);
              },
              decoration: InputDecoration(
                hintText: "Search..",
                hintStyle: TextStyle(color: colors.midGrey, fontSize: 17.5, fontWeight: FontWeight.w400,),
                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0,),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(45.0,),
                  borderSide: BorderSide(color: colors.white, width: 0.5,),
                ),
              ),
            ),
          ),
        ),
        ButtonView(
          onPressed: (){
            if(!isLoading){ //if there is a searched loading right now, then start this new search
              Provider.of<ScraperService>(context, listen: false,).searchForSeries(_textController.text,);
            }
          },
          highlightColor: colors.white.withOpacity(0.2,),
          margin: EdgeInsets.symmetric(horizontal: 10.0,),
          padding: EdgeInsets.all(10.0,),
          child: Tooltip(
            message: "Search for '${_textController.text}'",
            child: Icon(Icons.search_outlined,
              color: colors.white,
              size: 25.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _resultsHeader({int resultsLength = 0, bool isLoading = false}){
    if(isLoading == true){
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0,),
        child: CustomLoader(
          indicator: IndicatorType.linear,
          color1: colors.white,
          color2: colors.midGrey,
        ),
      );
    }else{
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0,),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextView(text: "$resultsLength RESULTS FOUND",
                isSelectable: true,
                letterSpacing: 1.5,
                size: 17.5,
                color: colors.midGrey,
                fontWeight: FontWeight.w400,
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
  }

  Widget _results(List<SeriesClass> _resultsList){
    return Expanded(
      child: Scrollbar(
        controller: _scrollController,
        child: StaggeredGridView.countBuilder(
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          itemCount: _resultsList.length,
          crossAxisCount: isMobile ? 2 : 4,
          padding: EdgeInsets.only(top: 20.0, bottom: 40.0, right: 10.0,),
          staggeredTileBuilder: (index){
            return StaggeredTile.fit(1);
          },
          itemBuilder: (context, i){
            return SeriesCard(
              onPressed: (){
                _openSeriesPanel(_resultsList[i],);
              },
              series: _resultsList[i],
            );
          },
        ),
      ),
    );
  }


  void _openSeriesPanel(SeriesClass seriesData){
    Provider.of<ScraperService>(context, listen: false,).changeCurrentSeries(seriesData,);
  }

  bool get isMobile {
    Size _size = MediaQuery.of(context,).size;
    if(_size.width > 1000 || _size.height > 1000){
      return false;
    }else{
      return true;
    }
  }

}
