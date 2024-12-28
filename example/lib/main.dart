import 'package:flutter/material.dart';
import 'package:youtube_player_embed/controller/video_controller.dart';
import 'package:youtube_player_embed/enum/video_state.dart';
import 'package:youtube_player_embed/youtube_player_embed.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ////
  final List<String> listOfVideos = ["pUb9EW770d0", "3vPbzEhF63s"];
  ////
  String currentPlayingVideo = "";
  ////
  VideoController? videoController;
  ////

  @override
  void initState() {
    super.initState();
    ////
    currentPlayingVideo = listOfVideos.removeAt(0);
    ////
  }
  ////

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouTube Player Embed Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('YouTube Player Example'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ////
            YoutubePlayerEmbed(
              key: ValueKey(currentPlayingVideo), // Unique key for the video
              callBackVideoController: (controller) {
                videoController = controller;
              },
              videoId:
                  currentPlayingVideo, // 'shorts_video_id' Replace with a YouTube Shorts or normal video ID
              customVideoTitle: "بسم الله الرحمن الرحيم",
              autoPlay: false,
              hidenVideoControls: false,
              mute: false,
              enabledShareButton: false,
              hidenChannelImage: true,
              aspectRatio: 16 / 9,
              onVideoEnd: () {
                if (listOfVideos.isNotEmpty) {
                  setState(() {
                    currentPlayingVideo = listOfVideos.removeAt(0);
                  });
                } else {
                  // Handle when the list is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No more videos to play!')),
                  );
                }
              },
              onVideoSeek: (currentTime) =>
                  print("Seeked to $currentTime seconds"),
              onVideoTimeUpdate: (currentTime) =>
                  print("Current time: $currentTime seconds"),
              onVideoStateChange: (state) {
                switch (state) {
                  case VideoState.playing:
                    print("Video is playing");
                    break;
                  case VideoState.paused:
                    print("Video is paused");
                    break;
                  case VideoState.muted:
                    print("Video is muted");
                    break;
                  case VideoState.unmuted:
                    print("Video is unmuted");
                    break;
                }
              },
            ),
            ////
            const SizedBox(height: 100),
            ////
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ////
                ElevatedButton(
                  onPressed: () async {
                    await videoController?.playVideo();
                  },
                  child: const Text("Play"),
                ),
                ////
                ElevatedButton(
                  onPressed: () async {
                    await videoController?.pauseVideo();
                  },
                  child: const Text("pause"),
                ),
                ////
                ElevatedButton(
                  onPressed: () async {
                    await videoController?.muteOrUnmuteVideo();
                  },
                  child: const Text("mute / unmute"),
                ),
                ////
              ],
            ),
            ////
            const SizedBox(height: 50),
            ////
            ElevatedButton(
              onPressed: () async {
                await videoController?.seekTo(
                  time: 4,
                );
              },
              child: const Text("seek to 4 seconed (for test)"),
            ),
            ////
          ],
        ),
      ),
    );
  }
}
