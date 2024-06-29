import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper/fullscreen.dart';

class wallpapermaking extends StatefulWidget {
  const wallpapermaking({super.key});

  @override
  State<wallpapermaking> createState() => _wallpapermakingState();
}

class _wallpapermakingState extends State<wallpapermaking> {
  bool isloading = false;

  var images = [];
  int page = 1;

  fetchapi() async {
    await http.get(Uri.parse("https://api.pexels.com/v1/curated?per_page = 80"),
        headers: {
          'Authorization':
              '563492ad6f91700001000001fead046b5c28412cb20719b61dd8fbbf'
        }).then((value) {
      var result = jsonDecode(value.body);
      setState(() {
        images = result['photos'];
      });
      print("images===========>$images");
      print(images.length);
    });
  }

  @override
  void initState() {
    fetchapi();
    super.initState();
  }

  loadmore() async {
    setState(() {
      page++;
    });
    String url = 'https://api.pexels.com/v1/curated?per_page = 80&page=' +
        page.toString();
    await http.get(Uri.parse(url), headers: {
      'Authorization':
          '563492ad6f91700001000001fead046b5c28412cb20719b61dd8fbbf'
    }).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        images.addAll(result['photos']);
        isloading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: Container(
            child: GridView.builder(
              itemCount: images.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 2,
                  childAspectRatio: 2 / 3,
                  mainAxisSpacing: 2),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FullScreen(
                                  imageUrl: images[index]['src']['large2x'],
                                )));
                  },
                  child: Container(
                      color: Colors.white,
                      child: Image.network(images[index]['src']['tiny'],
                          fit: BoxFit.cover)),
                );
              },
            ),
          )),
          InkWell(
            child: Container(
                height: 60,
                width: double.infinity,
                color: Colors.black,
                child: TextButton(
                    onPressed: () async{
                      setState(() {
                        isloading = true;
                      });
                      await Future.delayed(Duration(seconds: 2));
                      loadmore();
                    },
                    child: isloading
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 30,width: 30,child: CircularProgressIndicator()),
                        SizedBox(width: 15),
                        Text("Loading More...")
                      ],
                    )
                        : Text(
                            "LOAD MORE",
                            style: TextStyle(
                                letterSpacing: 6, fontWeight: FontWeight.bold),
                          ))),
          )
        ],
      ),
    );
  }
}
