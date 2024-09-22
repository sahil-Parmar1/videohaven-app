


import 'package:flutter/material.dart';
import 'package:videohaven/screens/channels.dart';
import 'package:videohaven/screens/history.dart';
import 'package:videohaven/screens/home.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:videohaven/screens/playlist.dart';

class VideoHaven extends StatefulWidget {
  const VideoHaven({super.key});

  @override
  State<VideoHaven> createState() => _VideoHavenState();
}

class _VideoHavenState extends State<VideoHaven>  with AutomaticKeepAliveClientMixin{
  int _currentIndex = 0;

   @override
   bool get wantKeepAlive =>true;
   @override
   void initState()
   {
     super.initState();
     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
   }
   @override
   void dispose()
   {
     super.dispose();
     SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
   }
  final List<Widget> _pages = [
    Home(),
    //PlaylistScreen(topic: 'python'), // Replace with your Playlist screen
    Playlistscreen(),
   startchannel(), // Replace with your Channels screen
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.play_rectangle),
            label: 'Playlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_2),
            label: 'Channels',
          ),
        ],
      ),
    );
  }
}
