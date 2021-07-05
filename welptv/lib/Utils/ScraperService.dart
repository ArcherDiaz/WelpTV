import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:welptv/utils/CacheManagement.dart';
import 'package:welptv/utils/SeriesClass.dart';

class ScraperService extends ChangeNotifier{

  CacheManagement _cacheManagement = CacheManagement();

  // https://allorigins.win/
  String _corsProxy = "https://api.allorigins.win/get?url=";
  
  Future<List<SeriesClass>> getSearch;
  Future<SeriesClass> getSeriesData;
  Future<String> getEpisode;

  ScraperService(){
    getSearch = _searchAnimeScraper("");
    getSeriesData = _getSeriesScraper("https://4anime.to/anime/shingeki-no-kyojin");
    getEpisode = _getEpisodeScraper("https://4anime.to/shingeki-no-kyojin-episode-01?id=10702",);

  }

  Future<List<SeriesClass>> _searchAnimeScraper(String searchKey) {
    return http.get(Uri.parse(_corsProxy + "https://4anime.to/?s=$searchKey",),).then((response){
      List<SeriesClass> _seriesList = [];
      dom.Document document = parser.parse(stringFix(response.body),);

      List<dom.Element> containers = document.getElementById("app-mount").getElementsByClassName("container").toList();
      dom.Element element = containers.firstWhere((container) {
        return container.parent.className == "landingHero-1OHkS9";
      });

      element.children.forEach((element) {

        if(!element.children.any((element) => element.className == "singletitletop")) {
          String _img = element.querySelector("div[id='headerDIV_95'] img").attributes["src"];
          String _name = element.querySelector("div[id='headerDIV_95'] div").text;
          String _url = element.querySelector("div[id='headerDIV_95'] a").attributes["href"];
          String _status = element.querySelector("div[id='headerDIV_95'] span").text;
          _seriesList.add(SeriesClass(
            image: _img,
            name: _name,
            release: _status,
            url: _url,),
          );
        }
      });
      return _seriesList;
    });
  }

  Future<SeriesClass> _getSeriesScraper(String seriesUrl){
    return http.get(Uri.parse(_corsProxy + seriesUrl,),).then((response){
      SeriesClass _series = SeriesClass(
        url: seriesUrl,
        genres: [],
        episodes: [],
      );
      dom.Document document = parser.parse(stringFix(response.body));

      dom.Element main = document.getElementById("main");
      dom.Element info = document.getElementById("head");
      _series.name = info.querySelector("div.content p.single-anime-desktop",).text;
      _series.image = "https://4anime.to" + main.querySelector("div.cover img",).attributes["src"];
      info.querySelector("div.content > div.ui > div.right > div.ui").children.forEach((element) {
        String _genre = element.text;
        _series.genres.add(_genre,);
      });

      dom.Element descShort = main.querySelector("div[id='stats'] div[id='description-mob']");
      _series.plot = descShort.text.replaceAll("\\nREAD LESS", "").replaceAll("\\nREAD MORE", "").replaceAll("\\n", "\n").replaceAll("Description ", "");
      if(descShort.querySelector("div[id='fullcontent']") != null) {
        _series.plot = descShort.querySelector("div[id='fullcontent']").text.replaceAll("\\nREAD LESS", "").replaceAll("\\n", "\n").replaceAll("Description ", "");
      }
      main.querySelector("section.single-anime-category ul.episodes",).children.forEach((element) {
        EpisodeClass episodeClass = EpisodeClass();
        episodeClass.seriesName = _series.name;
        episodeClass.url = element.querySelector("a").attributes["href"];
        episodeClass.name = _series.name + ": " + element.querySelector("a").text.trim();
        _series.episodes.add(episodeClass,);
      });

      _cacheManagement.saveRecent(_series,);
      return _cacheManagement.loadWatchlist().then((value){
        if(value.any((element) => element.url == _series.url)){
          _series.isSavedToWatchlist = true;
        }else{
          _series.isSavedToWatchlist = false;
        }
        return _series;
      });
    }).catchError((onError){
      print(onError.toString(),);
      return null;
    });
  }

  Future<String> _getEpisodeScraper(String episodeUrl){
    return http.get(Uri.parse(_corsProxy + episodeUrl,),).then((response){
      dom.Document document = parser.parse(stringFix(response.body,));

      List<dom.Element> videoElement = document.getElementById("justtothetop").getElementsByClassName("videojs-desktop").toList();
      String videoUrl = videoElement[0].querySelector("source").attributes["src"];
      return videoUrl;
    });
  }


  void searchForSeries(String searchKey){
    getSearch = _searchAnimeScraper(searchKey,);
    notifyListeners();
  }

  void changeCurrentSeries(SeriesClass newSeries){
    getSeriesData = _getSeriesScraper(newSeries.url,);
    notifyListeners();
  }

  void scrapeEpisodeData(String episodeUrl){
    getEpisode = _getEpisodeScraper(episodeUrl,);
    notifyListeners();
  }

  String stringFix(String badString) {
    return badString.replaceAll("&amp;", "&").replaceAll("\\\"", "").replaceAll("&apos;", "'").replaceAll("&gt;", ">").replaceAll("&lt;", "<");
  }

}
