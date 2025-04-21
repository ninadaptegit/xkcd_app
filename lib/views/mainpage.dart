import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as html;
import 'package:html/parser.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:xkcd/viewmodel/settings.dart';

import '../classes/Comic.dart';
import '../viewmodel/comicViewModel.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static const double _arrorSize = 50;
  Comic? comic;
  Future<void> fetchRandomUrl() async {
    setState(() {
      comic = null;
    });
    final url = Uri.parse("https://c.xkcd.com/random/comic/");
    try {
      http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        var document = parse(response.body);

        late String title;
        late String imageUrl;
        List<html.Element> children =
            document.head!.children.cast<html.Element>();
        for (html.Element meta in children) {
          if (meta.attributes['property'] == "og:title") {
            title = meta.attributes['content']!;
          }
          if (meta.attributes['property'] == "og:image") {
            imageUrl = meta.attributes['content']!;
          }
        }

        setState(() {
          comic = Comic(title, imageUrl);
        });
      } else {
        print("error");
        if (kDebugMode) {
          print("Error: ${response.body}");
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRandomUrl();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<settingsViewModel>(context);
    final comicProvider = Provider.of<comicViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("XKCD"),
        centerTitle: true,
        toolbarHeight: 60.2,
        toolbarOpacity: 1,
        actions: <Widget>[
          //IconButton
          IconButton(
            icon: const Icon(Icons.contrast),
            tooltip: 'Toggle Mode',
            onPressed: () {
              theme.toggleMode();
            },
          ),

          //IconButton
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
             DrawerHeader(child: LoadingAnimationWidget.staggeredDotsWave(
               color: (theme.mode==Mode.light)?Colors.black:Colors.white,
              size: 50,
            ),
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: comicProvider.comics.length,
                    itemBuilder: (context, index) {
                      final comic1 = comicProvider.comics[index];
                      return ListTile(
                        trailing: IconButton(
                            onPressed: () async {
                              await comicProvider.deleteComic(comic1);
                              await comicProvider.getAllComics();
                            },
                            icon: const Icon(
                              Icons.delete_rounded,
                            )),
                        title: Text(comic1.title),
                        onTap: () => {
                          setState(() {
                            comic = comic1;
                          })
                        },
                      );
                    }))
          ],
        ), // Populate the Drawer in the next step.
      ),
      body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(),
          child: Stack(
            children: [
              ListView(children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      (comic == null)
                          ? const Text("")
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    comic!.title,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                      (comic == null)
                          ? const CircularProgressIndicator()
                          : CachedNetworkImage(
                              imageUrl: comic!.image_url,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                    ],
                  ),
                ),
              ]),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () => {fetchRandomUrl()},
                          icon: const Icon(
                            Icons.next_plan,
                            size: _arrorSize,
                          )),
                      IconButton(
                          onPressed: () async {
                            await comicProvider.addComic(comic!);
                            await comicProvider.getAllComics();

                            const snackBar = SnackBar(content: Text('Added comic to favourites!',textAlign: TextAlign.center,));

                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          },
                          icon: const Icon(
                            Icons.whatshot,
                            size: _arrorSize,
                          )),

                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
