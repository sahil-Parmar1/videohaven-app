// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'youtube_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VideoAdapter extends TypeAdapter<Video> {
  @override
  final int typeId = 0;

  @override
  Video read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Video(
      title: fields[0] as String,
      channelTitle: fields[1] as String,
      description: fields[2] as String,
      thumbnailUrl: fields[3] as String,
      videoid: fields[6] as String,
      nextPageToken: fields[7] as String,
      time: fields[4] as DateTime?,
      videoUrl: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Video obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.channelTitle)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.thumbnailUrl)
      ..writeByte(4)
      ..write(obj.time)
      ..writeByte(5)
      ..write(obj.videoUrl)
      ..writeByte(6)
      ..write(obj.videoid)
      ..writeByte(7)
      ..write(obj.nextPageToken);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PlaylistAdapter extends TypeAdapter<Playlist> {
  @override
  final int typeId = 1;

  @override
  Playlist read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Playlist(
      playlistId: fields[0] as String,
      nextPageToken: fields[4] as String,
      description: fields[3] as String,
      title: fields[5] as String,
      channelId: fields[1] as String,
      thumbnails: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Playlist obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.playlistId)
      ..writeByte(1)
      ..write(obj.channelId)
      ..writeByte(2)
      ..write(obj.thumbnails)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.nextPageToken)
      ..writeByte(5)
      ..write(obj.title);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaylistAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChannelDetailsAdapter extends TypeAdapter<ChannelDetails> {
  @override
  final int typeId = 2;

  @override
  ChannelDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChannelDetails(
      description: fields[1] as String,
      thumbnails: fields[2] as String,
      title: fields[0] as String,
      channelId: fields[3] as String,
      subscriberCount: fields[5] as String,
      videoCount: fields[6] as String,
      viewCount: fields[4] as String,
      isfollow: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ChannelDetails obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.thumbnails)
      ..writeByte(3)
      ..write(obj.channelId)
      ..writeByte(4)
      ..write(obj.viewCount)
      ..writeByte(5)
      ..write(obj.subscriberCount)
      ..writeByte(6)
      ..write(obj.videoCount)
      ..writeByte(7)
      ..write(obj.isfollow);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChannelDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
