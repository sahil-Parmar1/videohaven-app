import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:videohaven/locastorage/hivelogic.dart';
import 'package:videohaven/main.dart';
import 'package:videohaven/screens/savedPlaylist.dart';
import 'package:videohaven/screens/videoview.dart';
import 'package:videohaven/serverlogic/youtube_bloc.dart';
import 'package:videohaven/serverlogic/youtube_event.dart';
import 'package:videohaven/serverlogic/youtube_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'settings.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';

class Playlistscreen extends StatefulWidget {
  const Playlistscreen({super.key});

  @override
  State<Playlistscreen> createState() => _PlaylistscreenState();
}

class _PlaylistscreenState extends State<Playlistscreen> {
  bool _issearch=false;
  TextEditingController _searchController=TextEditingController();
  String topic='';

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Row(
            mainAxisAlignment: MainAxisAlignment.start, // Align items to the start
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0), // Spacing between elements
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: CupertinoColors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/logo.png'), // Your logo image
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'VideoHaven', // Placeholder for text next to the logo
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,

                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis, // Handles long text gracefully
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  // Define your search action here

                },
                child: Icon(
                  CupertinoIcons.search, // Cupertino style search icon
                  color: Colors.white,

                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  // Define your search action here
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context)=>SettingsPage())
                  );
                },
                child: Icon(
                  CupertinoIcons.settings,
                  color: Colors.white,// Cupertino style search icon

                ),
              ),
            ],
          ),
          padding: EdgeInsetsDirectional.zero, // Reduce padding to keep everything aligned

        ),
        child:_issearch?_buildSearchScreen():_buildInitialScreen(),

     );
  }

  Widget _buildSearchScreen()
  {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search....',
            border:OutlineInputBorder(
              borderRadius: BorderRadius.circular(50)
            ),
            prefixIcon: Icon(CupertinoIcons.search),
            suffixIcon: GestureDetector(
                onTap: (){
                  setState(() {
                    _issearch=false;
                    _searchController.clear();
                  });
                },
                child: Icon(CupertinoIcons.clear,size: 25,)),
            isDense: true,

          ),
          onSubmitted: (query){
            topic=query;
            setState(() {
              _issearch=true;
            });
          },
        ),
        Expanded(child: PlaylistScreen(topic: topic))

      ],
    );
  }
  Widget _buildInitialScreen(){
    return ListView(
      children: [
        SizedBox(height: 100,),
        Center(
          child:Column(
            mainAxisAlignment:MainAxisAlignment.center,
              children:[
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purpleAccent.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: Offset(5, 5),
                      )
                    ],
                    image: DecorationImage(image: NetworkImage("https://static.vecteezy.com/system/resources/previews/024/149/923/non_2x/video-playlist-icon-linear-design-vector.jpg"),
                     fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(100), // Optional: for rounded corners
                    border: Border.all(
                      color: Colors.blue,
                      width: 0.5,
                    ),



                  ),
                ),

            SizedBox(height:20),
                Padding(padding: EdgeInsets.symmetric(horizontal: 20.0),
                child:  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search Playlist.....',
                      prefix: Icon(Icons.playlist_add,color: Colors.white,),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                      ),


                    ),
                    onSubmitted: (query){
                      topic=query;
                      setState(() {
                        _issearch=true;
                      });
                    },
                  ),
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                 ElevatedButton(
                   style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.deepPurple,
                     elevation: 8,
                     shadowColor: Colors.purpleAccent,
                   ),
                   onPressed: (){
                         Navigator.push(context,
                         CupertinoPageRoute(builder: (context)=>savedPlaylist())
                         );
                   },
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.end,
                     children: [
                       Text("Saved Playlist",style: TextStyle(color: Colors.white),),
                       SizedBox(width: 5,),
                       Icon(CupertinoIcons.bookmark_fill,color: Colors.white,),
                     ],
                   ),
                 ),

                  ],
                )


            ]
          )
        ),
      ],
    );
  }
}




class PlaylistScreen extends StatefulWidget {
  String topic;
  PlaylistScreen({required this.topic});
  @override
  State<PlaylistScreen> createState() => _PlaylistScreen();
}

