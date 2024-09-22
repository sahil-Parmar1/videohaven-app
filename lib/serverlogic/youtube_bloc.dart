import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:videohaven/serverlogic/youtube_state.dart';
import 'package:videohaven/serverlogic/youtube_event.dart';
import 'package:videohaven/screens/videoview.dart';
class YoutubeBloc extends Bloc<YoutubeEvent, YoutubeState> {
  static List<String> API_KEY=[
    'AIzaSyA3jettFRrAFXpNzQdtjHSOwutBxhVr9MQ',
     'AIzaSyBNPWB3flCC3ld3AKO-k4enmIcpPuQx3uk',
     'AIzaSyDRuj1dmBIfBBIZKACktYFxUZmwsYVMUkg',
      'AIzaSyCOmcLIaJw-iE2aum2Pyel-ILXIRvhy_DA',
      'AIzaSyCL_uIu8NqKf_qwsgRPspjxVPGZ4Ir0huI',
  ];


  //final String searchQuery = 'technology'; // Replace with your desired search query

  YoutubeBloc() : super(YoutubeInitial()) {
    on<FetchThumbnailsEvent>(_onFetchThumbnails);
    on<FetchVideoDetailsEvent>(_onFetchVideoDetails);
    on<FetchPlaylistEvent>(_onFetchPlaylistEvent);
    on<FecthPlaylistVideoDetailsEvent>(_onFetchPlaylistVideoDetailsEvent);
   on<FetchChannelEvent>(_onFetchChannels);
  }

