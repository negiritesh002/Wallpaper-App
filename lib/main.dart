import 'package:flutter/material.dart';
import 'package:wallpaper/wallpaper.dart';

void main(){
  runApp(
    MaterialApp(

      theme: ThemeData(brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
        home: wallpaper())
  );
}

class wallpaper extends StatelessWidget {
  const wallpaper({super.key});

  @override
  Widget build(BuildContext context) {
    return wallpapermaking();
  }
}
