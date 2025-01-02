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
                document.querySelector('a.ytp-title-link').innerText = '${customVideoTitle}';
                document.querySelector('.ytp-title-text').firstChild.text = '${customVideoTitle}';
              """,
    );
  }

  Future<void> removeMoreOptionsAndShareButtons() async {
    await controller.evaluateJavascript(source: """
              var style = document.createElement('style');
              style.textContent = `
                .ytp-overflow-button,
                .ytp-youtube-button,
                .ytp-share-button,
                .ytp-menuitem[role="menuitem"][data-layer="menu-popup"],
                .ytp-button[data-title-no-tooltip="Share"],
                .ytp-button[aria-label*="Share"],
                .ytp-menuitem[aria-label*="More options"],
                .ytp-menuitem[aria-label*="خيارات إضافية"],
                .ytp-button[aria-label*="مشاركة"],
                .ytp-chrome-top-buttons,
                .ytp-watch-later-button,
                .ytp-watermark,
              {
                display: none !important;
              }
              `;
              document.head.appendChild(style);

              function removeUnwantedElements() {
                // Remove elements by class and data attributes
                const elementsToRemove = [
                  '.ytp-overflow-button',
                  '.ytp-youtube-button',
                  '.ytp-share-button',
                  '.ytp-menuitem[role="menuitem"][data-layer="menu-popup"]',
                  '.ytp-chrome-top-buttons',
                  '.ytp-watch-later-button',
                  '.ytp-watermark',
                  '.ytp-button[aria-label*="المشاهدة على"]', 
                  '.ytp-impression-link img' 
                ];

                elementsToRemove.forEach(selector => {
                  const elements = document.querySelectorAll(selector);
                  elements.forEach(el => el.remove());
                });

                // Remove settings menu items
                const settingsMenu = document.querySelector('.ytp-settings-menu');
                if (settingsMenu) {
                  const menuItems = settingsMenu.querySelectorAll('.ytp-menuitem');
                  menuItems.forEach(item => {
                    const ariaLabel = item.getAttribute('aria-label') || '';
                    if (
                      ariaLabel.includes('More options') || 
                      ariaLabel.includes('خيارات إضافية') ||
                      ariaLabel.includes('Watch on') ||
                      ariaLabel.includes('شاهد على') ||
                      ariaLabel.includes('المشاهدة على') || 
                      item.textContent.includes('More options') ||
                      item.textContent.includes('خيارات إضافية') ||
                      item.textContent.includes('Watch on') ||
                      item.textContent.includes('شاهد على') ||
                      item.textContent.includes('المشاهدة على') 
                    ) {
                      item.remove();
                    }
                  });
                }
              }

              // Initial removal
              removeUnwantedElements();

              // Create an observer instance
              const observer = new MutationObserver((mutations) => {
                removeUnwantedElements();
              });

              // Start observing the document with the configured parameters
              observer.observe(document.body, {
                childList: true,
                subtree: true,
                characterData: true,
                attributes: true
              });
              """);
  }

  Future<void> onFullScreenStateChanged({
    required Function(VideoState state)? onVideoStateChange,
  }) async {
    // Inject JavaScript to listen for fullscreen changes
    await controller.evaluateJavascript(source: """
    document.addEventListener('fullscreenchange', function() {
      if (document.fullscreenElement) {
        window.flutter_inappwebview.callHandler('onEnterFullscreen');
      } else {
        window.flutter_inappwebview.callHandler('onExitFullscreen');
      }
    });
  """);

    // Register JavaScript handlers for fullscreen events
    controller.addJavaScriptHandler(
      handlerName: 'onEnterFullscreen',
      callback: (args) {
        // Notify Flutter when entering fullscreen
        print('Entered fullscreen');
        if (onVideoStateChange != null) {
          onVideoStateChange.call(VideoState.fullscreen);
        }
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'onExitFullscreen',
      callback: (args) {
        // Notify Flutter when exiting fullscreen
        print('Exited fullscreen');
        if (onVideoStateChange != null) {
          onVideoStateChange.call(VideoState.normalView);
        }
      },
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
                decument.querySelector('.ytp-impression-link ').style.display = 'none';
                """,
    );
  }

  Future<void> removeChannleImage({
    required bool hidenChannelImage,
  }) async {
    if (hidenChannelImage) {
      await controller.evaluateJavascript(
        source: """
                document.querySelector('.ytp-title-channel').style.display = 'none';   
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
             document.querySelector('.ytp-title-text').firstChild.text = '';
            """;
    } else {
      return """
             document.querySelector('.ytp-title').style.display = ''; 
            """;
    }
  }
}
