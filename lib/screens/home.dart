import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:videohaven/screens/search.dart';
import 'package:videohaven/screens/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _searchController=TextEditingController();
  static List<String> topiclist=[];
  String topic='vlog';
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
    if(topiclist.isNotEmpty && topiclist!=[])
    topic=topiclist[0];
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return   CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Row(
            mainAxisAlignment: MainAxisAlignment.center, // Align items to the start
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Padding(
                padding: const EdgeInsets.only(right: 8.0), // Spacing between elements
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: CupertinoColors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/logo.png'), // Your logo image
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'VideoHaven', // Placeholder for text next to the logo
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis, // Handles long text gracefully
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  // Define your search action here
                Navigator.push(context,
                 MaterialPageRoute(builder: (context)=>Search())
                );
                },
                child: Icon(
                  CupertinoIcons.search, // Cupertino style search icon
                  color: Colors.white,

                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  // Define your search action here
                  Navigator.push(context,
                 CupertinoPageRoute(builder: (context)=>SettingsPage())
                  );
                },
                child: Icon(
                  CupertinoIcons.settings,
                  color: Colors.white,// Cupertino style search icon

                ),
              ),
            ],
          ),
          padding: EdgeInsetsDirectional.zero, // Reduce padding to keep everything aligned

        ),
        child: topiclist.length<1?_buildInitialScreen():Column(
          children: [
            SizedBox(
              height: 60,
              child: ListView.builder(
                  itemCount: topiclist.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context,index)
                  {
                    return GestureDetector(
                      onTap: (){
                        setState(() {
                          topic=topiclist[index];
                        });
                      },
                      child: Center(
                        child: Container(
                          height: 50,
                          decoration:BoxDecoration(
                            //color: Color(0xFF3B1C47), // Dark purple background color
                            color: CupertinoColors.darkBackgroundGray,
                              borderRadius: BorderRadius.circular(10), // Rounded corners for a pill-shaped look
                            boxShadow: [
                              BoxShadow(
                               // color: Color(0xFF4A266A), // Subtle shadow for depth
                                blurRadius: 8, // Softness of the shadow
                                offset: Offset(4, 4), // Offset in the x and y direction
                              ),
                            ],

                             border: Border(
                               right: BorderSide(
                                 color: Colors.purpleAccent, // Border color for the right side
                                 width: 1,
                               ),
                               bottom: BorderSide(
                                 color: Colors.purpleAccent, // Border color for the right side
                                 width: 1,
                               ),
                               top: BorderSide(
                                 color: Colors.purpleAccent, // Border color for the right side
                                 width: 0.1,
                               ),
                               left:  BorderSide(
                                 color: Colors.purpleAccent, // Border color for the right side
                                 width: 0.1,
                               ),
                             )
                          ),
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                          child: Text("${topiclist[index]}"),
                        ),
                      ),
                    );
                  }
              ),
            ),
           Expanded(child: SearchResult(topic: topic)),
           // Expanded(child: Container(child: Text("hello"),))
          ],
        ),
    );
  }
  Widget _buildInitialScreen(){
    return ListView(
      children: [
        SizedBox(height: 100,),
        Center(
            child:Column(
                mainAxisAlignment:MainAxisAlignment.center,
                children:[
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.5),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: Offset(4, 3),
                        )
                      ],
                      image: DecorationImage(image: NetworkImage("https://th.bing.com/th/id/OIP.0JFLmHhCEuaBz0XruSFJMQHaHa?rs=1&pid=ImgDetMain"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(100), // Optional: for rounded corners




                    ),
                  ),

                  SizedBox(height:20),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child:  TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: '    Start Searching Video....',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)
                        ),


                      ),
                      onSubmitted: (query)async{

                        SharedPreferences pref=await SharedPreferences.getInstance();
                        List<String> temp=pref.getStringList('History')??[];
                        if(!temp.contains(_searchController.text))
                          {
                            temp.add(_searchController.text);
                            pref.setStringList('History', temp);
                          }

                        // Navigator.push(context,
                        //  CupertinoPageRoute(builder: (context)=>SearchResult(topic: query))
                        //  );
                        loadlist();
                      },
                    ),
                  ),
                ]
            )
        ),
      ],
    );
  }
}

