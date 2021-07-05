import 'package:flutter/material.dart';

class SeriesClass{

  String image;
  String name;
  String release;
  String url;

  String plot;
  List<String> genres;
  List<EpisodeClass> episodes;

  Color seriesColor;
  bool isSavedToWatchlist = false;

  SeriesClass({
    this.image,
    this.name,
    this.plot,
    this.genres,
    this.release,
    this.url,
    this.episodes,
  });

  SeriesClass.fromJSON(dynamic data){
    if(data != null && data.isNotEmpty){
      if(data.containsKey("image")){
        this.image = data["image"];
      }
      if(data.containsKey("name")){
        this.name = data["name"];
      }
      if(data.containsKey("release")){
        this.release = data["release"];
      }
      if(data.containsKey("url")){
        this.url = data["url"];
      }
      if(data.containsKey("plot")){
        this.plot = data["plot"];
      }
      if(data.containsKey("genres")){
        this.genres = [];
        data["genres"].forEach((element){
          this.genres.add(element.toString(),);
        });
      }
      if(data.containsKey("episodes")){
        this.episodes = [];
        data["episodes"].forEach((element){
          this.episodes.add(EpisodeClass.fromJSON(
            element,
            seriesName: name,
          ),);
        });
      }

      if(data.containsKey("color")){
        seriesColor = Color.fromRGBO(data["color"]["red"], data["color"]["green"], data["color"]["blue"], 0.25,);
      }
    }
  }

  bool get containsImage => this.image != null && this.image.isNotEmpty;

  bool get containsName => this.name != null && this.name.isNotEmpty;

  bool get containsRelease => this.release != null && this.release.isNotEmpty;

  bool get hasGenres => this.genres != null && this.genres.isNotEmpty;

  bool get hasEpisodes => this.episodes != null && this.episodes.isNotEmpty;

  Map<String, dynamic> toMap(){
    return {
      "image": image == null ? "" : image,
      "name": name == null ? "" : name,
      "plot": plot == null ? "" : plot,
      "genres": genres == null ? [] : genres,
      "release": release == null ? "" : release,
      "url": url == null ? "" : url,
      "episodes": episodes == null ? [] : episodesToMap(),
    };
  }

  List<Map<String, dynamic>> episodesToMap(){
    List<Map<String, dynamic>> _list = [];

    for(int i = 0; i < episodes.length; i++){
      _list.add(episodes[i].toMap());
    }
    return _list;
  }

}

class EpisodeClass{

  String seriesName;
  String name;
  String url;

  EpisodeClass({this.seriesName, this.name, this.url,});

  EpisodeClass.fromJSON(dynamic data, {this.seriesName = "",}){
    if(data != null && data.isNotEmpty){
      if(data.containsKey("name")){
        this.name = data["name"];
      }
      if(data.containsKey("url")){
        this.url = data["url"];
      }
    }
  }

  bool get containsUrl => this.url != null;
  bool get containsName => this.name != null;

  Map<String, dynamic> toMap(){
    return {
      "name": name,
      "url": url,
    };
  }

  @override
  String toString() {
    return "$name \n $url \n$seriesName";
  }

}
