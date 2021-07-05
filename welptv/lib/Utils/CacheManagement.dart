import 'package:flutter/foundation.dart';
import 'package:sad_lib/StorageClass/StorageClass.dart';
import 'SeriesClass.dart';

class CacheManagement extends ChangeNotifier{

  StorageClass _storageClass;

  CacheManagement(){
    _storageClass = StorageClass();
  }


  Future<String> checkUser(){
    return _storageClass.readFromMap("user.welp").then((data){
      if(data.containsKey("id")){
        return data["id"];
      }else{
        return null;
      }
    });
  }

  void saveUser(String id){
    _storageClass.writeToMap("user.welp", {"id": id,});
  }


  Future<List<SeriesClass>> loadWatchlist(){
    return _storageClass.readFromMap("saved.welp").then((data){
      List<SeriesClass> _list = [];
      data.forEach((key, value) {
        _list.add(SeriesClass.fromJSON(value,));
      });
      return _list;
    });
  }

  Future<List<EpisodeClass>> loadWatchedEpisodes(SeriesClass series){
    String filename = series.name.toLowerCase().replaceAll(" ", "") + ".welp";
    return _storageClass.readFromMap(filename).then((data){
      List<EpisodeClass> _list = [];
      data.forEach((key, value) {
        _list.add(EpisodeClass.fromJSON(value, seriesName: series.name,));
      });
      return _list;
    });
  }

  Future<List<SeriesClass>> loadRecent(){
    return _storageClass.readFromMap("recent.welp").then((data){
      List<SeriesClass> _list = [];

      data.forEach((key, value) {
        _list.add(SeriesClass.fromJSON(value,));
      });

      return _list.reversed.toList();
    });
  }



  void saveToWatchlist(SeriesClass series){
    _storageClass.readFromMap("saved.welp").then((data){
      Map<String, dynamic> _list = data;

      if(!_list.containsKey(series.name)) {
        _list.putIfAbsent(series.name, () => series.toMap(),);
      }

      _storageClass.writeToMap("saved.welp", _list,);
    });
  }
  void deleteFromWatchlist(SeriesClass series){
    _storageClass.writeToMapRemove("saved.welp", series.url,);
  }

  void saveWatchedEpisode(EpisodeClass episode){
    String filename = episode.seriesName.toLowerCase().replaceAll(" ", "") + ".welp";
    _storageClass.readFromMap(filename).then((data){
      Map<String, dynamic> _list = data;

      if(!data.containsKey(episode.name)){
        _list.putIfAbsent(episode.url, () => episode.toMap(),);
      }

      _storageClass.writeToMap(filename, _list,);
    });
  }

  void saveRecent(SeriesClass series){
    _storageClass.readFromMap("recent.welp").then((data){
      Map<String, dynamic> _list = data;

      if(_list.length < 12) {
        if(data.keys.every((element) => element != series.url)) {
          _list.update(series.url, (value) => series.toMap(), ifAbsent: () => series.toMap(),);
        }
      }

      _storageClass.writeToMap("recent.welp", _list,);
    });
  }

  void deleteRecentList(){
    _storageClass.writeToMap("recent.welp", {});
  }

}
