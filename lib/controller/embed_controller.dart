import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:youtube_player_embed/enum/video_state.dart';

class EmbedController {
  final InAppWebViewController controller;
  const EmbedController(this.controller);

  Future<void> changeVideoTitle({
    String? customVideoTitle,
  }) async {
    await controller.evaluateJavascript(
      source: """
                document.querySelector('a.ytp-title-link').innerText = '${customVideoTitle}';;
              """,
    );
  }

  Future<void> removeMoreOptionsButton() async {
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
  }

  Future<void> removeShareButton() async {
    await controller.evaluateJavascript(
      source: """
              var shareButton = document.querySelector('.ytp-share-button');
              if (shareButton) {
                shareButton.remove();
              }
              """,
    );
  }

  Future<void> removeYoutubeButton() async {
    await controller.evaluateJavascript(
      source: """
              var element = document.querySelector('.ytp-youtube-button');
              if (element) {
                element.remove();
              }
              """,
    );
  }

  Future<void> removeThreeDotsMenu() async {
    await controller.evaluateJavascript(
      source: """
              var element = document.querySelector('.ytp-overflow-button');
              if (element) {
                element.remove();
              }
              """,
    );
  }

  Future<void> createVideoListeners() async {
    await controller.evaluateJavascript(
      source: """
                // Ensure the video element is loaded
                const checkVideoElement = () => {
                  const video = document.querySelector('video');
                  if (video) {
                    console.log('Video element found.');

                    // video.addEventListener('click',() => {});

                    // Add event listeners for video state changes
                    video.addEventListener('play', () => {
                      console.log('Video is playing.');
                      window.flutter_inappwebview.callHandler('onVideoStateChange', 'playing');
                    });

                    //// Add event listeners for video pause
                    video.addEventListener('pause', () => {
                      console.log('Video is paused.');
                      if(!video.ended){
                        window.flutter_inappwebview.callHandler('onVideoStateChange', 'paused');
                      }
                    });

                    //// Add event listeners for video end
                    video.addEventListener('ended', () => {
                      console.log('Video ended.');
                      window.flutter_inappwebview.callHandler('onVideoEnd');
                    });

                    //// add event listeners for video seek
                    video.addEventListener('seeking', () => {
                      console.log('Video seeking to: ', video.currentTime);
                      window.flutter_inappwebview.callHandler('onVideoSeek', video.currentTime);
                    });

                    //// add event listeners for video time update
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
  }

  void callBackWhenVideoStateChange({
    required Function(VideoState state)? onVideoStateChange,
  }) {
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
          onVideoStateChange?.call(videoState);
          print('<<< Video state changed: $state >>>');
        }

        return null;
      },
    );
  }

  void callBackWhenVideoTimeUpdate({
    required Function(double currentTime)? onVideoTimeUpdate,
  }) {
    controller.addJavaScriptHandler(
      handlerName: 'onVideoTimeUpdate',
      callback: (args) {
        final currentTime = args.first as double;
        onVideoTimeUpdate?.call(currentTime);
        print('<<< Current video time: $currentTime seconds >>>');
        return null;
      },
    );
  }

  void callBackWhenVideoSeek({
    required Function(double currentTime)? onVideoSeek,
  }) {
    controller.addJavaScriptHandler(
      handlerName: 'onVideoSeek',
      callback: (args) {
        final currentTime = args.first as double;
        onVideoSeek?.call(currentTime);
        print('<<< Video seeked to: $currentTime seconds >>>');
        return null;
      },
    );
  }

  void callBackWhenVideoEnd({
    required Function()? onVideoEnd,
  }) {
    controller.addJavaScriptHandler(
      handlerName: 'onVideoEnd',
      callback: (args) {
        onVideoEnd?.call();
        print('<<< Video ended >>>');
        return null;
      },
    );
  }

  Future<void> removeYoutubeWatermark() async {
    await controller.evaluateJavascript(
      source: """
                document.querySelector('.ytp-watermark').style.display = 'none';  
                """,
    );
  }

  Future<void> removeChannleImage({
    required bool hidenChannelImage,
  }) async {
    if (hidenChannelImage) {
      await controller.evaluateJavascript(
        source: """
                document.querySelector('.ytp-title-channel').remove();  
                """,
      );
    }
  }

  Future<void> hidenVideoTitle({
    bool hiden = true,
  }) async {
    await controller.evaluateJavascript(
      source: _getHidenTitleJavaScript(hiden: hiden),
    );
  }

  String _getHidenTitleJavaScript({bool hiden = true}) {
    if (hiden) {
      return """
             document.querySelector('.ytp-title').style.display = 'none';
            """;
    } else {
      return """
             document.querySelector('.ytp-title').style.display = '';
            """;
    }
  }
}
