import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'enum/video_state.dart';

class YoutubePlayerView extends StatefulWidget {
  final String videoId;
  final bool autoPlay;

  /// WORKING ONLY WITH VIDEOS NOT SHORTS
  final bool enabledShareButton;
  final bool mute;
  final double? aspectRatio;
  final VoidCallback? onVideoEnd;
  final Function(double currentTime)? onVideoSeek;
  final Function(double currentTime)? onVideoTimeUpdate;
  final Function(VideoState state)? onVideoStateChange;
  const YoutubePlayerView({
    Key? key,
    required this.videoId,
    this.autoPlay = true,
    this.mute = false,
    this.aspectRatio,
    this.enabledShareButton = false,
    this.onVideoEnd,
    this.onVideoSeek,
    this.onVideoTimeUpdate,
    this.onVideoStateChange,
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
          onWebViewCreated: (controller) {
            // JavaScript handlers for different events
            controller.addJavaScriptHandler(
              handlerName: 'onVideoEnd',
              callback: (args) {
                widget.onVideoEnd?.call();
                print('<<< Video ended >>>');
                return null;
              },
            );
            controller.addJavaScriptHandler(
              handlerName: 'onVideoSeek',
              callback: (args) {
                final currentTime = args.first as double;
                widget.onVideoSeek?.call(currentTime);
                print('<<< Video seeked to: $currentTime seconds >>>');
                return null;
              },
            );
            controller.addJavaScriptHandler(
              handlerName: 'onVideoTimeUpdate',
              callback: (args) {
                final currentTime = args.first as double;
                widget.onVideoTimeUpdate?.call(currentTime);
                print('<<< Current video time: $currentTime seconds >>>');
                return null;
              },
            );

            controller.addJavaScriptHandler(
              handlerName: 'onVideoStateChange',
              callback: (args) {
                final String state = args.first;
                VideoState? videoState;

                switch (state) {
                  case 'playing':
                    videoState = VideoState.playing;
                    break;
                  case 'paused':
                    videoState = VideoState.paused;
                    break;
                  case 'muted':
                    videoState = VideoState.muted;
                    break;
                  case 'unmuted':
                    videoState = VideoState.unmuted;
                    break;
                }

                if (videoState != null) {
                  widget.onVideoStateChange?.call(videoState);
                  print('<<< Video state changed: $state >>>');
                }

                return null;
              },
            );
          },
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
            // Inject JavaScript to listen for video events
            await controller.evaluateJavascript(
              source: """
    // Ensure the video element is loaded
    const checkVideoElement = () => {
      const video = document.querySelector('video');
      if (video) {
        console.log('Video element found.');

        // Add event listeners for video state changes
        video.addEventListener('play', () => {
          console.log('Video is playing.');
          window.flutter_inappwebview.callHandler('onVideoStateChange', 'playing');
        });

        video.addEventListener('pause', () => {
          console.log('Video is paused.');
          if(!video.ended){
            window.flutter_inappwebview.callHandler('onVideoStateChange', 'paused');
          }
        });

        video.addEventListener('ended', () => {
          console.log('Video ended.');
          window.flutter_inappwebview.callHandler('onVideoEnd');
        });

        video.addEventListener('seeking', () => {
          console.log('Video seeking to: ', video.currentTime);
          window.flutter_inappwebview.callHandler('onVideoSeek', video.currentTime);
        });

        video.addEventListener('timeupdate', () => {
          console.log('Current video time: ', video.currentTime);
          window.flutter_inappwebview.callHandler('onVideoTimeUpdate', video.currentTime);
        });

// Detect mute and unmute events using the 'muted' property
        let wasMuted = video.muted;
        setInterval(() => {
          if (video.muted && !wasMuted) {
            console.log('Video muted.');
            window.flutter_inappwebview.callHandler('onVideoStateChange', 'muted');
          } else if (!video.muted && wasMuted) {
            console.log('Video unmuted.');
            window.flutter_inappwebview.callHandler('onVideoStateChange', 'unmuted');
          }
          wasMuted = video.muted;
        }, 500);
      } else {
        console.log('Video element not found. Retrying...');
        setTimeout(checkVideoElement, 500); // Retry until video is available
      }
    };
    // Start checking for the video element
    checkVideoElement();
    """,
            );

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
