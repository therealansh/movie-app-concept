import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app_concept/pages/player.dart';
import 'package:movie_app_concept/widgets/cupertinosnackbar.dart';
class InfoPage extends StatefulWidget {
  Map<String,dynamic> data;
  InfoPage({this.data});
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  bool isLiked = false;
  Size _size;
  String uid;

  setup()async{
    await http.get("https://api.themoviedb.org/3/movie/${widget.data["id"]}/videos?api_key=ce2089aa9a569a6d75911b7532c33104&language=en-US").then((value) {
      var result = jsonDecode(value.body)["results"];
      setState(() {
        uid = result[0]["key"];
      });
    });
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    setup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Container(
      height:_size.height*0.4 ,
      child: Stack(
        children: [
          Container(
            height: _size.height*0.4 - 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50),
              ),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage('https://image.tmdb.org/t/p/original/${widget.data["backdrop_path"]}')
              )
            )
          ),
          Positioned(
           top: _size.height*0.4-80,
           right: 0,
            child: Container(
              width: _size.width * 0.9,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  topLeft: Radius.circular(50),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 5),
                    blurRadius: 50,
                    color: Color(0xFF12153D).withOpacity(0.2),
                  ),
                ],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.star,color: Color(0xFFfcc419),),
                        SizedBox(height: 5),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: "${widget.data["vote_count"]}",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(icon: isLiked ? Icon(Icons.star,color: Color(0xFFfcc419),):Icon(Icons.star_border,color: Color(0xFFfcc419),), onPressed: (){
                          setState((){isLiked = !isLiked;});
                        }),
                        SizedBox(height: 5),
                        Text("Rate This",
                            style: Theme.of(context).textTheme.bodyText2),
                      ],
                    ),
                    SizedBox(
              width: 64,
              height: 64,
              child: FlatButton(
                onPressed: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (_)=>Player(uid:uid==null?"1DpH-icPpl0":uid)));
                },
                color:Color(0xFFFE6D8E),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Icon(
                  Icons.play_arrow,
                  size: 28,
                  color: Colors.white,
                ),),
            ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: _size.height*0.4+30,
            right: 20,
            left: 20,
            child: Container(
              height: _size.height*0.5,
              padding: EdgeInsets.all(20),
              child: Text(widget.data["overview"],style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15
              ),textAlign: TextAlign.justify,),
            ),
          ),
          SafeArea(child: BackButton(color: Colors.white,)),
        ],
      ),
    );
  }
  
}
