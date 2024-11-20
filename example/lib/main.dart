import 'package:flutter/material.dart';
import 'package:youtube_player_embed/youtube_player_embed.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: YoutubePlayerView(
            videoId: 'pUb9EW770d0',
            autoPlay: true,
            mute: false,
          ),
        ),
      ),
    );
  }
}
