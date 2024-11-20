

# youtube_player_embed

[![Pub Version](https://img.shields.io/pub/v/youtube_player_embed)](https://pub.dev/packages/youtube_player_embed)
[![License](https://img.shields.io/github/license/mohamedegy107/youtube_player_embed)](LICENSE)
[![GitHub Stars](https://img.shields.io/github/stars/mohamedegy107/youtube_player_embed?style=social)](https://github.com/mohamedegy107/youtube_player_embed)

youtube_player_embed is a lightweight and customizable Flutter package that allows developers to embed YouTube videos, including YouTube Shorts, directly into their Flutter applications using an InAppWebView. With this package, you can seamlessly integrate videos with options like autoplay, mute, and aspect ratio customization.

---

## Features

- 🎥 **Embed YouTube Videos and Shorts** easily with minimal configuration.
- 🔄 **Autoplay Support** for instant video playback.
- 🔇 **Mute Option** for silent playback.
- 📱 **Responsive Design** supporting both horizontal (16:9) and vertical (9:16) videos.
- 💡 **Customizable** options to remove YouTube branding buttons for a cleaner UI.
- 🔗 **Direct Shorts Integration** for embedding vertical YouTube Shorts seamlessly.

---

![WhatsApp Image 2024-10-22 at 13 20 46_00003ce6](https://github.com/user-attachments/assets/585796ee-52be-4233-bf17-1da517051d15)


## Installation

Add the following dependency to your `pubspec.yaml`:

```yaml
dependencies:
  youtube_player_embed: ^0.0.1
```

Run the following command to install the package:

```bash
flutter pub get
```

- 🎥 **Embed YouTube Videos and Shorts** easily with minimal configuration.
- 🔄 **Autoplay Support** for instant video playback.
- 🔇 **Mute Option** for silent playback.
- 📱 **Responsive Design** supporting both horizontal (16:9) and vertical (9:16) videos.
- 💡 **Customizable** options to remove YouTube branding buttons for a cleaner UI.
- 🔗 **Direct Shorts Integration** for embedding vertical YouTube Shorts seamlessly.

---

## Installation

Add the following dependency to your `pubspec.yaml`:

```yaml
dependencies:
  youtube_player_embed: ^0.0.1
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
            videoId: videoId: 'shorts_video_id', // Replace with a YouTube Shorts or normal video ID
            autoPlay: true,
            mute: false,
            enabledShareButton: false,
            isShort: false,
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

| **Property**   | **Type**  | **Default** | **Description**                                             |
|----------------|-----------|-------------|-------------------------------------------------------------|
| `videoId`      | `String`  | Required    | The YouTube video ID to embed.                              |
| `aspectRatio`      | `double`  | null    | Aspect ratio of video.                                      |
| `enabledShareButton`      | `bool`  | `false`    | enabled or disabled share button                    |
| `autoPlay`     | `bool`    | `true`      | Whether the video should autoplay upon loading.             |
| `mute`         | `bool`    | `false`     | Whether the video should be muted by default.               |

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
