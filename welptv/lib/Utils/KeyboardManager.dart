import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///common widget for handling FocusableActionDetector
///supports both mouse (hover) and keyboard (specific list of keys)
///supported keys: escape, tab, shift tab, enter, arrow up, arrow down
///simple callback functions for each of these events
class KeyboardManager extends StatelessWidget {

  final Function onPlaybackCallback;
  final Function onSkipForwardCallback;
  final Function onSkipBackwardCallback;
  final Function onMuteCallback;
  final Function onVolumeUpCallback;
  final Function onVolumeDownCallback;
  final Function onViewModeCallback;
  final Function onCloseCallback;
  final Widget child;

  KeyboardManager({Key key,
    this.onPlaybackCallback,
    this.onSkipForwardCallback,
    this.onSkipBackwardCallback,
    this.onMuteCallback,
    this.onVolumeUpCallback,
    this.onVolumeDownCallback,
    this.onViewModeCallback,
    this.onCloseCallback,
    this.child,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) => FocusableActionDetector(
    actions: _initActions(),
    shortcuts: _initShortcuts(),
    autofocus: true,
    enabled: true,
    child: child,
  );

  _initShortcuts() => <LogicalKeySet, Intent>{
    LogicalKeySet(LogicalKeyboardKey.space,): _Intent.playback(),
    LogicalKeySet(LogicalKeyboardKey.keyP,): _Intent.playback(),
    LogicalKeySet(LogicalKeyboardKey.keyK,): _Intent.playback(),

    LogicalKeySet(LogicalKeyboardKey.arrowRight,): _Intent.skipForward(),
    LogicalKeySet(LogicalKeyboardKey.keyL,): _Intent.skipForward(),

    LogicalKeySet(LogicalKeyboardKey.arrowLeft,): _Intent.skipBackward(),
    LogicalKeySet(LogicalKeyboardKey.keyJ,): _Intent.skipBackward(),

    LogicalKeySet(LogicalKeyboardKey.keyM): _Intent.mute(),

    LogicalKeySet(LogicalKeyboardKey.arrowUp,): _Intent.volumeUp(),
    LogicalKeySet(LogicalKeyboardKey.keyW,): _Intent.volumeUp(),

    LogicalKeySet(LogicalKeyboardKey.arrowDown,): _Intent.volumeDown(),
    LogicalKeySet(LogicalKeyboardKey.keyS,): _Intent.volumeDown(),

    LogicalKeySet(LogicalKeyboardKey.keyF,): _Intent.viewMode(),
    LogicalKeySet(LogicalKeyboardKey.enter,): _Intent.viewMode(),

    LogicalKeySet(LogicalKeyboardKey.keyI,): _Intent.close(),
    LogicalKeySet(LogicalKeyboardKey.escape,): _Intent.close(),
  };

  void _actionHandler(_Intent intent) {
    switch (intent.type) {
      case _IntentType.Playback:
        if (onPlaybackCallback != null) onPlaybackCallback();
        break;
      case _IntentType.SkipForward:
        if (onSkipForwardCallback != null) onSkipForwardCallback();
        break;
      case _IntentType.SkipBackward:
        if (onSkipBackwardCallback != null) onSkipBackwardCallback();
        break;
      case _IntentType.Mute:
        if (this.onMuteCallback != null) onMuteCallback();
        break;
      case _IntentType.VolumeUp:
        if (this.onVolumeUpCallback != null) onVolumeUpCallback();
        break;
      case _IntentType.VolumeDown:
        if (this.onVolumeDownCallback != null) onVolumeDownCallback();
        break;
      case _IntentType.ViewMode:
        if (this.onViewModeCallback != null) onViewModeCallback();
        break;
      case _IntentType.Close:
        if (this.onCloseCallback != null) onCloseCallback();
        break;
    }
  }

  _initActions() => <Type, Action<Intent>>{
    _Intent: CallbackAction<_Intent>(
      onInvoke: _actionHandler,
    ),
  };

}



// space & P & K = play/pause
// arrow left/right & J/L = skip backward/forward
// M = mute audio
// arrow up/down & W/S = volume up/down
// F/Enter = fullscreen/normal
// I/Escape = close

enum _IntentType {Playback, SkipForward, SkipBackward, Mute, VolumeUp, VolumeDown, ViewMode, Close}

class _Intent extends Intent {
  final _IntentType type;
  const _Intent({this.type});

  const _Intent.playback() : type = _IntentType.Playback;
  const _Intent.skipForward() : type = _IntentType.SkipForward;
  const _Intent.skipBackward() : type = _IntentType.SkipBackward;
  const _Intent.mute() : type = _IntentType.Mute;
  const _Intent.volumeUp() : type = _IntentType.VolumeUp;
  const _Intent.volumeDown() : type = _IntentType.VolumeDown;
  const _Intent.viewMode() : type = _IntentType.ViewMode;
  const _Intent.close() : type = _IntentType.Close;
}
