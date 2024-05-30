import 'package:flutter/material.dart';
import 'package:hackathon_app/PageOne.dart';
import 'package:hackathon_app/PageTwo.dart';
import 'package:hackathon_app/PageThree.dart';
import 'package:hackathon_app/PageFour.dart';

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  bool isGridView = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Options'),
        actions: [
          IconButton(
            icon: Icon(isGridView ? Icons.swipe : Icons.grid_view),
            onPressed: () => setState(() => isGridView = !isGridView),
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 88, 75, 75),
      body: isGridView ? buildGridView() : buildPageView(),
    );
  }

  Widget buildGridView() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 4,
              offset: Offset(0, 3),
            ),
          ],
        ),
        width: 300,  // Box width
        height: 300, // Box height
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 20, // Space between rows
          crossAxisSpacing: 20, // Space between columns
          children: <Widget>[
            _circleButton(context, 'Ingredients', PageOne(), 'assets/ingredient.jpg'),
            _circleButton(context, 'Food', PageTwo(), 'assets/food4.jpg'),
            _circleButton(context, 'Tracker', PageThree(), 'assets/balance.jpg'),
            _circleButton(context, 'Resources', PageFour(), 'assets/res.jpg'),
          ],
        ),
      ),
    );
  }

  Widget buildPageView() {
    return PageView(
      children: <Widget>[
        _pageViewItem('What Ingredients do you have?', PageOne(), 'assets/ingredient.jpg'),
        _pageViewItem('What food do you want?', PageTwo(), 'assets/food4.jpg'),
        _pageViewItem('Check your daily diet', PageThree(), 'assets/balance.jpg'),
        _pageViewItem('Useful Websites', PageFour(), 'assets/res.jpg'),
      ],
    );
  }

  Widget _circleButton(BuildContext context, String label, Widget page, String imagePath) {
    double avatarRadius = 40;  // Circle avatar radius

    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => page)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            radius: avatarRadius,
            backgroundImage: AssetImage(imagePath),
          ),
          SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 0, 0, 0))),
        ],
      ),
    );
  }

  Widget _pageViewItem(String label, Widget page, String imagePath) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 100),
      child: Center(
        child: InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => page)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage(imagePath),
              ),
              SizedBox(height: 20),
              Text(label, style: TextStyle(fontSize: 18, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
