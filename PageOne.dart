// page_one.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hackathon_app/rDetail.dart'; // Ensure this file and class are correctly implemented.

class ChatMessage {
  final String text;
  final bool isSentByMe;
  ChatMessage({required this.text, required this.isSentByMe});
}

class PageOne extends StatefulWidget {
  @override
  _PageOneState createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
  final TextEditingController _controller = TextEditingController();
  List<ChatMessage> _messages = [];
  List<Map<String, String>> prevM = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _promptInitialMessage();
      
    });
  }

  void _promptInitialMessage() {
    setState(() {
      _messages.add(ChatMessage(text: "What ingredients do you have?", isSentByMe: false));
    });
  }

  Future<void> _sendMessageToAPI(String message) async {

  List<String> words = message.split(RegExp(r'\W+')).where((s) => s.isNotEmpty).toList();
  String iMessage = 'Given that I have ['+words.length.toString()+'] ingredients available, please provide me with an array of food suggestions. DO NOT INCLUDE ANY UNNECESSARY WORDS IN YOUR RESPONSE, JUST GIVE THE PURE DATA. Please format the response as follows for consistency and easy data processing:';
      iMessage += "recipe_name_1,recipe_name_2, ... ,recipe_name_"+words.length.toString();
      final sysMessage = {"role": "assistant", "content": iMessage};
      prevM.add(sysMessage);

  final userMessage = {"role": "user", "content": message};
  prevM.add(userMessage);

  const String url = 'https://api.openai.com/v1/chat/completions';
  const String apiKey = 'API-KEY';
  final Map<String, String> headers = {
    'Authorization': 'Bearer $apiKey',
    'Content-Type': 'application/json',
  };

  final body = jsonEncode({
    'model': 'gpt-4-turbo-preview',
    'messages': prevM,
    'max_tokens': 500,
    'temperature': 0.5,
  });

  try {
    final response = await http.post(Uri.parse(url), headers: headers, body: body);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print('API Response: ${jsonEncode(responseData)}'); // For debugging
      
      final String result = responseData['choices'][0]['message']['content']?.trim() ?? "No response text found.";
      final List<String> suggestions = result.isNotEmpty ? result.split(',').map((s) => s.trim()).toList() : [];
      final reMessage = {"role": "assistant", "content": result};
      prevM.add(reMessage);
      if (suggestions.isNotEmpty) {
        setState(() {
          _messages.add(ChatMessage(text: message, isSentByMe: true));
          _showSuggestions(suggestions);
        });
      } else {
        setState(() {
          _messages.add(ChatMessage(text: result, isSentByMe: false));
        });
      }
    } else {
      _showError('Server returned an error: ${response.statusCode}');
    }
  } catch (e) {
    _showError('Exception caught: $e');
  }
}

  void _showSuggestions(List<String> suggestions) {
    showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        child: Wrap(
          spacing: 8.0, // Gap between chips
          runSpacing: 4.0, // Gap between lines
          children: suggestions.map((suggestion) => ActionChip(
                label: Text(suggestion),
                onPressed: () {
                  Navigator.pop(context); // Close the modal bottom sheet
                  _navigateToDetailPage(suggestion);
                },
              )).toList(),
        ),
      );
    },
  );
  }

  void _navigateToDetailPage(String suggestion) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => rDetail(recipeTitle: suggestion), // Ensure rDetail is implemented to handle the recipeTitle
      ),
    );
  }

  void _showError(String error) {
    setState(() {
      _messages.add(ChatMessage(text: 'Error: $error', isSentByMe: false));
    });
  }

  @override
  /*
Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recipe Suggestions"),
      ),
      backgroundColor: Color.fromARGB(255, 88, 75, 75),

      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return ListTile(
                  title: Align(
                    alignment: msg.isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: msg.isSentByMe ? Colors.blue : Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        msg.text,
                        style: TextStyle(
                          fontWeight: FontWeight.bold, // Make text bold
              
                          color: msg.isSentByMe ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Enter ingredients',
                      labelStyle: TextStyle(
                      color: Colors.white, // Make label text color white
                    ),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // Border color
                    ),
                    onSubmitted: (value) { // Optionally handle submission via keyboard
                      if (value.isNotEmpty) {
                        _sendMessageToAPI(value);
                        _controller.clear();
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      _sendMessageToAPI(_controller.text);
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  */
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Recipe Suggestions"),
    ),
      backgroundColor: Color.fromARGB(255, 88, 75, 75),
    body: Column(
      children: <Widget>[
        Expanded(
         child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return ListTile(
                  title: Align(
                    alignment: msg.isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: msg.isSentByMe ? Colors.blue : Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        msg.text,
                        style: TextStyle(
                          //fontWeight: FontWeight.bold, // Make text bold
              
                          color: msg.isSentByMe ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: TextStyle(
                    fontWeight: FontWeight.bold, // Make text bold
                    color: Colors.white, // Make text color white (applies to input text)
                  ),
                  decoration: InputDecoration(
                    labelText: 'Enter ingredients',
                    labelStyle: TextStyle(
                      color: Colors.white, // Make label text color white
                    ),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // Border color
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // Border color when the TextField is focused
                    ),
                    hintStyle: TextStyle(color: Colors.white), // Make placeholder text color white
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send, color: Colors.white), // Optionally, change the send icon color to white
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    _sendMessageToAPI(_controller.text);
                    _controller.clear();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
}