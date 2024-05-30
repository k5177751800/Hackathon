import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class PageFour extends StatefulWidget {
  @override
  _PageFourState createState() => _PageFourState();
}

class _PageFourState extends State<PageFour> {
  Color backgroundColor = Color.fromARGB(255, 67, 54, 54); // Initial background color

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Resources'),
        actions: [
          IconButton(
            icon: Icon(Icons.palette),
            onPressed: () {
              setState(() {
                // Toggle between two colors
                backgroundColor = backgroundColor == Colors.white ? Colors.lightBlue : Colors.white;
              });
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: backgroundColor, // Dynamic background color
          child: Column(
            children: [
              _sectionButton(context, "Food52", "https://www.food52.com/", 'assets/food52.jpg', "An online community for food lovers..."),
              _sectionButton(context, "Serious Eats", "https://www.seriouseats.com/", 'assets/serious.jpg', "A website offering a thorough approach to cooking..."),
              _sectionButton(context, "Allrecipes", "https://www.allrecipes.com/", 'assets/allrecipes.png', "A user-generated recipe site where thousands..."),
              _sectionButton(context, "Epicurious", "https://www.epicurious.com/", 'assets/epi.jpg', "Known for its expertly curated recipes and cooking guides..."),
              _sectionButton(context, "The Kitchn", "https://www.thekitchn.com/", 'assets/kitchn.png', "A daily food magazine on the Web celebrating life in the kitchen..."),
              _sectionButton(context, "Smitten Kitchen", "https://www.smittenkitchen.com/", 'assets/smi.jpg', "A popular food blog featuring uncomplicated, delicious recipes..."),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionButton(BuildContext context, String label, String url, String imagePath, String description) {
    return MouseRegion(
      onHover: (PointerHoverEvent event) {
        // Hover effect handled here
      },
      onExit: (PointerExitEvent event) {
        // Revert hover effect here
      },
      child: GestureDetector(
        onTap: () => _launchInBrowser(url),
        child: Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white, // Normal color
            borderRadius: BorderRadius.circular(15), // Optional: for rounded corners
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 10, offset: Offset(0, 2))],
          ),
          child: Column(
            children: [
              Image.asset(
                imagePath,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
              ),
              SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchInBrowser(String url) async {
  if (await canLaunch(url)) {
    await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    );
  } else {
    throw 'Could not launch $url';
  }
}

}