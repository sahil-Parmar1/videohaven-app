import 'package:flutter/cupertino.dart';
import 'package:videohaven/locastorage/hivelogic.dart';
import 'package:videohaven/serverlogic/youtube_state.dart';
import 'package:videohaven/screens/playlist.dart';
class savedPlaylist extends StatefulWidget {
  const savedPlaylist({super.key});

  @override
  State<savedPlaylist> createState() => _savedPlaylistState();
}

class _savedPlaylistState extends State<savedPlaylist> {
  List<Playlist> _playlist=[];
  @override
  void initState()
  {
    super.initState();
    loadlist();
  }
  void loadlist()async
  {
    _playlist=await getPlaylist();
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text("Saved Playlists"),
        ),
        child:_playlist.length>0? ListView.builder(
            itemCount: _playlist.length,
            itemBuilder: (context,index)
            {
              Playlist playlist=_playlist[index];
              return GestureDetector(
                  onTap: (){
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (context)=>PlaylistVideoDetailsScreen(video: playlist))
                    );
                  },
                  child: CustomCupertinoListTile(video: playlist,isorg: true,));
            }
           ):Center(child: Container(child: Text("No Saved Playlist yet"),)),

      );
  }
}

