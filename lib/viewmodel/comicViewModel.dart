import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../classes/Comic.dart';

class comicViewModel extends ChangeNotifier{

  List<Comic> _comics = <Comic>[];
  List<Comic> get comics=>_comics;

  comicViewModel(){
    getAllComics();
  }

  Future<void> getAllComics() async{

    final box = Hive.box<Comic>('comics');
    _comics =  box.values.toList();
    notifyListeners();
  }
  Future<void> addComic(Comic comic) async {
    final box = Hive.box<Comic>('comics');
    await box.put(comic.image_url,comic); // auto-increments key

  }
  Future<void> deleteComic(Comic comic) async {
    final box = Hive.box<Comic>('comics');
    await box.delete(comic.image_url);


  }


}