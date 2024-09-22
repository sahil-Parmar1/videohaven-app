import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:videohaven/videoHaven.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  final _key=GlobalKey<FormState>();
  bool _isshow=true;

  // Function to handle email/password sign up
  Future<void> _signUpWithEmail() async {
    setState(() {
      _loading = true;
    });
    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Fluttertoast.showToast(
        msg: "Sign up successful!${_emailController.text}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      SharedPreferences pref=await SharedPreferences.getInstance();
      pref.setBool('login', true);
      pref.setString('email', _emailController.text);
      Navigator.pushReplacement(context,
      CupertinoPageRoute(builder: (context)=>VideoHaven())
      );

    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
        msg: e.message ?? 'Error signing up!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
    setState(() {
      _loading = false;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                    ClipRRect(
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue,
                          blurRadius: 8.0,
                          spreadRadius: 2.0,
                          offset: Offset(0, 2), // Shadow position
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/logo.png',
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    // Simple regex for email validation
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  controller: _emailController,
                  style: TextStyle(color: Colors.white), // Text color for input
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.blueAccent[100]), // Softer blue label
                    filled: true,
                    fillColor: Colors.black, // Dark background matching the theme
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12), // Rounded corners
                      borderSide: BorderSide.none, // Remove default border
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.purpleAccent, // Accent color when focused
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey[700]!, // Neutral border when not focused
                        width: 1.5,
                      ),
                    ),
                    prefixIcon: Icon(Icons.email_outlined, color: Colors.blueAccent[100]), // Icon fitting the theme
                    contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20), // Padding for text and icon
                  ),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                  controller: _passwordController,
                  obscureText: _isshow, // Hide the password
                  style: TextStyle(color: Colors.white), // Text color for input
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.blueAccent[100]), // Light blue label color
                    filled: true,
                    fillColor: Colors.black, // Dark background
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12), // Rounded corners
                      borderSide: BorderSide.none, // Remove default border
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.purpleAccent, // Highlighted border when focused
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey[700]!, // Border when not focused
                        width: 1.5,
                      ),
                    ),
                    prefixIcon: Icon(Icons.lock_outline, color: Colors.blueAccent[100]), // Lock icon
                    suffixIcon: IconButton(
                      icon: _isshow?Icon(Icons.visibility_off, color: Colors.blueAccent[100]):Icon(Icons.visibility, color: Colors.blueAccent[100]), // Icon to toggle password visibility
                      onPressed: () {
                        // Logic to toggle obscureText (password visibility)
                         setState(() {
                           _isshow=!_isshow;
                         });
                      },
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20), // Padding for text and icons
                  ),
                ),

                SizedBox(height: 20),
                ElevatedButton(
                  onPressed:(){
                    if(!_loading)
                      {
                        if(_key.currentState!.validate())
                        {
                          _signUpWithEmail();

                        }
                      }


                  } ,
                  child: _loading?Container(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator()):Text('Sign Up',style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                ),
                SizedBox(height: 20,),
                TextButton(onPressed: (){
                  Navigator.pop(context);
                  Navigator.push(context,
                  CupertinoPageRoute(builder: (context)=>SignInScreen())
                  );
                }, child: Text("Alread sing in?click"))

              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  final _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  final _key=GlobalKey<FormState>();
  bool _isshow=true;

  // Function to handle email/password sign in
  Future<void> _signInWithEmail() async {
    setState(() {
      _loading = true;
    });
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Fluttertoast.showToast(
        msg: "Welcome back ${_emailController.text}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      SharedPreferences pref=await SharedPreferences.getInstance();
      pref.setBool('login', true);
      pref.setString('email', _emailController.text);
      Navigator.pushReplacement(context,
          CupertinoPageRoute(builder: (context)=>VideoHaven())
      );

    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
        msg: e.message ?? 'Error signing in!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20), // Rounded corners
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue,
                              blurRadius: 8.0,
                              spreadRadius: 2.0,
                              offset: Offset(0, 2), // Shadow position
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/logo.png',
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    // Simple regex for email validation
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  controller: _emailController,
                  style: TextStyle(color: Colors.white), // Text color for input
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.blueAccent[100]), // Softer blue label
                    filled: true,
                    fillColor: Colors.black, // Dark background matching the theme
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12), // Rounded corners
                      borderSide: BorderSide.none, // Remove default border
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.purpleAccent, // Accent color when focused
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey[700]!, // Neutral border when not focused
                        width: 1.5,
                      ),
                    ),
                    prefixIcon: Icon(Icons.email_outlined, color: Colors.blueAccent[100]), // Icon fitting the theme
                    contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20), // Padding for text and icon
                  ),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                  controller: _passwordController,
                  obscureText: _isshow, // Hide the password
                  style: TextStyle(color: Colors.white), // Text color for input
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.blueAccent[100]), // Light blue label color
                    filled: true,
                    fillColor: Colors.black, // Dark background
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12), // Rounded corners
                      borderSide: BorderSide.none, // Remove default border
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.purpleAccent, // Highlighted border when focused
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey[700]!, // Border when not focused
                        width: 1.5,
                      ),
                    ),
                    prefixIcon: Icon(Icons.lock_outline, color: Colors.blueAccent[100]), // Lock icon
                    suffixIcon: IconButton(
                      icon: _isshow?Icon(Icons.visibility_off, color: Colors.blueAccent[100]):Icon(Icons.visibility, color: Colors.blueAccent[100]), // Icon to toggle password visibility
                      onPressed: () {
                        // Logic to toggle obscureText (password visibility)
                        setState(() {
                          _isshow=!_isshow;
                        });
                      },
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20), // Padding for text and icons
                  ),
                ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: (){
                          if(!_loading)
                            {
                              if(_key.currentState!.validate())
                              {
                                _signInWithEmail();
                              }
                            }


                        },
                        child: _loading?Container(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator()):Text('Sign In',style: TextStyle(color: Colors.white),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        ),
                      ),
                      SizedBox(height: 20,),
                      TextButton(onPressed: (){
                        Navigator.pop(context);
                        Navigator.push(context,
                            CupertinoPageRoute(builder: (context)=>SignUpScreen())
                        );
                      }, child: Text("Does not have account?click"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
