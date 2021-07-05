import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sad_lib/CustomWidgets.dart';
import 'package:video_player/video_player.dart';
import 'package:welptv/Utils/ColorsClass.dart' as colors;
import 'package:welptv/utils/KeyboardManager.dart';

class VideoWidget extends StatefulWidget {
  final String title;
  final String videoUrl;
  final List<Widget> children;
  final void Function() onClose;
  final void Function(Duration currentTime, Duration maxtime) videoListener;
  VideoWidget({Key key, @required this.title,
    @required this.videoUrl,
    this.children = const [],
    @required this.onClose,
    @required this.videoListener,
  }) : super(key: key);
  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {

  ScrollController _scrollController;

  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  Timer viewControls;

  bool _showControls;

  Size _size;

  @override
  void initState() {
    _showControls = true;
    _scrollController = ScrollController();
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl,);
    _initializeVideoPlayerFuture = _controller.initialize().then((value){
      return value;
    });
    _controller.setVolume(0.5,);
    _controller.play();
    _controller.addListener(() {
      if(widget.videoListener != null){
        widget.videoListener(_controller.value.position, _controller.value.duration,);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    viewControls.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return KeyboardManager(
      onPlaybackCallback: (){
        setState(() {
          if(_controller.value.isPlaying) {
            _controller.pause();
          } else {
            _controller.play();
          }
        });
      },
      onSkipForwardCallback: (){
        int newPosition = _controller.value.position.inSeconds + 10;
        setState(() {
          _controller.seekTo(Duration(seconds: newPosition,),);
        });
      },
      onSkipBackwardCallback: (){
        int newPosition = _controller.value.position.inSeconds - 10;
        setState(() {
          _controller.seekTo(Duration(seconds: newPosition,),);
        });
      },
      onMuteCallback: (){
        setState(() {
          if(_controller.value.volume == 0.0) {
            _controller.setVolume(0.5,);
          } else {
            _controller.setVolume(0.0,);
          }
        });
      },
      onVolumeUpCallback: (){
        setState(() {
          double _volume = _controller.value.volume + 0.1;
          _controller.setVolume(_volume,);
        });
      },
      onVolumeDownCallback: (){
        setState(() {
          double _volume = _controller.value.volume - 0.1;
          _controller.setVolume(_volume,);
        });
      },
      onViewModeCallback: (){
      },
      onCloseCallback: (){
        setState(() {
          if(_controller.value.isPlaying) {
            _controller.pause();
          }
        });
        widget.onClose();
      },
      child: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            return MouseRegion(
              onHover: onHover,
              child: _main(),
            );
          }else{
            return CustomLoader(
              color1: colors.white,
              color2: colors.midGrey,
            );
          }
        },
      ),
    );
  }

