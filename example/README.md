# youtube_player_embed

[![Pub Version](https://img.shields.io/pub/v/youtube_player_embed)](https://pub.dev/packages/youtube_player_embed)
[![License](https://img.shields.io/github/license/mohamedegy107/youtube_player_embed)](LICENSE)
[![GitHub Stars](https://img.shields.io/github/stars/mohamedegy107/youtube_player_embed?style=social)](https://github.com/mohamedegy107/youtube_player_embed)

`youtube_player_embed` is a lightweight and customizable Flutter package that allows developers to embed YouTube videos, including YouTube Shorts, directly into their Flutter applications using an InAppWebView. With this package, you can seamlessly integrate videos with advanced event handling, autoplay, mute, and aspect ratio customization.

---

## Features

- 🎥 **Embed YouTube Videos and Shorts** easily with minimal configuration.
- 🔄 **Autoplay Support** for instant video playback.
- 🔇 **Mute Option** for silent playback.
- 📱 **Responsive Design** supporting both horizontal (16:9) and vertical (9:16) videos.
- 💡 **Customizable** options to remove YouTube branding buttons for a cleaner UI.
- 🔗 **Direct Shorts Integration** for embedding vertical YouTube Shorts seamlessly.
- ⏰ **Advanced Event Listeners** for video state updates, time tracking, seek events, and mute/unmute detection.
- 🔑 **Enhanced Control** to programmatically remove share and branding buttons dynamically.
- ⏯ **Full-Screen Support** with seamless entry and exit.
- ⏹️ **Playback Controls**: Play, Pause, Seek, Mute, and Unmute programmatically.
- 🔍 **Custom Video Titles**: Dynamically set or hide video titles.
- 🚀 **Performance Optimized**: Lightweight and efficient for a smoother user experience.

---

![image](https://github.com/user-attachments/assets/c62ef628-33bd-4bfd-8e3e-aac36e74d991)

---

## Installation

Add the following dependency to your `pubspec.yaml`:

```yaml
dependencies:
  youtube_player_embed: ^1.6.0
```

Run the following command to install the package:

```bash
flutter pub get
```

---

## Usage

Import the package:

```dart
import 'package:youtube_player_embed/youtube_player_embed.dart';
```

Embed a YouTube video in your app:

```dart
import 'package:flutter/material.dart';
import 'package:youtube_player_embed/youtube_player_embed.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    VideoController? videoController;

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
              key: ValueKey(currentPlayingVideo), // Unique key for the video (optional)
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
                print("video ended");
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
                  case VideoState.fullscreen:
                    print("Video is in fullscreen");
                    break;
                  case VideoState.normalView:
                    print("Video is in normal view");
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
```

---

## Example Project

A complete example project is available in the [example](example/) directory.

To run the example:

```bash
cd example
flutter run
```

---

## API Reference

### `YoutubePlayerView`

| **Property**           | **Type**                     | **Default** | **Description**                                             |
|------------------------|------------------------------|-------------|-------------------------------------------------------------|
| `videoId`              | `String`                    | Required    | The YouTube video ID to embed.                              |
| `aspectRatio`          | `double`                    | null        | Aspect ratio of the video.                                  |
| `enabledShareButton`   | `bool`                      | `false`     | Enable or disable the share button.                        |
| `autoPlay`             | `bool`                      | `true`      | Whether the video should autoplay upon loading.             |
| `mute`                 | `bool`                      | `false`     | Whether the video should be muted by default.               |
| `onVideoEnd`           | `VoidCallback?`             | null        | Callback triggered when the video ends.                    |
| `onVideoSeek`          | `Function(double)?`         | null        | Callback triggered when the video seek occurs.              |
| `onVideoTimeUpdate`    | `Function(double)?`         | null        | Callback triggered on video time updates.                  |
| `onVideoStateChange`   | `Function(VideoState)?`     | null        | Callback triggered on video state changes (play/pause/etc). |
| `customVideoTitle`     | `String?`                   | null        | Custom title for the video displayed on top.               |
| `hidenVideoControls`   | `bool`                      | `false`     | Whether to hide the video controls.                        |
| `hidenChannelImage`    | `bool`                      | `true`      | Whether to hide the channel image.                         |

---

## Supported Platforms

- ✅ **Android**
- ✅ **iOS**
- ✅ **Web** *(with limitations)*
- ✅ **Desktop**

---

## Setup

### Android Setup

Ensure you have added the following permissions in your `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

### iOS Setup

To ensure proper functionality on iOS, follow these steps:

1. **Update the `Info.plist`**  
   Add the following permissions in your `Info.plist` file:

   ```xml
    <key>NSAppTransportSecurity</key>
    <dict>
      <key>NSAllowsArbitraryLoads</key>
      <true/>
    </dict>
    <key>io.flutter.embedded_views_preview</key>
    <true/>
   ```


If you still have this problem, try to edit iOS Podfile like this

2. **Edit the Podfile**  
   Add the following to your iOS `Podfile` if you encounter issues:

   ```ruby
   target 'Runner' do
     use_frameworks!  # required by flutter_inappwebview
     ...
   end

   post_install do |installer|
     installer.pods_project.targets.each do |target|
       target.build_configurations.each do |config|
         config.build_settings['SWIFT_VERSION'] = '5.0'  # required by flutter_inappwebview
         config.build_settings['ENABLE_BITCODE'] = 'NO'
       end
     end
   end
   ```

---

## Changelog

### v1.6.0
- Added programmatic playback controls: Play, Pause, Seek, Mute, Unmute.
- Added support for custom video titles.
- Enhanced dynamic hiding of video controls and channel images.
- Improved error handling for invalid video IDs.
- Added advanced event listeners for video state, time updates, and seek events.
- Added mute/unmute detection.
- Improved support for dynamic UI updates to remove share and branding buttons.
- Enhanced full-screen entry and exit handling.

---

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests on the [GitHub repository](https://github.com/mohamedegy107/youtube_player_embed).

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## Author

Developed by [Mohamed Elsafty](https://www.linkedin.com/in/mohamed-safwat-elsafty/).  
Feel free to reach out for support or feedback!

---

## Feedback & Support

If you encounter any issues or have suggestions for improvement, please open an issue on [GitHub](https://github.com/mohamedegy107/youtube_player_embed/issues) or contact me at `nesr107@gmail.com`.
