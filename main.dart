import 'package:flutter/material.dart';
import 'package:hackathon_app/SecondPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Navigation Demo',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        elevation: 5, // Set elevation for the shadow effect
        color: Colors.white, // Set background color to white
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/finalfront.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              // Dark overlay
              Container(
                color: Colors.black.withOpacity(0.5), // Semi-transparent black
                width: double.infinity,
                height: double.infinity,
              ),
              // Title
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 150.0), // Adjust top padding as needed
                  child: Text(
                    'Easy Cook',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Content
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ... (other widgets like Text, SizedBox) ...

                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SecondPage()),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.symmetric(vertical: 15),
                          ),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          elevation: MaterialStateProperty.all<double>(5),
                        ),
                        child: Text('Get to Cooking', style: TextStyle(fontSize: 18)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