  Widget _main(){
    return SizedBox(
      width: _size.width,
      height: _size.height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: _size.width,
            height: _size.height,
            child: VideoPlayer(_controller,),
          ),

          if(_controller.value.hasError)
            TextView(text: _controller.value.errorDescription,
              padding: EdgeInsets.all(15.0,),
              size: 17.5,
              align: TextAlign.center,
              isSelectable: true,
              color: colors.white,
              fontWeight: FontWeight.w400,
            ),

          if(_controller.value.isBuffering)
            CustomLoader(
              color1: colors.white,
              color2: colors.midGrey,
            ),

          GestureDetector(
            onTap: (){
              setState(() {
                if(_size.width < 900 && _size.height < 900){
                  setState(() {
                    _showControls = !_showControls;
                  });
                } else{
                  if(_controller.value.isPlaying) {
                    _controller.pause();
                  } else {
                    _controller.play();
                  }
                }
              });
            },
            onDoubleTap: (){
              setState(() {
                if(_controller.value.isPlaying) {
                  _controller.pause();
                } else {
                  _controller.play();
                }
              });
            },
          ),

          Opacity(
            opacity: _showControls ? 1.0 : 0.0,
            child: _controlPanel(),
          ),
        ],
      ),
    );
  }

  Widget _controlPanel(){
    if (_size.width > 900 || _size.height > 900) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0,),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _slider(),
              SizedBox(height: 5.0,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _mediaButtons(),
                  TextView.rich(
                    textSpan: [
                      TextView(text: _formatTime(_controller.value.position,),
                        color: colors.white,
                        size: 12.5,
                        fontWeight: FontWeight.w500,
                      ),
                      TextView(text: " / ",
                        color: colors.white,
                        size: 15.0,
                        fontWeight: FontWeight.w400,
                      ),
                      TextView(text: _formatTime(_controller.value.duration,),
                        color: colors.midGrey,
                        size: 12.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                    padding: EdgeInsets.symmetric(horizontal: 20.0,),
                  ),
                  _volumeSlider(),
                  _customControls(),
                  ButtonView(
                    onPressed: (){
                      setState(() {
                        if(_controller.value.isPlaying) {
                          _controller.pause();
                        }
                      });
                      widget.onClose();
                    },
                    borderRadius: 360.0,
                    padding: EdgeInsets.all(5.0,),
                    highlightColor: colors.white.withOpacity(0.2,),
                    child: Icon(Icons.close_outlined,
                      color: colors.white,
                      size: 25.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      return Column(
        children: [
          Expanded(
            child: _mediaButtons(isMobile: true,),
          ),
          _slider(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0,),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextView.rich(
                  textSpan: [
                    TextView(text: _formatTime(_controller.value.position,),
                      color: colors.white,
                      size: 12.5,
                      fontWeight: FontWeight.w500,
                    ),
                    TextView(text: " / ",
                      color: colors.white,
                      size: 15.0,
                      fontWeight: FontWeight.w400,
                    ),
                    TextView(text: _formatTime(_controller.value.duration,),
                      color: colors.midGrey,
                      size: 12.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                  padding: EdgeInsets.symmetric(horizontal: 20.0,),
                ),
                _volumeSlider(),
                _customControls(),
                ButtonView(
                  onPressed: (){
                    setState(() {
                      if(_controller.value.isPlaying) {
                        _controller.pause();
                      }
                    });
                    widget.onClose();
                  },
                  borderRadius: 360.0,
                  padding: EdgeInsets.all(5.0,),
                  highlightColor: colors.white.withOpacity(0.2,),
                  child: Icon(Icons.close_outlined,
                    color: colors.white,
                    size: 25.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  Widget _slider(){
    return SliderTheme(
      data: SliderThemeData(
        activeTrackColor: colors.purple,
        inactiveTrackColor: colors.midGrey,
        trackHeight: 3.0,
        trackShape: RoundedRectSliderTrackShape(),
        thumbColor: colors.white,
        thumbShape: SliderComponentShape.noThumb,
        overlayColor: colors.white,
        overlappingShapeStrokeColor: colors.white,
        overlayShape: RoundSliderThumbShape(enabledThumbRadius: 3.0,),
      ),
      child: Slider(
        value: _controller.value.position.inSeconds.floorToDouble(),
        min: 0.0,
        max: _controller.value.duration.inSeconds.floorToDouble(),
        onChanged: (double value) {
          setState(() {
            _controller.seekTo(Duration(seconds: value.floor()));
          });
        },
      ),
    );
  }

  Widget _mediaButtons({bool isMobile = false}){
    return Row(
      mainAxisAlignment: isMobile ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if(isMobile)
          ButtonView(
            onPressed: (){
              int newPosition = _controller.value.position.inSeconds - 10;
              setState(() {
                _controller.seekTo(Duration(seconds: newPosition,),);
              });
            },
            borderRadius: 360.0,
            margin: EdgeInsets.symmetric(horizontal: 5.0,),
            padding: EdgeInsets.all(5.0,),
            highlightColor: colors.white.withOpacity(0.2,),
            child: Icon(Icons.replay_10_outlined,
              color: colors.white,
              size: isMobile ? 55.0 : 30.0,
            ),
          ),
        ButtonView(
          onPressed: (){
            setState(() {
              if(_controller.value.isPlaying) {
                _controller.pause();
              } else {
                _controller.play();
              }
            });
          },
          borderRadius: 360.0,
          padding: EdgeInsets.all(5.0,),
          highlightColor: colors.white.withOpacity(0.2,),
          child: Icon(_controller.value.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
            color: colors.white,
            size: isMobile ? 60.0 : 30.0,
          ),
        ),
        if(!isMobile)
          ButtonView(
            onPressed: (){
              int newPosition = _controller.value.position.inSeconds - 10;
              setState(() {
                _controller.seekTo(Duration(seconds: newPosition,),);
              });
            },
            borderRadius: 360.0,
            margin: EdgeInsets.symmetric(horizontal: 5.0,),
            padding: EdgeInsets.all(5.0,),
            highlightColor: colors.white.withOpacity(0.2,),
            child: Icon(Icons.replay_10_outlined,
              color: colors.white,
              size: isMobile ? 55.0 : 30.0,
            ),
          ),
        ButtonView(
          onPressed: (){
            int newPosition = _controller.value.position.inSeconds + 10;
            setState(() {
              _controller.seekTo(Duration(seconds: newPosition,),);
            });
          },
          borderRadius: 360.0,
          padding: EdgeInsets.all(5.0,),
          highlightColor: colors.white.withOpacity(0.2,),
          child: Icon(Icons.forward_10_outlined,
            color: colors.white,
            size: isMobile ? 55.0 : 30.0,
          ),
        ),
      ],
    );
  }

  Widget _volumeSlider(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ButtonView(
          onPressed: (){
            setState(() {
              if(_controller.value.volume == 0.0) {
                _controller.setVolume(0.5,);
              } else {
                _controller.setVolume(0.0,);
              }
            });
          },
          borderRadius: 360.0,
          margin: EdgeInsets.only(left: 10.0,),
          padding: EdgeInsets.all(5.0,),
          highlightColor: colors.white.withOpacity(0.2,),
          child: Icon(_controller.value.volume > 0.0 ? Icons.volume_up : Icons.volume_off,
            color: colors.white,
            size: 25.0,
          ),
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: colors.white,
            inactiveTrackColor: colors.midGrey,
            trackHeight: 3.0,
            trackShape: RoundedRectSliderTrackShape(),
            thumbColor: colors.white,
            thumbShape: SliderComponentShape.noThumb,
            overlayColor: colors.white,
            overlappingShapeStrokeColor: colors.white,
            overlayShape: RoundSliderThumbShape(enabledThumbRadius: 3.0,),
          ),
          child: Slider(
            value: _controller.value.volume,
            min: 0.0,
            max: 1.0,
            onChanged: (double value) {
              setState(() {
                _controller.setVolume(value,);
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _customControls(){
    return Expanded(
      child: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 10.0,),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: widget.children,
          ),
        ),
      ),
    );
  }



  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");

    String twoDigitHours = twoDigits(duration.inHours.remainder(24));
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if(_controller.value.duration.inHours != 0) {
      return "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
    }
    if(_controller.value.duration.inMinutes != 0) {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
    return "$twoDigitSeconds";
  }

  void onHover(PointerEvent event) {
    if((event.delta.distance > 0.0 || event.delta.distance < 0.0)){
      setState(() {
        _showControls = true;
      });
      if (viewControls != null && viewControls.isActive) {
        viewControls.cancel();
      }
    }else{
      if (viewControls == null || (viewControls != null && !viewControls.isActive)) {
        viewControls = Timer(Duration(seconds: 5), () {
          setState(() {
            _showControls = false;
          });
        });
      }
    }
  }

}