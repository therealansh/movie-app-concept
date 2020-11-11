import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_app_concept/widgets/cupertinosnackbar.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Player extends StatefulWidget {
  String uid;
  Player({this.uid});
  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  YoutubePlayerController _controller;
  PlayerState _playerState;
  Size _size;
  bool _isPlayerReady = false;

  void listener(){
    if(_isPlayerReady && mounted && _controller.value.isFullScreen){
      setState(() {
        _playerState = _controller.value.playerState;
      });    
    }
  }

  @override
  void initState() {
    
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
    _controller = YoutubePlayerController(initialVideoId: widget.uid,flags: YoutubePlayerFlags(autoPlay: true,mute: false,disableDragSeek: true,loop: false,isLive: false,forceHD: false,enableCaption: false))
        ..addListener(listener);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Stack(
          children: [SafeArea(
        child: YoutubePlayer(
          controller: _controller,
          onEnded: (data){
            Navigator.pop(context);
          },
        ),
      ),
      Positioned(child: Material(color: Colors.transparent,child: BackButton(color: Colors.white,onPressed: (){Navigator.pop(context);},)),top: 0,left: 0,)
      ],
    );
  }

    @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _controller.dispose();
  }
}