class _PlaylistScreen extends State<PlaylistScreen>  {
  String nextPageToken = '';
  final ScrollController _scrollController = ScrollController();
  List<Playlist> videoList = [];
  bool _isLoadingMore = false;



  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    // Initial fetch
    _fetchVideos(initialFetch: true);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Trigger fetch more when the user scrolls near the bottom
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && !_isLoadingMore) {
      _fetchVideos();
    }
  }

  void _fetchVideos({bool initialFetch = false}) {
    if (!_isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
      });

      // Trigger event to fetch videos
      context.read<YoutubeBloc>().add(
        FetchPlaylistEvent(
          searchTopic: widget.topic,
          nextPageToken: initialFetch ? '' : nextPageToken,
        ),
      );
    }
  }
  @override
  void didUpdateWidget(covariant PlaylistScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.topic != widget.topic) {
      videoList=[];
      _fetchVideos();
      // Fetch again when topic changes
    }
  }

  @override
  Widget build(BuildContext context) {
    print("${widget.topic}");
    return CupertinoPageScaffold(

      child: BlocListener<YoutubeBloc, YoutubeState>(
        listener: (context, state) {
          if (state is YoutubePlaylistLoaded) {
            setState(() {
              videoList.addAll(state.videos);
              nextPageToken = state.videos.isNotEmpty ? state.videos.last.nextPageToken : '';
              _isLoadingMore = false;
            });
          } else if (state is YoutubeError) {
            setState(() {
              _isLoadingMore = false; // Stop loading on error
            });
          }
        },
        child: BlocBuilder<YoutubeBloc, YoutubeState>(
          builder: (context, state) {
            if (state is YoutubeLoading && videoList.isEmpty) {
              // Show initial loading indicator
              return Center(child: CupertinoActivityIndicator());
            } else if (state is YoutubeLoaded || videoList.isNotEmpty) {
              // Show the video list
              return CustomScrollView(
                controller: _scrollController,
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final video = videoList[index];
                        return GestureDetector(
                          onTap: () async {
                                   Navigator.push(context,
                                   CupertinoPageRoute(builder: (context)=>PlaylistVideoDetailsScreen(video: video))
                                   );
                          },
                          child: CustomCupertinoListTile(
                            video: video,
                          ),
                        );
                      },
                      childCount: videoList.length,
                    ),
                  ),
                  // Add a loading indicator at the bottom for pagination
                  if (_isLoadingMore)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(child: CupertinoActivityIndicator()),
                      ),
                    ),
                ],
              );
            } else if (state is YoutubeError && videoList.isEmpty) {
              // Show error message if no videos loaded
              return Center(
                child: Text(
                  state.message,
                  style: CupertinoTheme.of(context).textTheme.textStyle,
                ),
              );
            }

            // Default fallback
            return Center(
              child: Text(
                'Search for videos',
                style: CupertinoTheme.of(context).textTheme.textStyle,
              ),
            );
          },
        ),
      ),
    );
  }
}



class CustomCupertinoListTile extends StatelessWidget {
  final Playlist video;
     bool isorg=false;
  CustomCupertinoListTile({required this.video,this.isorg=false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          decoration: BoxDecoration(

            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: CupertinoColors.black.withOpacity(0.3),
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.bottomCenter, // All children will be centered by default
                children: [
                  // First container (bottom layer)

                  // Second container (middle layer)

                  Container(
                    height: 250,
                    width: 320,

                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(video.thumbnails),
                          fit: BoxFit.fitHeight,
                        ),
                        borderRadius: BorderRadius.circular(10), // Circular radius
                        border: Border.all(
                          color: Colors.black,
                          width: 0.2,
                        )

                    ),
                  ),

                  // Third container (top layer)
                  Container(
                    height: 200,
                    width: 350,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(video.thumbnails),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10), // Circular radius
                        border: Border.all(
                          color: Colors.black,
                          width: 0.2,
                        )
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          decoration:BoxDecoration(
                              color: Colors.white.withOpacity(0.5)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.playlist_play,color: Colors.black,),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 60,
                    right: 10,
                    child: GestureDetector(
                      onTap: ()async{
                        if(isorg==false)
                          {
                            storePlaylist(video);
                            Fluttertoast.showToast(msg:"Saved:${video.title}",
                              toastLength: Toast.LENGTH_SHORT, // Or Toast.LENGTH_LONG
                              gravity: ToastGravity.BOTTOM, // Toast position
                              backgroundColor: Colors.white,
                              textColor: Colors.black,
                              fontSize: 15.0,
                            );
                          }

                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.purpleAccent,
                        ),
                        child: !isorg?Icon(CupertinoIcons.bookmark,color: Colors.white,):Icon(CupertinoIcons.bookmark_fill,color: Colors.white,)),
                    ),
                  ),
                ],
              ),
              // Padding(
              //     padding: const EdgeInsets.all(12.0),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.end,
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Icon(Icons.save),
              //       ],
              //     )
              // ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  video.title,
                  style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: CupertinoColors.white,
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class PlaylistVideoDetailsScreen extends StatefulWidget {

  Playlist video;
  PlaylistVideoDetailsScreen({super.key,required this.video});

  @override
  State<PlaylistVideoDetailsScreen> createState() => _PlaylistVideoDetailsScreenState();
}

class _PlaylistVideoDetailsScreenState extends State<PlaylistVideoDetailsScreen>
{
  String nextPageToken = '';
  final ScrollController _scrollController = ScrollController();
  List<PlaylistvideoDetails> videoList = [];
  bool _isLoadingMore = false;



  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Initial fetch
    _fetchVideos(initialFetch: true);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {

    print("is scroll");
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent-200  && !_isLoadingMore) {
      _fetchVideos();
    }


