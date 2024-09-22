import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:videohaven/locastorage/hivelogic.dart';
import 'package:videohaven/screens/search.dart';
import 'package:videohaven/serverlogic/youtube_event.dart';
import 'package:videohaven/serverlogic/youtube_state.dart';
import 'package:videohaven/serverlogic/youtube_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:videohaven/screens/settings.dart';

class startchannel extends StatefulWidget {

  const startchannel({super.key});

  @override
  State<startchannel> createState() => _startchannelState();
}

class _startchannelState extends State<startchannel> {
  List<ChannelDetails> channels=[];
  @override
  void initState()
  {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    loadchannel();
  }
  void loadchannel()async
  {
    channels=await getChannel();
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    if(channels.isNotEmpty && channels.length>0)
      {
        return Subscription(channel: channels,);
      }
    else
      return ChannelsList();

  }
}

class ChannelsList extends StatefulWidget {
  const ChannelsList({super.key});

  @override
  State<ChannelsList> createState() => _ChannelsListState();
}

class _ChannelsListState extends State<ChannelsList> {
  TextEditingController _searchController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(

        child:Column(
          children: [
            SizedBox(height: 25,),
            _buildSearchbar(),
             _searchController.text.length>0 && _searchController.text.isNotEmpty?Expanded(child: ChannelsSearch(SearchQuery: _searchController.text)):Container(
                 child:Center(
                     child:Text("Search a Channel Name")
                  )),
          ],
        )
     );
  }
  Widget _buildSearchbar(){
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search channels....',
        border:OutlineInputBorder(
            borderRadius: BorderRadius.circular(50)
        ),
        prefixIcon: Icon(CupertinoIcons.search),
        suffixIcon: GestureDetector(
            onTap: (){
              setState(() {
                _searchController.clear();
              });
            },
            child: Icon(CupertinoIcons.clear,size: 25,)),
        isDense: true,

      ),

      onSubmitted: (query){
           setState(() {});
      },
    );
  }


}

class ChannelsSearch extends StatefulWidget {
  String SearchQuery;
  ChannelsSearch({required this.SearchQuery,super.key});

  @override
  State<ChannelsSearch> createState() => _ChannelsSearchState();
}

class _ChannelsSearchState extends State<ChannelsSearch> {
  String nextPageToken = '';
  final ScrollController _scrollController = ScrollController();
   List<Channel> channels=[];
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
        FetchChannelEvent(
            nextPageToken: nextPageToken??'',
            searchTopic: widget.SearchQuery,
        )
      );
    }
  }
  @override
  void didUpdateWidget(covariant ChannelsSearch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.SearchQuery != widget.SearchQuery) {
      channels=[];
      _fetchVideos();
      // Fetch again when topic changes
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<YoutubeBloc, YoutubeState>(
      listener: (context, state) {
        if (state is YoutubeChannelLoaded) {
          setState(() {
            channels.addAll(state.channels);
            nextPageToken = state.channels.isNotEmpty ? state.channels.last.nextPageToken : '';
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
          if (state is YoutubeChannelLoaded && channels.isEmpty) {
            // Show initial loading indicator
            return Center(child: CupertinoActivityIndicator());
          } else if (state is YoutubeChannelLoaded|| channels.isNotEmpty) {
            // Show the video list
            return CustomScrollView(
              controller: _scrollController,
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final channel = channels[index];
                      return GestureDetector(
                        onTap: () async {
                          },
                        child: ChannelCard(channel: channel),
                      );
                    },
                    childCount: channels.length,
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
          } else if (state is YoutubeError && channels.isEmpty) {
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
              'Searching channels........',
              style: CupertinoTheme.of(context).textTheme.textStyle,
            ),
          );
        },
      ),
    );
  }
}

class ChannelCard extends StatefulWidget {
  Channel channel;
  ChannelCard({super.key,required this.channel});

  @override
  State<ChannelCard> createState() => _ChannelCardState();
}

