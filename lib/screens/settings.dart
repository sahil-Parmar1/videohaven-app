import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:videohaven/screens/history.dart';
import 'package:videohaven/screens/savedPlaylist.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String userEmail='';
  String videoq='';
  String getFirstLetter(String userEmail) {
    return userEmail.isNotEmpty ? userEmail[0].toUpperCase() : '';
  }

  @override
  void initState()
  {
   super.initState();
   loademail();
  }
  void loademail()async
  {
    SharedPreferences pref=await SharedPreferences.getInstance();
    userEmail=pref.getString('email')??'';
    videoq=pref.getString('quality')??'Auto';
  }
  Future<void> savevideoquality(String q)async
  {
    SharedPreferences pref=await SharedPreferences.getInstance();
    pref.setString('quality', q);
  }
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Settings'),
        backgroundColor: CupertinoColors.black,
      ),
      backgroundColor: CupertinoColors.systemGrey6,
      child: ListView(
        children: [
          _buildSectionTitle('General'),
          GestureDetector(
            onTap: (){
              showCupertinoModalPopup(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: 400,  // Adjust the height as needed
                    color: Color(0xFF1A0033),  // Dark purple background color
                    child: SingleChildScrollView( // Make the content scrollable
                      child: Column(
                        children: [
                          Container(
                            height: 60,
                            color: Color(0xFF4B0082),  // Darker shade of purple for the header
                            child: Center(
                              child: Text(
                                'Select Video Quality',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: CupertinoColors.white,  // White text
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),

                          CupertinoButton(
                            child: Text(
                              '144p',
                              style: TextStyle(color: CupertinoColors.white),
                            ),
                            onPressed: () async{
                              // Handle selection for 1080p
                              videoq='144p';
                              await savevideoquality('144p');
                              setState(() {});
                              Navigator.pop(context);
                            },
                            color: Color(0xFF800080), // Purple button for selection
                          ),
                          SizedBox(height: 10),
                          CupertinoButton(
                            child: Text(
                              '360p',
                              style: TextStyle(color: CupertinoColors.white),
                            ),
                            onPressed: () async{
                              // Handle selection for 1080p
                              videoq='360p';
                              await savevideoquality('360p');
                              setState(() {});
                              Navigator.pop(context);
                            },
                            color: Color(0xFF800080), // Purple button for selection
                          ),
                          SizedBox(height: 10),
                          CupertinoButton(
                            child: Text(
                              '720p',
                              style: TextStyle(color: CupertinoColors.white),
                            ),
                            onPressed: () async{
                              // Handle selection for 1080p
                              videoq='720p';
                              await savevideoquality('720p');
                              setState(() {});
                              Navigator.pop(context);
                            },
                            color: Color(0xFF800080), // Purple button for selection
                          ),
                          SizedBox(height: 10),
                          CupertinoButton(
                            child: Text(
                              '1080p',
                              style: TextStyle(color: CupertinoColors.white),
                            ),
                            onPressed: () async{
                              // Handle selection for 1080p
                              videoq='1080p';
                              await savevideoquality('1080p');
                              setState(() {});
                              Navigator.pop(context);
                            },
                            color: Color(0xFF800080), // Purple button for selection
                          ),
                          SizedBox(height: 10),
                          CupertinoButton(
                            child: Text(
                              'Auto',
                              style: TextStyle(color: CupertinoColors.white),
                            ),
                            onPressed: () async{
                              // Handle selection for 1080p
                              videoq='Auto';
                              await savevideoquality('Auto');
                              setState(() {});
                              Navigator.pop(context);
                            },
                            color: Color(0xFF800080), // Purple button for selection
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: _buildTile(
              context,
              icon: CupertinoIcons.video_camera_solid,
              title: 'Video Quality',
              trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {},
                child: Row(
                  children: [
                    Text(
                      '$videoq',
                      style: TextStyle(color: CupertinoColors.systemGrey),
                    ),
                    Icon(
                      CupertinoIcons.chevron_forward,
                      size: 18,
                      color: CupertinoColors.systemGrey,
                    ),
                  ],
                ),
              ),
            ),
          ),

          _buildSectionTitle('Account'),
          GestureDetector(
            onTap: (){
              showCupertinoModalPopup(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: 400,  // Adjust the height as needed
                    color: Color(0xFF1A0033),  // Dark purple background color
                    child: Column(
                      children: [
                        Container(
                          height: 60,
                          color: Color(0xFF4B0082),  // Darker shade of purple for the header
                          child: Center(
                            child: Text(
                              'User Profile',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: CupertinoColors.white,  // White text
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        // Circular logo with the first letter of the email
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Color(0xFF4B0082),  // Darker purple for avatar background
                          child: Text(
                            getFirstLetter(userEmail),
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: CupertinoColors.white,  // White letter
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          userEmail,  // Replace with the actual user's email
                          style: TextStyle(
                            fontSize: 16,
                            color: CupertinoColors.white,  // White text for email
                          ),
                        ),
                        SizedBox(height: 30),
                        CupertinoButton(
                          color: Color(0xFF800080),  // Purple color for the button
                          child: Text('Close',style: TextStyle(color: Colors.white),),
                          onPressed: () {
                            Navigator.pop(context);  // Close the bottom sheet
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: _buildTile(
              context,
              icon: CupertinoIcons.person,
              title: 'Profile',
              trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 400,  // Adjust the height as needed
                        color: Color(0xFF1A0033),  // Dark purple background color
                        child: Column(
                          children: [
                            Container(
                              height: 60,
                              color: Color(0xFF4B0082),  // Darker shade of purple for the header
                              child: Center(
                                child: Text(
                                  'User Profile',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: CupertinoColors.white,  // White text
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            // Circular logo with the first letter of the email
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Color(0xFF4B0082),  // Darker purple for avatar background
                              child: Text(
                                getFirstLetter(userEmail),
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: CupertinoColors.white,  // White letter
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              userEmail,  // Replace with the actual user's email
                              style: TextStyle(
                                fontSize: 16,
                                color: CupertinoColors.white,  // White text for email
                              ),
                            ),
                            SizedBox(height: 30),
                            CupertinoButton(
                              color: Color(0xFF800080),  // Purple color for the button
                              child: Text('Close',style: TextStyle(color: Colors.white),),
                              onPressed: () {
                                Navigator.pop(context);  // Close the bottom sheet
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Icon(
                  CupertinoIcons.chevron_forward,
                  size: 18,
                  color: CupertinoColors.systemGrey,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context)=>History())
              );
            },
            child: _buildTile(
              context,
              icon: CupertinoIcons.clock,
              title: 'History',
              trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context)=>History())
                  );
                },
                child: Icon(
                  CupertinoIcons.chevron_forward,
                  size: 18,
                  color: CupertinoColors.systemGrey,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context)=>savedPlaylist())
              );
            },
            child: _buildTile(
              context,
              icon: Icons.playlist_add_check,
              title: 'Saved Playlist',
              trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context)=>savedPlaylist())
                  );
                },
                child: Icon(
                  CupertinoIcons.chevron_forward,
                  size: 18,
                  color: CupertinoColors.systemGrey,
                ),
              ),
            ),
          ),
          _buildSectionTitle('About'),
          _buildTile(
            context,
            icon: CupertinoIcons.info,
            title: 'Version',
            trailing: Text(
              '1.0.0',
              style: TextStyle(color: CupertinoColors.systemGrey),
            ),
          ),
          GestureDetector(
            onTap: ()async{
              const instagramUrl = 'https://www.instagram.com/this_is_sahilparmar?igsh=MXI3NjFwam8xcGxpcQ==';
              if (await canLaunch(instagramUrl)) {
              await launch(instagramUrl);
              } else {
              throw 'Could not launch $instagramUrl';
              }
            },
            child: _buildTile(
              context,
              icon: CupertinoIcons.question_circle,
              title: 'Give me Feedback or advice',
              trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {},
                child: Icon(
                  CupertinoIcons.chevron_forward,
                  size: 18,
                  color: CupertinoColors.systemGrey,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              showCupertinoModalPopup(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: 400,  // Adjust the height as needed
                    color: Color(0xFF1A0033),  // Dark purple background color
                    child: Column(
                      children: [
                        Container(
                          height: 60,
                          color: Color(0xFF4B0082),  // Darker shade of purple for the header
                          child: Center(
                            child: Text(
                              'About the Developer',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: CupertinoColors.white,  // White text
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Sahil Parmar',  // Developer name
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: CupertinoColors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Mobile App Developer',  // Developer title or role
                          style: TextStyle(
                            fontSize: 16,
                            color: CupertinoColors.white,
                          ),
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                const instagramUrl = 'https://www.instagram.com/this_is_sahilparmar?igsh=MXI3NjFwam8xcGxpcQ==';
                                if (await canLaunch(instagramUrl)) {
                                  await launch(instagramUrl);
                                } else {
                                  throw 'Could not launch $instagramUrl';
                                }
                              },
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/instagram.png', // Replace with your Instagram icon path
                                    width: 40,
                                    height: 40,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Instagram',
                                    style: TextStyle(color: CupertinoColors.white),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 30),
                            GestureDetector(
                              onTap: () async {
                                const linkedinUrl = 'https://www.linkedin.com/in/sahil-parmar-6b2656306?lipi=urn%3Ali%3Apage%3Ad_flagship3_profile_view_base_contact_details%3BAdKApnBIQqWuA942r2r9fw%3D%3D'; // Replace with actual LinkedIn URL
                                if (await canLaunch(linkedinUrl)) {
                                  await launch(linkedinUrl);
                                } else {
                                  throw 'Could not launch $linkedinUrl';
                                }
                              },
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/linkedin.png', // Replace with your LinkedIn icon path
                                    width: 40,
                                    height: 40,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'LinkedIn',
                                    style: TextStyle(color: CupertinoColors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        CupertinoButton(
                          color: Color(0xFF800080),  // Purple color for the close button
                          child: Text('Close',style: TextStyle(color: Colors.white),),
                          onPressed: () {
                            Navigator.pop(context);  // Close the bottom sheet
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: _buildTile(
              context,
              icon: CupertinoIcons.device_desktop,
              title: 'About Developer',
              trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {},
                child: Icon(
                  CupertinoIcons.chevron_forward,
                  size: 18,
                  color: CupertinoColors.systemGrey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          color: CupertinoColors.systemGrey2,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTile(BuildContext context,
      {required IconData icon,
        required String title,
        required Widget trailing}) {
    return Container(
      color: CupertinoColors.darkBackgroundGray,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Row(
          children: [
            Icon(icon, color: CupertinoColors.systemGrey2, size: 28),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: CupertinoColors.white,
                ),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
