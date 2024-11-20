import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class YoutubePlayerView extends StatefulWidget {
  final String videoId;
  final bool autoPlay;
  final bool mute;

  const YoutubePlayerView({
    Key? key,
    required this.videoId,
    this.autoPlay = true,
    this.mute = false,
  }) : super(key: key);

  @override
  State<YoutubePlayerView> createState() => _YoutubePlayerViewState();
}

class _YoutubePlayerViewState extends State<YoutubePlayerView> {
  bool preventTap = true;

  String url = '';

  @override
  void initState() {
    url = '''
    https://www.youtube.com/embed/${widget.videoId}
    ?autoplay=${widget.autoPlay ? '1' : '0'}
    &mute=${widget.mute ? '1' : '0'}
    &controls=1
    &rel=0
    '''
        .replaceAll('\n', '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: preventTap,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: InAppWebView(
          initialUrlRequest: URLRequest(
            url: WebUri(url.replaceAll(" ", "")),
          ),
          initialSettings: InAppWebViewSettings(
            useShouldOverrideUrlLoading: true,
            mediaPlaybackRequiresUserGesture: false,
            javaScriptEnabled: true,
            allowsInlineMediaPlayback: true,
            iframeAllowFullscreen: true,
            allowsBackForwardNavigationGestures: false,
            supportZoom: false,
          ),
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            return NavigationActionPolicy.CANCEL;
          },
          onWebViewCreated: (controller) {},
          onContentSizeChanged: (controller, width, height) async {
            // controller.evaluateJavascript(source: javaScript);
          },
          onEnterFullscreen: (controller) {
            // controller.evaluateJavascript(source: javaScript);
          },
          onExitFullscreen: (controller) {
            // controller.evaluateJavascript(source: javaScript);
          },
          onLoadStop: (controller, uri) async {
            //// Inject custom CSS using JavaScript
            await controller.evaluateJavascript(
              source: """
              var element = document.querySelector('.ytp-overflow-button');
              if (element) {
                element.remove();
              }
            """,
            );
            //// Remove the specified element using JavaScript
            await controller.evaluateJavascript(
              source: """
              var element = document.querySelector('.ytp-youtube-button');
              if (element) {
                element.remove();
              }
            """,
            );
            ////
            setState(() {
              preventTap = false;
            });
            ////
          },
        ),
      ),
    );
  }
}
