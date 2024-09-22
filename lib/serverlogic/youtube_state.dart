import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:videohaven/screens/videoview.dart';
part 'youtube_state.g.dart';
// Define a class to hold video details

//for videos
@HiveType(typeId: 0)
class Video {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String channelTitle;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final String thumbnailUrl;
  @HiveField(4)
  DateTime? time;
  @HiveField(5)
  String? videoUrl;
  @HiveField(6)
  String videoid;
  @HiveField(7)
  String nextPageToken;


  Video({
    required this.title,
    required this.channelTitle,
    required this.description,
    required this.thumbnailUrl,
    required this.videoid,
    required this.nextPageToken,
    this.time,
    this.videoUrl,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Video &&
        other.title == title &&
        other.description == description &&
        other.thumbnailUrl == thumbnailUrl &&
        other.videoid == videoid &&
        other.nextPageToken == nextPageToken &&
        other.channelTitle == channelTitle ;
  }

  // Override hashCode to match the equality logic
  @override
  int get hashCode {
    return title.hashCode ^
    description.hashCode ^
    thumbnailUrl.hashCode ^
    videoid.hashCode ^
    nextPageToken.hashCode ^
    channelTitle.hashCode;
  }
}
@immutable
abstract class YoutubeState {}

class YoutubeInitial extends YoutubeState {}

class YoutubeLoading extends YoutubeState {}

class YoutubeLoaded extends YoutubeState {
  final List<Video> videos;

  YoutubeLoaded(this.videos);
}

class YoutubeError extends YoutubeState {
  final String message;

  YoutubeError(this.message);
}

class YoutubeVideoDetailsLoaded extends YoutubeState {
  final VideoDetails videoDetails;

  YoutubeVideoDetailsLoaded(this.videoDetails);
}











//for playlist
class PlaylistvideoDetails
{
  String nextPageToken;
  String channelId;
  String title;
  String description;
  String channelTitle;
  String playlistId;
  String videoId;
  String thumbnails;
  PlaylistvideoDetails({
    required this.nextPageToken,
    required this.channelId,
    required this.title,
    required this.description,
    required this.channelTitle,
    required this.playlistId,
    required this.videoId,
    required this.thumbnails,
  });
}
class YoutubePlaylistDetailsLoaded extends YoutubeState {
  List<PlaylistvideoDetails> videos;

  YoutubePlaylistDetailsLoaded(this.videos);
}

@HiveType(typeId: 1)
class Playlist
{
  @HiveField(0)
  String playlistId;
  @HiveField(1)
  String channelId;
  @HiveField(2)
  String thumbnails;
  @HiveField(3)
  String description;
  @HiveField(4)
  String nextPageToken;
  @HiveField(5)
  String title;

  Playlist({
    required this.playlistId,
    required this.nextPageToken,
    required this.description,
    required this.title,
    required this.channelId,
    required this.thumbnails,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Playlist &&
        other.title == title &&
        other.description == description &&
        other.thumbnails == thumbnails &&
        other.channelId == channelId &&
        other.nextPageToken == nextPageToken &&
        other.playlistId == playlistId;
  }

  // Override hashCode to match the equality logic
  @override
  int get hashCode {
    return title.hashCode ^
    description.hashCode ^
    thumbnails.hashCode ^
    channelId.hashCode ^
    nextPageToken.hashCode ^
    playlistId.hashCode;
  }

}
class YoutubePlaylistLoaded extends YoutubeState
{
  List<Playlist> videos;

  YoutubePlaylistLoaded(this.videos);
}


//for channels


class Channel
{
  String nextPageToken;
  String channelId;
  String title;
  String description;
  String thumbnails;
  String channelTitle;
  Channel({
    required this.thumbnails,
    required this.nextPageToken,
    required this.channelId,
    required this.title,
    required this.description,
    required this.channelTitle,
  });
}

@HiveType(typeId: 2)
class ChannelDetails {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  String thumbnails;

  @HiveField(3)
  String channelId;

  @HiveField(4)
  String viewCount;

  @HiveField(5)
  String subscriberCount;

  @HiveField(6)
  String videoCount;

  @HiveField(7)
  bool isfollow;

  ChannelDetails({
    required this.description,
    required this.thumbnails,
    required this.title,
    required this.channelId,
    required this.subscriberCount,
    required this.videoCount,
    required this.viewCount,
    this.isfollow = false,
  });

  // Override the equality operator for property-based comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChannelDetails &&
        other.title == title &&
        other.description == description &&
        other.thumbnails == thumbnails &&
        other.channelId == channelId &&
        other.viewCount == viewCount &&
        other.subscriberCount == subscriberCount &&
        other.videoCount == videoCount &&
        other.isfollow == isfollow;
  }

  // Override hashCode to match the equality logic
  @override
  int get hashCode {
    return title.hashCode ^
    description.hashCode ^
    thumbnails.hashCode ^
    channelId.hashCode ^
    viewCount.hashCode ^
    subscriberCount.hashCode ^
    videoCount.hashCode ^
    isfollow.hashCode;
  }
}



class YoutubeChannelLoaded extends YoutubeState
{
  List<Channel> channels;
  YoutubeChannelLoaded(this.channels);
}
class ChannelDetailsLoaded extends YoutubeState
{
  ChannelDetails channel;
  ChannelDetailsLoaded(this.channel);
}

