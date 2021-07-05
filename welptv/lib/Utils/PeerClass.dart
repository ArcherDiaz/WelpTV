@JS()
library dart_peer_js;

import 'dart:html';
import 'package:flutter/foundation.dart';
import 'package:js/js.dart';
import 'dart:convert';

@JS()
external void startPeer();
@JS()
external void getPermission(String myID);
@JS()
external void connectNewUser(String theirID);
@JS()
external void sendData(String data);

@JS()
external void muteMyAudio(bool flag);
@JS()
external void leaveCall();

@JS()
external void volumeMeter(String videoID, double volume);


@JS("isPeerStillActive")
external set _isPeerStillActive(bool Function(String myID) f);
@JS("returnPeerID")
external set _returnPeerID(void Function(String myID) f);
@JS("returnPermissionResult")
external set _returnPermissionResult(void Function(bool flag) f);
@JS("returnStream")
external set _returnStream(void Function(String id, MediaStream stream, double streamVolume) f);
@JS("returnData")
external set _returnData(void Function(String data) f);




class PeerJS{

  String myPeerID;
  bool permissionOn;
  bool isMicOn = true;

  dynamic Function(String myID) onPeer;
  dynamic Function(bool flag) onPermissionResult;
  dynamic Function(String id, MediaStream stream, double streamVolume) onStream;
  dynamic Function(Map<String, dynamic> data) onDataReceived;
  PeerJS({@required this.onPeer, @required this.onPermissionResult, @required this.onStream, this.onDataReceived,}){
    if(onPeer != null){
      _returnPeerID = allowInterop(onPeer);
    }
    if(onPermissionResult != null) {
      _returnPermissionResult = allowInterop(onPermissionResult);
    }
    if(onStream != null){
      _returnStream = allowInterop(onStream);
    }
    if(onDataReceived != null) {
      _returnData = allowInterop((String data) {
        onDataReceived(json.decode(data));
      });
    }
    _isPeerStillActive = allowInterop((String id){
      return isActive;
    });
  }

  bool get isActive => myPeerID != null;

  void startPeerJS(){
    startPeer();
  }


  void getPermissionJS(String myID){
    getPermission(myID,);
  }
  void connectNewUserJS(String theirID){
    connectNewUser(theirID);
  }
  void sendDataJS(Map<String, dynamic> data){
    sendData(json.encode(data));
  }

  void toggleAudioJS(){
    isMicOn = !isMicOn;
    muteMyAudio(isMicOn);
    sendDataJS({
      "id" : myPeerID,
      "audio" : isMicOn,
    });
  }

  void leaveCallJS() {
    myPeerID = null;
    leaveCall();
  }

  void volumeMeter(String videoID, double volume){
    volumeMeter(videoID, volume);
  }

}
