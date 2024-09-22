import 'package:equatable/equatable.dart';
import 'package:videohaven/serverlogic/youtube_state.dart';
abstract class YoutubeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

//for video
class FetchThumbnailsEvent extends YoutubeEvent {
  String searchTopic="business";
  String? nextPageToken;
  String? channelId;
  FetchThumbnailsEvent(
  {
     required this.nextPageToken,
    required this.searchTopic,
    required this.channelId,
  });

  @override
  List<Object> get props=>[searchTopic,nextPageToken??'',channelId??''];

}

class FetchVideoDetailsEvent extends YoutubeEvent {
  final Video video;

  FetchVideoDetailsEvent(this.video);

  @override
  List<Object> get props => [video];
}


//for playlist
class FetchPlaylistEvent extends YoutubeEvent
{
  String searchTopic='vlog';
  String? nextPageToken;
  FetchPlaylistEvent({
      required this.nextPageToken,
      required this.searchTopic,
     });
  @override
  List<Object> get props=>[searchTopic,nextPageToken??''];

}

class FetchPlaylistDetailsEvent extends YoutubeEvent
{
  Playlist video;
  FetchPlaylistDetailsEvent(this.video);
  @override
  List<Object> get props => [video];
}
class FecthPlaylistVideoDetailsEvent extends YoutubeEvent
{
  Playlist video;
  String? nextPageToken;
  FecthPlaylistVideoDetailsEvent(this.video,{this.nextPageToken=''});
  @override
  List<Object> get props=>[video,nextPageToken??''];
}

//for channel
class FetchChannelEvent extends YoutubeEvent
{
  String searchTopic='vlog';
  String? nextPageToken;
  FetchChannelEvent({
    required this.nextPageToken,
    required this.searchTopic,
  });
  @override
  List<Object> get props=>[searchTopic,nextPageToken??''];

}
class FetchChannelDetailsEvent extends YoutubeEvent
{
  String channelId;
  FetchChannelDetailsEvent(this.channelId);
  @override
  List<Object> get props => [channelId];
}