class _ChannelCardState extends State<ChannelCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
             Navigator.push(context,
             CupertinoPageRoute(builder: (context)=>channelsvideo(channelId: widget.channel.channelId))
             );
             // Navigator.push(context,
             //     CupertinoPageRoute(builder: (context)=>SearchResult(topic: '',channelId: widget.channel.channelId,))
             // );
      },
      child: Container(
        padding: EdgeInsets.all(8), // Add padding around the tile
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), // Rounded corners for the container
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: Offset(0, 3), // Subtle shadow effect
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center, // Aligns image and text to the top

          children: [
            Container(
              width: 120, // Adjust the image container size
              height: 120, // Match image aspect ratio
              decoration: BoxDecoration(
                //color: Colors.white, // Background color of the image container
                borderRadius: BorderRadius.circular(50), // Rounded corners for the image container
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset(0, 5), // Shadow for the image container
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50), // Rounded corners for the image
                child: Image.network(
                  '${widget.channel.thumbnails}',
                  width: 240, // Ensure the image maintains its full size
                  height: 240, // Maintain the aspect ratio
                  fit: BoxFit.cover, // Ensure the image fills the container
                ),
              ),
            ),
            SizedBox(width: 16), // Space between image and text
            Flexible(
              child: Text(
                "${widget.channel.title}",
                style: TextStyle(
                  fontSize: 18, // Adjust font size
                  fontWeight: FontWeight.bold, // Bold title
                ),
                overflow: TextOverflow.ellipsis, // Display "..." when text overflows
                softWrap: false,
              ),
            ),
          ],
        ),
      ),
    );

  }
}


class channelsvideo extends StatefulWidget {
  String channelId;
  channelsvideo({super.key,required this.channelId});

  @override
  State<channelsvideo> createState() => _channelsvideoState();
}
//TODO --> convert channelId to PlaylistDetails

