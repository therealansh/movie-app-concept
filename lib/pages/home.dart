import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_app_concept/api_key.dart';
import 'package:movie_app_concept/widgets/movieCard.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;

import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _pageController;
  int currPage = 1;

  Future moviesList;
  Future fetchMovies() async {
    Random rnd = Random();
    final res = await http.get(
        "https://api.themoviedb.org/3/movie/top_rated?api_key=${API_KEY}&language=en-US&page=${rnd.nextInt(100)}");
    if (res.statusCode == 200) {
      var results = json.decode(res.body);
      var data = results["results"] as List;
      print(data);
      return data;
    }
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    moviesList = fetchMovies();
    _pageController =
        PageController(initialPage: currPage, viewportFraction: 0.7);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 18),
          child: AspectRatio(
            aspectRatio: 0.85,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (value) {
                setState(() {
                  currPage = value;
                });
              },
              physics: ClampingScrollPhysics(),
              itemCount: 10,
              itemBuilder: (context, index) {
                return movieSlider(index);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget movieSlider(int index) {
    return FutureBuilder(
        future: moviesList,
        builder: (context, snap) {
          if(!snap.hasData){
            return Shimmer.fromColors(
                    highlightColor: Color(0xffffffff),
                    baseColor: Colors.blueGrey[100],
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.grey[100]
                      ),
                    ),
                  );
          }
          return AnimatedBuilder(
              animation: _pageController,
              builder: (context, chlid) {
                double val = 0;
                if (_pageController.position.haveDimensions) {
                  val = index - _pageController.page;
                  val = (val * 0.038).clamp(-1, 1);
                }
                return AnimatedOpacity(
                  opacity: currPage == index ? 1 : 0.4,
                  duration: Duration(milliseconds: 300),
                  child: Transform.rotate(
                    angle: math.pi * val,
                    child: MovieCard(data: snap.data[index]),
                  ),
                );
              });
        });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }
}
