import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todox/common/common_theme.dart';
import 'package:todox/common/constants.dart';
import 'package:todox/sceen/landing/landing.dart';
import 'package:path_provider/path_provider.dart';

import 'model/todo_model.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TodoModelAdapter());
  await Hive.openBox<TodoModel>(Constants.TODO_BOX_NAME);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Todox',
        theme: CommonTheme.baseTheme,
        initialRoute: LandingScreen.route,
        routes: {
          LandingScreen.route: (_) => LandingScreen(),
//              SettingPage.route: (_) => SettingPage(),
        },
        onGenerateRoute: (RouteSettings settings) {
//          print('build route for ${settings.name}');
          var routes = <String, WidgetBuilder>{
            // DetailsScreen.route: (ctx) => DetailsScreen(novel: settings.arguments),
            // ReadingScreen.route: (ctx) => ReadingScreen(novel: settings.arguments),
            // SearchScreen.route: (ctx) => SearchScreen(),
            // HistoryScreen.route: (ctx) => HistoryScreen(),
            // NovelListScreen.route: (ctx) => NovelListScreen(args: settings.arguments),
            // SettingScreen.route: (ctx) => SettingScreen(themeNotifier),
          };
          WidgetBuilder builder = routes[settings.name]!;
          return MaterialPageRoute(builder: (ctx) => builder(ctx));
        });
  }
}
