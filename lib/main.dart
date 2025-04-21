import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:xkcd/viewmodel/comicViewModel.dart';
import 'package:xkcd/viewmodel/settings.dart';
import 'package:xkcd/views/mainpage.dart';
import 'package:xkcd/views/startpage.dart';

import 'classes/Comic.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('settings');
  Hive.registerAdapter(ComicAdapter());
  await Hive.openBox<Comic>('comics');
  // await Hive.initFlutter();

  // await Hive.openBox('settings');
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => settingsViewModel()),
    ChangeNotifierProvider(create: (_) => comicViewModel())
  ], child: const Base()));

}

class Base extends StatelessWidget {
  const Base({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<settingsViewModel>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: (theme.mode == Mode.light)
          ? ThemeData.light(useMaterial3: true)
          : ThemeData.dark(useMaterial3: true),
      home: const SafeArea(
        child: Scaffold(
          body: MainPage(),
        ),
      ),
    );
  }
}
