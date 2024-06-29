import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FullScreen extends StatefulWidget {
  final String imageUrl;

  const FullScreen({super.key, required this.imageUrl});

  @override
  State<FullScreen> createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  bool loading = false;

  Future<void> setwallpaper() async {
    var location = WallpaperManager.HOME_SCREEN;

    var file = await DefaultCacheManager().getSingleFile(widget.imageUrl);
    String result = await WallpaperManager.setWallpaperFromFile(
            file.path.toString(), location)
        .toString();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            Expanded(
                child: Container(
              child: Image.network(widget.imageUrl),
            )),
            InkWell(
              child: Container(
                  height: 60,
                  width: double.infinity,
                  color: Colors.black,
                  child: TextButton(
                      onPressed: () async {
                        setState(() {
                          loading = true;
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            showCloseIcon: true,
                              closeIconColor: Colors.white,
                              backgroundColor: Colors.purple.withOpacity(0.10),
                              content: Text("Changing Wallpaper",style: TextStyle(color: Colors.white),)));
                        });
                        await Future.delayed(Duration(seconds: 3));
                        setwallpaper();
                      },
                      child: loading
                          ? SizedBox(height: 30,width: 30,child: CircularProgressIndicator())
                          : Text(
                              "SET WALLPAPER",
                              style: TextStyle(
                                  letterSpacing: 6,
                                  fontWeight: FontWeight.bold),
                            ))),
            )
          ],
        ),
      ),
    );
  }
}