class _channelsvideoState extends State<channelsvideo> with AutomaticKeepAliveClientMixin{
  ChannelDetails channelDetailsclass=new ChannelDetails(description: '', thumbnails: '', title: '', channelId: '', subscriberCount: '', videoCount: '', viewCount: '');
  bool _issub=false;
  @override
  void initState()
  {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }
  Future<ChannelDetails> fetchChannelDetails(String channelId) async {
    try {
      print("============> Fetch video function is called...");

      String url = '';
      var response;
      for (String apiKey in YoutubeBloc.API_KEY) {
        url = 'https://www.googleapis.com/youtube/v3/channels?part=snippet,contentDetails,statistics&id=$channelId&key=$apiKey';
        response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          break;
        }
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['items'].isEmpty) {
          throw Exception('No video details found.');
        }

        final videoData = data['items'][0];
        final snippet = videoData['snippet'];
        final statistics = videoData['statistics'];

        final videoDetails = ChannelDetails(
          description: snippet['description'],
          thumbnails: snippet['thumbnails']['high']['url'],
          title: snippet['title'],
          channelId: videoData['id'],
          subscriberCount: statistics['subscriberCount'],
          videoCount: statistics['videoCount'],
          viewCount: statistics['viewCount'],
        );
        _issub=await checksub(videoDetails);
        return videoDetails;
      } else {
        throw Exception('Failed to fetch video details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  @override
  bool get wantKeepAlive=>true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("Fetching channel details for: ${widget.channelId}");
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    print("====>>>>>>>${widget.channelId}");

    return FutureBuilder<ChannelDetails>(
      future: fetchChannelDetails(widget.channelId), // Add your API keys
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading indicator
          return CupertinoPageScaffold(
            child: Center(
              child: CupertinoActivityIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          // Show error message
          return CupertinoPageScaffold(
            child: Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: CupertinoTheme.of(context).textTheme.textStyle,
              ),
            ),
          );
        } else if (snapshot.hasData) {
          // Show channel details
          final channel = snapshot.data!;
          return CupertinoPageScaffold(
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Channel Thumbnail
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                          channel.thumbnails,
                          width: 240,
                          height: 240,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 16),
                      // Channel Title
                      Text(
                        channel.title,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      // Follow Button
                      ElevatedButton(
                        onPressed: () async {
                          // Method for storing local data (adjust to your needs)
                          if (_issub==false) {
                            // Subscribe and show a message
                            storeChannel(channel);
                            Fluttertoast.showToast(
                              msg: "Subscribed ${channel.title}",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.white,
                              textColor: Colors.black,
                              fontSize: 15.0,
                            );
                          }
                          else
                            {
                              int index=await getChannelDetailsIndex(channel);
                              if(index != -1)
                                {
                                  await deleteChannel(index);
                                  Fluttertoast.showToast(
                                    msg: "Unsubscribed ${channel.title}",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 15.0,
                                  );
                                }

                            }

                          setState(() {});
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _issub
                              ? CupertinoColors.destructiveRed.withOpacity(0.8)
                              : Colors.purple,
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 5,
                          shadowColor: Colors.black.withOpacity(0.2),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _issub ? Icons.cancel : Icons.person_add,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Text(
                              _issub ? "Unsubscribe" : "Subscribe",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      // Channel Description
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          channel.description,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: CupertinoColors.systemGrey,
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      // Channel Stats
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatColumn("View Count", channel.viewCount),
                          _buildStatColumn("Subscribers", channel.subscriberCount),
                          _buildStatColumn("Videos", channel.videoCount),
                        ],
                      ),
                      SizedBox(height: 24),
                      // Videos Button
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to videos page
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => SearchResult(topic: widget.channelId),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CupertinoColors.activeOrange,
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "View Videos",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            Icon(CupertinoIcons.right_chevron),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          // No data state
          return CupertinoPageScaffold(
            child: Center(
              child: Text(
                'No channel details available',
                style: CupertinoTheme.of(context).textTheme.textStyle,
              ),
            ),
          );
        }
      },
    );
  }
  // Helper method to build stat columns
  Widget _buildStatColumn(String label, String count) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(color: CupertinoColors.systemGrey), // Gray label
        ),
        SizedBox(height: 4), // Space between label and count
        Text(
          count,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16), // Bold count
        ),
      ],
    );
  }

  Future<bool> checksub(ChannelDetails channel)async
  {
      List<ChannelDetails> chennels=await getChannel();
      for(ChannelDetails channel2 in chennels)
        {
          if(channel2==channel)
            {
              print("========>i subscribe that ....<============");
              return true;
            }
        }
      return false;
  }

}


class Subscription extends StatefulWidget {
  List<ChannelDetails> channel;
 Subscription({required this.channel,super.key});

  @override
  State<Subscription> createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  String ChannelId='';
  List<ChannelDetails> channel=[];
  @override
  void initState(){
    super.initState();
    channel=widget.channel;
    ChannelId=channel[0].channelId;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }
  @override
  void dispose()
  {
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: Column(
          children: [
            SizedBox(height: 10,),
            SizedBox(
              height: 80,
              child: ListView.builder(
                  itemCount: channel.length+1,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context,index)
                  {
                    if(index <channel.length)
                      {
                        return GestureDetector(
                          onTap: (){

                            setState(() {
                              ChannelId=channel[index].channelId;
                            });
                            print("==========>now channelid is $ChannelId<============");
                          },
                          child: Center(
                            child: Container(
                              margin: EdgeInsets.all(1),
                              padding: EdgeInsets.all(3),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: Image(image: NetworkImage(channel[index].thumbnails),
                                  width: 65,
                                  height: 65,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    else
                      {
                        return IconButton(
                          onPressed: () async {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => Scaffold(
                                  body: ChannelsList(),
                                ),
                              ),
                            );
                          },
                          icon: Icon(CupertinoIcons.add_circled, color: Colors.white, size: 30),
                        );

                      }

                  }
              ),
            ),
            Expanded(child: SearchResult(topic: '',channelId: ChannelId,))
          ],
        )
      );
  }
}



