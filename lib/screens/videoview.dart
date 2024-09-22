import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:videohaven/serverlogic/youtube_bloc.dart';
import 'package:videohaven/serverlogic/youtube_event.dart';
import 'package:videohaven/serverlogic/youtube_state.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';

class VideoDetails
{
  String title;
  String channelTitle;
  String description;
  String duration;
  String videoUrl;
  VideoDetails({
    required this.duration,
    required this.videoUrl,
    required this.channelTitle,
    required this.description,
    required this.title,
});
}






// Assuming your Video class and YoutubeBloc are correctly defined elsewhere







class VideoPlayerScreen extends StatefulWidget {
  final Video video;

  VideoPlayerScreen({required this.video});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen>  with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive=>true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    context.read<YoutubeBloc>().add(FetchVideoDetailsEvent(widget.video));

    return BlocBuilder<YoutubeBloc, YoutubeState>(
      builder: (context, state) {
        if (state is YoutubeLoading) {
          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text('Video Player'),
            ),
            child: Center(
              child: CupertinoActivityIndicator(),
            ),
          );
        } else if (state is YoutubeVideoDetailsLoaded) {
          final videoDetails = state.videoDetails;
          final videoId = YoutubePlayer.convertUrlToId(videoDetails.videoUrl) ?? '';

          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text('Video Player'),
              trailing: IconButton(onPressed: (){
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => FullScreenVideoPlayer(videoId: videoId),
                  ),
                );
              }, icon: Icon(Icons.fullscreen)),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: YoutubePlayer(
                          controller: YoutubePlayerController(
                            initialVideoId: videoId,
                            flags: YoutubePlayerFlags(
                              autoPlay: true,
                              controlsVisibleAtStart: false,
                              enableCaption: false,
                              forceHD: true,
                              showLiveFullscreenButton:false,
                            ),
                          ),
                          showVideoProgressIndicator: true,
                          progressIndicatorColor: CupertinoColors.activeBlue,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        videoDetails.title,
                        style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Channel: ${videoDetails.channelTitle}',
                        style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                          fontSize: 16,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Duration: ${videoDetails.duration}',
                        style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                          fontSize: 16,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        videoDetails.description,
                        style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                          fontSize: 14,
                          height: 1.5,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: CupertinoButton(
                          color: CupertinoColors.activeBlue,
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          borderRadius: BorderRadius.circular(25.0),
                          onPressed: () {
                            // Handle download action
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(CupertinoIcons.cloud_download, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Download',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else if (state is YoutubeError) {
          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text('Video Player'),
            ),
            child: Center(
              child: Text(
                state.message,
                style: CupertinoTheme.of(context).textTheme.textStyle,
              ),
            ),
          );
        }

        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text('Video Player'),
          ),
          child: Center(
            child: Text(
              'No video details available',
              style: CupertinoTheme.of(context).textTheme.textStyle,
            ),
          ),
        );
      },
    );
  }
}









class FullScreenVideoPlayer extends StatefulWidget {
  final String videoId;

  FullScreenVideoPlayer({required this.videoId});

  @override
  _FullScreenVideoPlayerState createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    // Initialize the Youtube player controller
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        controlsVisibleAtStart: false,
        enableCaption: false,
        forceHD: true,
      ),
    );

    // Enter full-screen mode and set landscape orientation
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    // Dispose of the Youtube player controller
    _controller.dispose();

    // Exit full-screen mode and revert orientation to default
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the current screen size using MediaQuery
    final screenSize = MediaQuery.of(context).size;

    // Calculate the aspect ratio for the video based on screen dimensions
    final aspectRatio = screenSize.width / screenSize.height;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: screenSize.width,
          height: screenSize.height,
          child: YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.blue,
            aspectRatio: aspectRatio, // Use the aspect ratio based on the screen size
          ),
        ),
      ),
    );
  }
}


