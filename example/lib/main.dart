import 'package:flutter/material.dart';
import 'package:youtube_player_embed/youtube_player_embed.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouTube Player Embed Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('YouTube Player Example'),
        ),
        body: const Center(
          child: YoutubePlayerView(
            videoId:
                "pUb9EW770d0", // 'shorts_video_id' Replace with a YouTube Shorts or normal video ID
            autoPlay: true,
            mute: false,
            enabledShareButton: false,
            aspectRatio: 16 / 9,
          ),
        ),
      ),
    );
  }
}
