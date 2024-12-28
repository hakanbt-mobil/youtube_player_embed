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
  youtube_player_embed: ^1.2.0
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
    return MaterialApp(
      title: 'YouTube Player Embed Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('YouTube Player Example'),
        ),
        body: Center(
          child: YoutubePlayerView(
            videoId: 'shorts_video_id', // Replace with a YouTube Shorts or normal video ID
            autoPlay: true,
            mute: false,
            enabledShareButton: false,
            aspectRatio: 16 / 9,
            onVideoEnd: () {
              print("Video has ended");
            },
            onVideoSeek: (currentTime) => print("Seeked to $currentTime seconds"),
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
            onVideoTimeUpdate: (currentTime) => print("Current time: $currentTime seconds"),
          ),
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

## Troubleshooting

- Ensure you have added the `flutter_inappwebview` dependencies correctly.
- For iOS, add the following to your `Info.plist`:

```xml
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <true/>
</dict>
```

---

## Changelog

### v1.2.0
- Added programmatic playback controls: Play, Pause, Seek, Mute, Unmute.
- Added support for custom video titles.
- Enhanced dynamic hiding of video controls and channel images.
- Improved error handling for invalid video IDs.

### v1.1.0
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