import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:videohaven/locastorage/hivelogic.dart';
import 'package:videohaven/screens/home.dart';
import 'package:videohaven/screens/videoview.dart';
import 'package:videohaven/serverlogic/youtube_bloc.dart';
import 'package:videohaven/serverlogic/youtube_event.dart';
import 'package:videohaven/serverlogic/youtube_state.dart';


class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  static List<String> topiclist=[];
  @override
  void initState()
  {
    super.initState();
    loadlist();
  }
  void loadlist()async
  {
    SharedPreferences pref=await SharedPreferences.getInstance();
    topiclist=pref.getStringList('History')??[];
    setState(() {});
}

  String topic='';
  bool  _isloaded=false;
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle:Row(
            children: [
              Expanded(
                child: CupertinoTextField(
                  controller: _searchController,
                  onSubmitted: (String value)async{
                    setState(() {
                      _isloaded=true;
                      topic=_searchController.text;
                    });
                    SharedPreferences pref=await SharedPreferences.getInstance();
                    if(!topiclist.contains(_searchController.text))
                    {
                      topiclist.add(_searchController.text);
                      pref.setStringList('History', topiclist);
                    }
                  },
                  placeholder: 'Search',
                  prefix: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                       child: Icon(CupertinoIcons.search,color: Colors.white70,),
                          ),
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey6,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              _isloaded?IconButton(onPressed: (){
                setState(() {
                  _isloaded=false;
                  _searchController.clear();
                });
              }, icon: Icon(CupertinoIcons.multiply,color: Colors.red,)):SizedBox.shrink(),
            ],
          ) ,
          ),
        child:_isloaded?SearchResult(topic: topic):ListView.builder(
            itemCount:topiclist.length,
            itemBuilder: (context,index){
              return GestureDetector(
                onTap: ()async{
                  setState(() {
                      topic=topiclist[index];
                    _searchController.text=topiclist[index];
                    _isloaded=true;

                  });
                  SharedPreferences pref=await SharedPreferences.getInstance();
                  if(!topiclist.contains(_searchController.text))
                    {
                      topiclist.add(_searchController.text);
                      pref.setStringList('History', topiclist);
                    }


                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.0,horizontal: 5.0),
                  child: CupertinoListTile(
                    leading: Icon(CupertinoIcons.clock),
                   title: Text("${topiclist[index]}"),
                    trailing:IconButton(onPressed: ()async{

                        String topic=topiclist[index];
                        SharedPreferences pref=await SharedPreferences.getInstance();
                        List<String> temp=pref.getStringList('History')??[];
                        if(temp.contains(topic))
                          {
                            temp.remove(topic);
                            pref.setStringList('History', temp);
                          }
                        loadlist();
                        setState(() {});

                    }, icon:  Icon(CupertinoIcons.delete,size: 17,)),
                  ),
                ),
              );
        })

        );
  }
}






class SearchResult extends StatefulWidget {
  String topic;
  String? channelId;
  SearchResult({required this.topic,this.channelId=''});
  @override
  State<SearchResult> createState() => _serachResult();
}

class _serachResult extends State<SearchResult>  {
  String nextPageToken = '';
  final ScrollController _scrollController = ScrollController();
  List<Video> videoList = [];
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
        FetchThumbnailsEvent(
          searchTopic: widget.topic,
          nextPageToken: initialFetch ? '' : nextPageToken,
          channelId: widget.channelId??'',
        ),
      );
    }
  }
  @override
  void didUpdateWidget(covariant SearchResult oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.topic != widget.topic) {
      videoList=[];
      _fetchVideos();
      // Fetch again when topic changes
    }
    if (oldWidget.channelId != widget.channelId) {
      videoList=[];
      _fetchVideos();
      // Fetch again when topic changes
    }
  }

  @override
  Widget build(BuildContext context) {
    print("${widget.topic}");
    print("${widget.channelId}");
    return BlocListener<YoutubeBloc, YoutubeState>(
      listener: (context, state) {
        if (state is YoutubeLoaded) {
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
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => VideoPlayerScreen(video: video),
                            ),
                          );
                          storeHistory(video);
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
    );
  }
}


class CustomCupertinoListTile extends StatelessWidget {
  final Video video;

  CustomCupertinoListTile({required this.video});

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
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: Stack(
                  children: [
                    Image.network(
                      video.thumbnailUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200.0, // Increased height for better visual impact
                    ),
                  ],
                ),
              ),
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