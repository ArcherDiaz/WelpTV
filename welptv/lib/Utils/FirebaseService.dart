import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:welptv/utils/CacheManagement.dart';

class FirebaseService{

  FirebaseFirestore db = FirebaseFirestore.instance;

  CacheManagement _cacheManagement = CacheManagement();

  FirebaseService(){
    _updateVisits();
  }

  void _updateVisits(){
    _cacheManagement.checkUser().then((value){
      String userID;
      if(value == null){
        userID = DateTime.now().toString();
        String codex = "abcdefghijklmnopqrstuvwxyz";
        String codex2 = "ABCDEFGHIJKLMNOPQURSTUVWXYZ";
        String codex3 = "0123456789";
        String codex4 = "!@#%^&*()_+}{|:?></.,';][=-";
        for(int i = 0; i < 10; i++){
          userID = userID + codex[Random().nextInt(codex.length)];
          userID = userID + codex2[Random().nextInt(codex2.length)];
          userID = userID + codex3[Random().nextInt(codex3.length)];
          userID = userID + codex4[Random().nextInt(codex4.length)];
        }
        _cacheManagement.saveUser(userID);
      }else{
        userID = value;
      }
      db.collection("WelpTV").doc("Visits").update({
        "visits": FieldValue.arrayUnion([{
          "date": DateTime.now().toString(),
          "user ID": userID,
        }]),
      }).then((value) async {

      });
    });
  }


  void wildPokemon(){
    db.collection("WelpTV").doc("Visits").snapshots().listen((event) {
      //TODO announce when a new user has connected to the app
    });
  }


}
