import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:welptv/Screens/HomeScreen.dart';
import 'package:welptv/Screens/LiveScreen.dart';
import 'package:welptv/Screens/ViewingScreen.dart';
import 'package:welptv/Screens/WatchlistScreen.dart';
import 'package:welptv/Screens/SearchScreen.dart';
import 'package:welptv/Screens/SettingsScreen.dart';

class HomeLocation extends BeamLocation{
  HomeLocation({BeamState state}) : super(state);

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
        key: ValueKey("home"),
        title: "WelpTV | Home",
        name: '/home',
        type: BeamPageType.noTransition,
        child: HomeTab(),
      ),
    ];
  }

  @override
  List get pathBlueprints => ["/home",];

}

class SearchLocation extends BeamLocation{
  SearchLocation({BeamState state}) : super(state);

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
        key: ValueKey("search"),
        title: "WelpTV | Search",
        name: '/search',
        type: BeamPageType.noTransition,
        child: SearchTab(),
      ),
    ];
  }

  @override
  List get pathBlueprints => ["/search", "/explore"];

}

class LiveLocation extends BeamLocation{
  LiveLocation({BeamState state}) : super(state);

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
        key: ValueKey("live"),
        title: "WelpTV | Live",
        name: '/live',
        type: BeamPageType.noTransition,
        child: LiveTab(),
      ),
    ];
  }

  @override
  List get pathBlueprints => ["/live", "/community"];

}

class WatchlistLocation extends BeamLocation{
  WatchlistLocation({BeamState state}) : super(state);

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
        key: ValueKey("watchlist"),
        title: "WelpTV | Watchlist",
        name: '/watchlist',
        type: BeamPageType.noTransition,
        child: WatchlistTab(),
      ),
    ];
  }

  @override
  List get pathBlueprints => ["/watchlist", "/saved", "/bookmarks"];

}

class SettingsLocation extends BeamLocation{
  SettingsLocation({BeamState state}) : super(state);

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
        key: ValueKey("settings"),
        title: "WelpTV | Settings",
        name: '/settings',
        type: BeamPageType.noTransition,
        child: SettingsTab(),
      ),
    ];
  }

  @override
  List get pathBlueprints => ["/settings",];

}

class ViewingLocation extends BeamLocation{
  ViewingLocation({BeamState state}) : super(state);

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
        key: ValueKey("viewing"),
        title: "WelpTV | Watch",
        name: '/watch',
        type: BeamPageType.noTransition,
        child: ViewingScreen(
          episode: state.data["episode"],
        ),
      ),
    ];
  }

  @override
  List get pathBlueprints => ["/view", "/viewing", "/watch"];

}
