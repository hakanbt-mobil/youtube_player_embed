import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class YoutubePlayerView extends StatefulWidget {
  final String videoId;
  final bool autoPlay;

  /// WORKING ONLY WITH VIDEOS NOT SHORTS
  final bool enabledShareButton;
  final bool mute;
  final double? aspectRatio;

  const YoutubePlayerView({
    Key? key,
    required this.videoId,
    this.autoPlay = true,
    this.mute = false,
    this.aspectRatio,
    this.enabledShareButton = false,
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
        aspectRatio: widget.aspectRatio ?? 16 / 9,
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
            ////
            if (!widget.enabledShareButton) {
              // Remove overflow button (three dots menu)
              await controller.evaluateJavascript(
                source: """
              var element = document.querySelector('.ytp-overflow-button');
              if (element) {
                element.remove();
              }
              """,
              );

              // Remove YouTube button
              await controller.evaluateJavascript(
                source: """
              var element = document.querySelector('.ytp-youtube-button');
              if (element) {
                element.remove();
              }
              """,
              );

              // Remove Share button
              await controller.evaluateJavascript(
                source: """
              var shareButton = document.querySelector('.ytp-share-button');
              if (shareButton) {
                shareButton.remove();
              }
              """,
              );

              // Remove More Options from settings menu
              await controller.evaluateJavascript(
                source: """
              function removeUnwantedElements() {
                // Remove More Options from settings menu
                const settingsMenu = document.querySelector('.ytp-settings-menu');
                if (settingsMenu) {
                  const menuItems = settingsMenu.querySelectorAll('.ytp-menuitem');
                  menuItems.forEach(item => {
                    if (item.textContent.includes('More options')) {
                      item.remove();
                    }
                  });
                }
                
                // Ensure Share button stays removed
                const shareButton = document.querySelector('.ytp-share-button');
                if (shareButton) {
                  shareButton.remove();
                }
              }
              
              // Initial removal
              removeUnwantedElements();
              
              // Observer for dynamic content
              const observer = new MutationObserver(() => {
                removeUnwantedElements();
              });
              
              // Start observing the document for added nodes
              observer.observe(document.body, {
                childList: true,
                subtree: true
              });
            """,
              );
              ////
              setState(
                () {
                  preventTap = false;
                },
              );
              ////
            }
          },
        ),
      ),
    );
  }
}
