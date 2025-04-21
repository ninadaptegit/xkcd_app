import 'package:hive_flutter/adapters.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:flutter/material.dart';
import 'package:xkcd/views/mainpage.dart';

class Startpage extends StatefulWidget {
  const Startpage({super.key});

  @override
  State<Startpage> createState() => _StartpageState();
}

class _StartpageState extends State<Startpage> {


  void initialize(){




    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainPage()),
    );


  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initialize();

  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        color: Colors.deepPurple,
        size: 200,
      ),
    );
  }
}
