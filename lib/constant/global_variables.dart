import 'package:shared_preferences/shared_preferences.dart';

bool isLogged=prefs.getBool("ISLOGGED")?? false;
late SharedPreferences prefs;

const googleAPIKey = 'AIzaSyCInykBk3uVjiloXgCpgwJb9BWmHTtdyfY';