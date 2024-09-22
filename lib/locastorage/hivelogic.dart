import 'package:videohaven/serverlogic/youtube_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

//for history
Future<void> storeHistory(Video video)async
{
  try
  {
    late Box<Video> videoBox;
    SharedPreferences prefs=await SharedPreferences.getInstance();
    int count=await prefs.getInt('countHistory')??0;
    videoBox=await Hive.openBox<Video>('History');
    video.time=DateTime.now();
    videoBox.put(count, video);
    ++count;
    prefs.setInt('countHistory', count);
    videoBox.close();
    print("=============>>>History save sucessFully<<<<<==============");
  }
  catch(e)
      {
        print("error in store history======>$e");
      }

}

Future<List<Video>> getHistory({int start=0,int end=0})async
{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    int count=await prefs.getInt('countHistory')??0;
    late Box<Video> videoBox;
    List<Video> video=[];
  try
  {
    if(count>=end)
    {
      if(end==0)
        end=count;
      videoBox=await Hive.openBox<Video>('History');
      for(int i=start;i<end;i++)
      {
        Video _video = videoBox.get(i)??Video(title: '', channelTitle: '', description: '', thumbnailUrl: '',videoid: '',nextPageToken: '');
        video.add(_video);
      }
      videoBox.close();
    }
    print("=============>>>History fetch sucessFully<<<<<==============");
  }
  catch(e)
  {
    print("error in get History======>$e");
  }

    // Sorting the list, handling null values by placing them last and showing most recent dates first
    video.sort((a, b) {
      if (a.time == null && b.time == null) return 0;  // Both null
      if (a.time == null) return 1;                   // a is null, put it last
      if (b.time == null) return -1;                  // b is null, put it last

      // Compare dates in reverse order (newest first)
      return b.time!.compareTo(a.time!);
    });

  return video;

}



//for playlist
Future<void> storePlaylist(Playlist playlist)async
{
  try
  {
    late Box<Playlist> PlaylistBox;
    SharedPreferences prefs=await SharedPreferences.getInstance();
    int count=await prefs.getInt('countPlaylist')??0;
    PlaylistBox=await Hive.openBox<Playlist>('Playlist');
    PlaylistBox.put(count, playlist);
    ++count;
    prefs.setInt('countPlaylist', count);
    PlaylistBox.close();
    print("=============>>>Play list store sucessFully<<<<<==============");
  }
  catch(e)
  {
    print("error in store Playlist======>$e");
  }

}
Future<List<Playlist>> getPlaylist({int start=0,int end=0})async
{
      SharedPreferences prefs=await SharedPreferences.getInstance();
    int count=await prefs.getInt('countPlaylist')??0;
    late Box<Playlist> PlaylistBox;

    List<Playlist> playlist=[];
  try
  {
    if(count>=end)
    {
      if(end==0)
        end=count;
      PlaylistBox=await Hive.openBox<Playlist>('Playlist');
      for(int i=start;i<end;i++)
      {
        Playlist _video = PlaylistBox.get(i)??Playlist(playlistId: '', nextPageToken: '', description: '', title: '', channelId: '', thumbnails: '');
        playlist.add(_video);
      }
      PlaylistBox.close();
    }
    print("=============>>>Play list fetch sucessFully<<<<<==============");
  }
  catch(e)
  {
    print("error in get Playlist======>$e");
  }


  return playlist.reversed.toList();
}
//for channels
Future<void> storeChannel(ChannelDetails channel)async
{
  try
  {
    late Box<ChannelDetails> ChannelBox;
    SharedPreferences prefs=await SharedPreferences.getInstance();
    int count=await prefs.getInt('countChannel')??0;
    ChannelBox=await Hive.openBox<ChannelDetails>('Channel');
    ChannelBox.put(count, channel);
    ++count;
    prefs.setInt('countChannel', count);
    ChannelBox.close();
    print("=============>>>Channel store sucessFully<<<<<==============");
  }
  catch(e)
  {
    print("error in store channel======>$e");
  }

}
Future<List<ChannelDetails>> getChannel({int start=0,int end=0})async
{
        SharedPreferences prefs=await SharedPreferences.getInstance();
      int count=await prefs.getInt('countChannel')??0;
      late Box<ChannelDetails> ChannelBox;

      List<ChannelDetails> channels=[];
  try
  {
    if(count>=end)
    {
      if(end==0)
        end=count;
      ChannelBox=await Hive.openBox<ChannelDetails>('Channel');
      for(int i=start;i<end;i++)
      {
        ChannelDetails? _video = ChannelBox.get(i);
        if(_video != null)
        channels.add(_video);
      }
      ChannelBox.close();
    }
    print("=============>>>Channel fetch sucessFully<<<<<==============");
  }
  catch(e)
  {
    print("error in fetch channel======>$e");
  }


  return channels.reversed.toList();
}

Future<int> getChannelDetailsIndex(ChannelDetails channel)async
{
  SharedPreferences prefs=await SharedPreferences.getInstance();
  int count=await prefs.getInt('countChannel')??0;
  late Box<ChannelDetails> ChannelBox;
  try
      {
        ChannelBox=await Hive.openBox<ChannelDetails>('Channel');
        for(int i=0;i<count;i++)
        {
          ChannelDetails? _video = ChannelBox.get(i);
          if(_video != null && _video==channel)
           {
             print("=======>getchanneldetailsindex return $i index<===========");
             return i;
           }
        }
        ChannelBox.close();
      }
      catch(e)
  {
    print("==========>>error in getChannelDetailsIndex  $e");
  }
  return -1;
}
Future<void> deleteChannel(int index)async
{
  print("========>$index will be deleted....<======");
  try
      {
        Box<ChannelDetails> ChannelBox=await Hive.openBox<ChannelDetails>('Channel');
        ChannelBox.delete(index);
        SharedPreferences prefs=await SharedPreferences.getInstance();
        int count=await prefs.getInt('countChannel')??0;
        --count;
        prefs.setInt('countChannel', count);
        print("===============>channel deleted sucessfully<===================");
        ChannelBox.close();
      }
      catch(e)
    {
     print("=========>>error in delete the index $e");
    }
}