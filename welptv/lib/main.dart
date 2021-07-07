import 'package:beamer/beamer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:welptv/BeamerLocations.dart';
import 'package:welptv/Services/NotificationService.dart';
import 'package:welptv/Services/FirebaseService.dart';
import 'package:welptv/Services/ScraperService.dart';


// flutter run -d chrome --web-renderer html
// flutter build web --web-renderer html --release

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  Beamer.setPathUrlStrategy();
  runApp(AppWrapper(),);
}

class AppWrapper extends StatelessWidget {

  final RouterDelegate routerDelegate = BeamerDelegate(
    initialPath: "/home",
    notFoundRedirect: HomeLocation(),
    setBrowserTabTitle: true,
    locationBuilder: BeamerLocationBuilder(
      beamLocations: [
        HomeLocation(),
        SearchLocation(),
        LiveLocation(),
        WatchlistLocation(),
        SettingsLocation(),
        ViewingLocation(),

      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => FirebaseService(),),
        ChangeNotifierProvider(create: (context) => ScraperService(),),
        ChangeNotifierProvider(create: (context) => NotificationService(),),
      ],
      child: MaterialApp.router(
        title: "WelpTV",
        color: Colors.black,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scrollbarTheme: ScrollbarThemeData(
            thumbColor: MaterialStateProperty.all(Colors.white,),
            isAlwaysShown: false,
            radius: Radius.circular(90.0,),
            thickness: MaterialStateProperty.all(5.0),
          ),
        ),
        routeInformationParser: BeamerParser(),
        routerDelegate: routerDelegate,
        backButtonDispatcher: BeamerBackButtonDispatcher(delegate: routerDelegate,),
      ),
    );
  }


}
