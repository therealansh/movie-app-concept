import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_app_concept/pages/infoPage.dart';
import 'package:shimmer/shimmer.dart';

class MovieCard extends StatelessWidget {
  final Map<String,dynamic> data;
  MovieCard({this.data});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18),
      child: OpenContainer(
        closedElevation: 0,
        openElevation: 0,
        closedBuilder: (context, action) => builderMovieCard(context),
        openBuilder: (context, action) => InfoPage(data: data),
      ),
    );
  }

  Widget builderMovieCard(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CachedNetworkImage(
            imageUrl: 'https://image.tmdb.org/t/p/original/${data["poster_path"]}',
            imageBuilder: (context,provider) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              boxShadow:[BoxShadow(offset: Offset(0,4),blurRadius: 4,color: Color(0xFFc4c4c4))],
              image:DecorationImage(
                fit: BoxFit.fill,
                image: provider
              )
            ),
          ),
            placeholder: (context, url) => Shimmer.fromColors(
                    highlightColor: Color(0xffffffff),
                    baseColor: Colors.blueGrey[100],
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.grey[100]
                      ),
                    ),
                  ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 9),
          child: Text(
            data["title"],
            style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.star,
              size: 20,
              color: Color(0xFFfcc419),
            ),
            SizedBox(
              width: 9,
            ),
            Text("${data["vote_count"].toString()} voted")
          ],
        )
      ],
    );
  }
}
