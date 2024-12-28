import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class VideoController {
  final InAppWebViewController controller;
  VideoController(this.controller) {
    getAllVideoTime();
  }

  double videoDuration = 0.0; //// THE VIDEO DURATION

  /// PLAY THE VIDEO
  Future<void> playVideo() async {
    await controller.evaluateJavascript(
      source: """
                var video = document.querySelector('video');  
                var playButton = document.querySelector('.ytp-play-button');  
                if(playButton){  
                  if(video.paused){  
                    playButton.click();  
                  }
                }else{
                  if (video) {  
                    video.play();  
                  }
                }
                """,
    );
  }

  /// PAUSE THE VIDEO
  Future<void> pauseVideo() async {
    await controller.evaluateJavascript(
      source: """
                var video = document.querySelector('video');  
                if (video) {  
                  video.pause(); 
                }
                """,
    );
  }

  /// MUTE THE VIDEO
  Future<void> muteOrUnmuteVideo() async {
    await controller.evaluateJavascript(
      source: """
                var video = document.querySelector('video'); 
                var muteButton = document.querySelector('.ytp-mute-button');
                if(muteButton){  
                  video.muted = true; 
                  muteButton.click();
                }
                """,
    );
  }

  /// GET THE VIDEO DURATION
  Future<void> getAllVideoTime() async {
    // GET THE VIDEO DURATION USING JAVASCRIPT
    await controller.evaluateJavascript(
      source: """
      var video = document.querySelector('video');  
      if (video) {  
        video.duration;
      }
    """,
    ).then(
      (result) {
        // THE RESULT RETURNED FROM JAVASCRIPT WILL BE THE VIDEO DURATION
        if (result != null) {
          double duration = double.tryParse(result.toString()) ??
              0.0; //// PARSE THE DURATION AS A DOUBLE

          videoDuration =
              duration; //// CALL THE CALLBACK FUNCTION WITH THE VIDEO DURATION
        } else {
          videoDuration = 0.0; //// IF NO VIDEO IS FOUND, RETURN 0.0
        }
      },
    );
  }

  /// SEEK TO A SPECIFIC TIME IN THE VIDEO
  Future<void> seekTo({
    required double time, //// THE TIME TO SEEK TO (IN SECONDS)
  }) async {
    await controller.evaluateJavascript(
      source: """
                var video = document.querySelector('video');  
                video.currentTime = $time;  
                video.onseeked = function() {
                    window.flutter_inappwebview.callHandler('onVideoSeek', video.currentTime);  //// CALL HANDLER AFTER SEEKING IS COMPLETED
                };
                """,
    );
  }
}