  Future<void> _onFetchThumbnails(
      FetchThumbnailsEvent event, Emitter<YoutubeState> emit) async {
    String? nextPageToken = event.nextPageToken;
    String searchtopic=event.searchTopic;
    String? channelId=event.channelId;
    emit(YoutubeLoading());

    try {
      late String url;
      var response;
      if(nextPageToken != null && nextPageToken.isNotEmpty && nextPageToken != '')
        {
           if(channelId!=null && channelId != '')
             {
               for(String apikey in API_KEY)
                 {
                   url='https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=10&channelId=$channelId&order=date&pageToken=$nextPageToken&type=video&key=$apikey';
                 response = await http.get(Uri.parse(url));
                   if(response.statusCode==200)
                     break;
                 }

             }
           else
             {
               for(String apikey in API_KEY)
               {
                 url =
                 'https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=5&q=$searchtopic&type=video&videoDuration=medium&pageToken=$nextPageToken&key=$apikey';
                 response = await http.get(Uri.parse(url));
                 if(response.statusCode==200)
                   break;
               }
             }

        }
      else
        {
          if(channelId != null && channelId != '')
            {
              for(String apikey in API_KEY)
              {
                url='https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=10&channelId=$channelId&order=date&type=video&key=$apikey';
                response = await http.get(Uri.parse(url));
                if(response.statusCode==200)
                  break;
              }

            }
          else
            {
              for(String apikey in API_KEY)
              {
                url =
                'https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=5&q=$searchtopic&type=video&videoDuration=medium&key=$apikey';
                response = await http.get(Uri.parse(url));
                if(response.statusCode==200)
                  break;
              }
            }

        }


      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List videos = data['items'];
        final nextpagetoken=data['nextPageToken'];

        // Extract detailed video information
        final videoDetails = videos.map((video) {
          final snippet = video['snippet'];
          final videoid=video['id']['videoId'];
          return Video(
            title: snippet['title'],
            channelTitle: snippet['channelTitle'],
            description: snippet['description'],
            thumbnailUrl: snippet['thumbnails']['high']['url'],
            videoid:videoid,
            nextPageToken:nextpagetoken,
          );
        }).toList();

        emit(YoutubeLoaded(videoDetails));
      } else {
        emit(YoutubeError('Failed to fetch videos: ${response.statusCode}'));
      }
    } catch (e) {
      emit(YoutubeError('An error occurred: $e'));
    }
  }

  Future<void> _onFetchVideoDetails(
      FetchVideoDetailsEvent event, Emitter<YoutubeState> emit) async {
    emit(YoutubeLoading());

    try {
      print("============> Fetch video function is called...");

      final video = event.video;
      String url='';
      var response;
      for(String apikey in API_KEY)
      {
        url =
            'https://www.googleapis.com/youtube/v3/videos?part=snippet,contentDetails&id=${video.videoid}&key=$apikey';
        response = await http.get(Uri.parse(url));
        if(response.statusCode==200)
          break;
      }



      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['items'].isEmpty) {
          emit(YoutubeError('No video details found.'));
          return;
        }

        final videoData = data['items'][0];
        final snippet = videoData['snippet'];
        final contentDetails = videoData['contentDetails'];

        final videoDetails = VideoDetails(
          title: snippet['title'] ?? 'No title available',
          channelTitle: snippet['channelTitle'] ?? 'No channel title available',
          description: snippet['description'] ?? 'No description available',
          duration: _convertDuration(contentDetails['duration'] ?? 'PT0S'), // Convert ISO 8601 duration
          videoUrl: 'https://www.youtube.com/watch?v=${video.videoid}', // Correct video URL format
        );

        emit(YoutubeVideoDetailsLoaded(videoDetails));
      } else {
        emit(YoutubeError('Failed to fetch video details: ${response.statusCode}'));
      }
    } catch (e) {
      emit(YoutubeError('An error occurred: $e'));
    }
  }

  String _convertDuration(String isoDuration) {
    // Converts ISO 8601 duration (e.g., PT15M33S) to a readable format or seconds
    final regex = RegExp(r'PT(\d+H)?(\d+M)?(\d+S)?');
    final matches = regex.firstMatch(isoDuration);

    if (matches == null) return '0:00';

    final hours = matches.group(1) != null
        ? int.parse(matches.group(1)!.replaceAll('H', ''))
        : 0;
    final minutes = matches.group(2) != null
        ? int.parse(matches.group(2)!.replaceAll('M', ''))
        : 0;
    final seconds = matches.group(3) != null
        ? int.parse(matches.group(3)!.replaceAll('S', ''))
        : 0;

    return '${hours > 0 ? '$hours:' : ''}${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }


  Future<void> _onFetchPlaylistEvent(FetchPlaylistEvent event,Emitter<YoutubeState> emit)async
  {
    String? nextPageToken = event.nextPageToken;
    String searchtopic=event.searchTopic;
    emit(YoutubeLoading());

    try {
      late String url;
      var response;
      if(nextPageToken != null && nextPageToken.isNotEmpty && nextPageToken != '')
      {
        for(String apikey in API_KEY)
        {
          url =
          'https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=5&q=$searchtopic&type=playlist&pageToken=$nextPageToken&key=$apikey';
          response = await http.get(Uri.parse(url));
          if(response.statusCode==200)
            break;
        }

      }
      else
      {
        for(String apikey in API_KEY)
        {
          url =
          'https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=5&q=$searchtopic&type=playlist&key=$apikey';
          response = await http.get(Uri.parse(url));
          if(response.statusCode==200)
            break;
        }

      }


      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List videos = data['items'];
        final nextpagetoken=data['nextPageToken'];

        // Extract detailed video information
        final videoDetails = videos.map((video) {
          final snippet = video['snippet'];
          final playlistid=video['id']['playlistId'];

          return Playlist(
              playlistId: playlistid,
              nextPageToken: nextpagetoken,
              description: snippet['description'],
              title: snippet['title'],
              channelId: snippet['channelId'],
              thumbnails: snippet['thumbnails']['high']['url'],
           );
        }).toList();

        emit(YoutubePlaylistLoaded(videoDetails));
      } else {
        emit(YoutubeError('Failed to fetch videos: ${response.statusCode}'));
      }
    } catch (e) {
      emit(YoutubeError('An error occurred: $e'));
    }
  }

  Future<void>  _onFetchPlaylistVideoDetailsEvent(FecthPlaylistVideoDetailsEvent event,Emitter<YoutubeState> emit)async
  {
    emit(YoutubeLoading());

    try {
      print("============> Fetch video function is called...");

      final video = event.video;
      final nextPageToken=event.nextPageToken;
      String url = '';
     var response;
      print("==========>> ${event.video.playlistId} <<====================");
      if(nextPageToken != null &&nextPageToken.isNotEmpty && nextPageToken != '')
        {
          for(String apikey in API_KEY)
          {
            url="https://www.googleapis.com/youtube/v3/playlistItems?part=snippet,contentDetails&pageToken=${nextPageToken}&playlistId=${video.playlistId}&maxResults=10&key=${apikey}";
            response = await http.get(Uri.parse(url));
            if(response.statusCode==200)
              break;
          }
        }
       else
         {
           for(String apikey in API_KEY)
           {
             url="https://www.googleapis.com/youtube/v3/playlistItems?part=snippet,contentDetails&playlistId=${video.playlistId}&maxResults=10&key=${apikey}";
             response = await http.get(Uri.parse(url));
             if(response.statusCode==200)
               break;
           }

         }


      if (response.statusCode == 200) {

        print("==============>>>response is getter ${response.statusCode}<<================");
        final data = json.decode(response.body);

        if (data['items'].isEmpty) {
          emit(YoutubeError('No video details found.'));
          return;
        }

        // Create a list to store the videos
        List<PlaylistvideoDetails> videos = [];

        // Parse each video item
        data['items'].forEach((videoData) {
          final snippet = videoData['snippet'];
          final contentDetails = videoData['contentDetails'];

          // Extract video details for each item
          PlaylistvideoDetails videoDetails = PlaylistvideoDetails(
            nextPageToken: data['nextPageToken'] ?? '', // Make sure to handle the nextPageToken
            channelId: snippet['channelId'] ?? 'No channel ID available',
            title: snippet['title'] ?? 'No title available',
            description: snippet['description'] ?? 'No description available',
            channelTitle: snippet['channelTitle'] ?? 'No channel title available',
            playlistId: snippet['playlistId'] ?? 'No playlist ID available',
            videoId: contentDetails['videoId'] ?? 'No video ID available',
            thumbnails: snippet['thumbnails']['high']['url'] ?? '', // Use high-resolution thumbnail
          );

          // Add the video details to the list
          videos.add(videoDetails);
        });

        // Emit the loaded state with the list of video details
        emit(YoutubePlaylistDetailsLoaded(videos));
      } else {
        emit(YoutubeError('Failed to fetch video details.'));
      }

    } catch (e) {
      emit(YoutubeError('An error occurred: $e'));
    }
  }


  Future<void> _onFetchChannels(
      FetchChannelEvent event, Emitter<YoutubeState> emit) async {
    String? nextPageToken = event.nextPageToken;
    String searchtopic=event.searchTopic;
    emit(YoutubeLoading());

    try {
      late String url;
      var response;
      if(nextPageToken != null && nextPageToken.isNotEmpty && nextPageToken != '')
      {
        for(String apikey in API_KEY)
        {
          url ='https://www.googleapis.com/youtube/v3/search?part=snippet&type=channel&q=$searchtopic&maxResults=10&pageToken=$nextPageToken&key=$apikey';
          response = await http.get(Uri.parse(url));
          if(response.statusCode==200)
            break;
        }

      }
      else
      {
        for(String apikey in API_KEY)
        {
          url =
          'https://www.googleapis.com/youtube/v3/search?part=snippet&type=channel&q=$searchtopic&maxResults=10&key=$apikey';
          response = await http.get(Uri.parse(url));
          if(response.statusCode==200)
            break;
        }

      }


      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List videos = data['items'];
        final nextpagetoken=data['nextPageToken'];

        // Extract detailed video information
        final videoDetails = videos.map((video) {
          final snippet = video['snippet'];
          return Channel(
              thumbnails: snippet['thumbnails']['medium']['url'],
              nextPageToken: nextpagetoken,
              channelId: snippet['channelId'],
              title: snippet['title'],
              description: snippet['description'],
              channelTitle: snippet['channelTitle'],
          );
        }).toList();

        emit(YoutubeChannelLoaded(videoDetails));
      } else {
        emit(YoutubeError('Failed to fetch videos: ${response.statusCode}'));
      }
    } catch (e) {
      emit(YoutubeError('An error occurred: $e'));
    }
  }


}
