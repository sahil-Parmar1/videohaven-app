import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:videohaven/screens/videoview.dart';
import 'package:videohaven/serverlogic/youtube_state.dart';
import 'package:videohaven/locastorage/hivelogic.dart';
import 'package:videohaven/screens/search.dart';
import 'package:flutter/services.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {

  List<Video> videolist=[];
  @override
  void initState()
  {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    loadmedia();
  }
  void loadmedia()async
  {
    videolist=await getHistory();
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return   CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Row(
            mainAxisAlignment: MainAxisAlignment.start, // Align items to the start
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(CupertinoIcons.clock)),
              Expanded(
                child: Text(
                  'History', // Placeholder for text next to the logo
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,

                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis, // Handles long text gracefully
                ),
              ),
              
            ],
          ),
          padding: EdgeInsetsDirectional.zero, // Reduce padding to keep everything aligned

        ),
        child:videolist.length>0?CustomScrollView(
          slivers: <Widget>[

            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final video = videolist[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2.0,top: 2.0),
                        child: Text(
                          "${video.time}",
                          style: TextStyle(fontSize: 14, color: CupertinoColors.systemGrey),
                        ),
                      ),
                      GestureDetector(
                        onTap:()async{
                          storeHistory(video);
                          Navigator.push(context,
                          CupertinoPageRoute(builder: (context)=>VideoPlayerScreen(video: video))
                          );
                          },
                        child: CustomCupertinoListTile(
                          video: video,
                        ),
                      ),
                    ],
                  );
                },
                childCount: videolist.length,
              ),
            ),
          ],
        ):Center(
        child:Text("No History Yet"),
    ),
    );
  }
}




