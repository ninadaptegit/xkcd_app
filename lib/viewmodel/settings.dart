
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';

import '../classes/Comic.dart';


enum Mode{
  light,
  dark
}
class settingsViewModel extends ChangeNotifier{

      Mode _mode = Mode.light;

      Mode get mode=>_mode;


      settingsViewModel(){
        loadMode();

      }

      void loadMode() async{
        final box = await Hive.openBox('settings');
        _mode = box.get('mode',defaultValue: Mode.light);

      }



      void toggleMode() {
        if(_mode == Mode.light){
          _mode = Mode.dark;
        }
        else{
          _mode = Mode.light;
        }

        Hive.box('settings').put('mode', _mode);
        notifyListeners();
      }

}