    // Check if the content is too short to fill the screen
  }


  void _fetchVideos({bool initialFetch = false}) {
    if (!_isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
      });

      // Trigger event to fetch videos
      context.read<YoutubeBloc>().add(
        FecthPlaylistVideoDetailsEvent(widget.video,nextPageToken: initialFetch ? '' : nextPageToken,)
      );
    }

  }


  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(

      child: BlocListener<YoutubeBloc, YoutubeState>(
        listener: (context, state) {
          if (state is YoutubePlaylistDetailsLoaded) {
            setState(() {
              videoList.addAll(state.videos);
              nextPageToken = state.videos.isNotEmpty ? state.videos.last.nextPageToken : '';
              _isLoadingMore = false;
            });
          } else if (state is YoutubeError) {
            setState(() {
              _isLoadingMore = false; // Stop loading on error
            });
          }
        },
        child: BlocBuilder<YoutubeBloc, YoutubeState>(
          builder: (context, state) {
            if (state is YoutubeLoading && videoList.isEmpty) {
              // Show initial loading indicator
              return Center(child: CupertinoActivityIndicator());
            } else if (state is YoutubeLoaded || videoList.isNotEmpty) {
              // Show the video list
              return CustomScrollView(
                controller: _scrollController,
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final video = videoList[index];

                        // Check if the index is 0 to display the first video larger
                        if (index == 0) {
                          return GestureDetector(
                            onTap: () async {
                              // Action for the first video tap
                            },
                            child: FirstVideoTile(
                              video: video,
                            ),
                          );
                        } else {
                          return GestureDetector(
                            onTap: () async {
                              // Action for other videos tap
                            },
                            child: CustomCupertinoListTileForPlaylistDetails(
                              video: video,
                            ),
                          );
                        }
                      },
                      childCount: videoList.length,
                    ),
                  ),
                  // Add a loading indicator at the bottom for pagination
                  if (_isLoadingMore)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(child: CupertinoActivityIndicator()),
                      ),
                    ),
                ],
              );

            } else if (state is YoutubeError && videoList.isEmpty) {
              // Show error message if no videos loaded
              return Center(
                child: Text(
                  state.message,
                  style: CupertinoTheme.of(context).textTheme.textStyle,
                ),
              );
            }

            // Default fallback
            return Center(
              child: Text(
                'Search for videos',
                style: CupertinoTheme.of(context).textTheme.textStyle,
              ),
            );
          },
        ),
      ),
    );
  }
}

class CustomCupertinoListTileForPlaylistDetails extends StatelessWidget {
  final PlaylistvideoDetails video;

  CustomCupertinoListTileForPlaylistDetails({required this.video});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          // Handle video item click (if needed)
          Video videoes=new Video(title: '', channelTitle: '', description: '', thumbnailUrl: '', videoid:video.videoId, nextPageToken: '');
          Navigator.push(context,
              CupertinoPageRoute(builder: (context)=>VideoPlayerScreen(video: videoes))
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: CachedNetworkImage(
                imageUrl: video.thumbnails,
                height: 80,
                width: 120,
                fit: BoxFit.cover,
                placeholder: (context, url) => CupertinoActivityIndicator(),
                errorWidget: (context, url, error) => Icon(CupertinoIcons.exclamationmark_triangle),
              ),
            ),
            SizedBox(width: 10),
            // Video Title
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    video.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class FirstVideoTile extends StatelessWidget {
  final PlaylistvideoDetails video;

  const FirstVideoTile({Key? key, required this.video}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
              Stack(
              children: [
                      CachedNetworkImage(
                      imageUrl: video.thumbnails,
                        height: 200,  // Larger height for the first video thumbnail
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        bottom: 10,  // Position it at the bottom with a little padding
                        right: 10,   // Position the button a bit from the right edge
                        child:ElevatedButton(
                          onPressed: (){
                            Video videoes=new Video(title: '', channelTitle: '', description: '', thumbnailUrl: '', videoid:video.videoId, nextPageToken: '');
                            Navigator.push(context,
                            CupertinoPageRoute(builder: (context)=>VideoPlayerScreen(video: videoes))
                            );
                          },
                          child: Icon(
                            Icons.play_arrow,
                            size: 30,
                            color: Colors.white,  // White icon for contrast against dark theme
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            backgroundColor: Colors.deepPurpleAccent,  // Dark purple background
                            padding: const EdgeInsets.all(13),  // Larger padding for a bigger button
                            elevation: 10,  // Higher elevation for a modern feel
                            shadowColor: Colors.deepPurple.withOpacity(0.5),  // Subtle purple shadow
                          ),
                        )

                      ),
              ],
            ),

    const SizedBox(height: 8),
          Text(
            video.title,
            style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
              fontSize: 18, // Larger font size for the title
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

