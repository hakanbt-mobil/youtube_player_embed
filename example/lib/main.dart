import 'package:flutter/material.dart';
import 'package:youtube_player_embed/youtube_player_embed.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: YoutubePlayerView(
            videoId: 'pUb9EW770d0',
            autoPlay: false,
            mute: false,
            enabledShareButton: false,
            aspectRatio: 16 / 9,
          ),
        ),
      ),
    );
  }
}
