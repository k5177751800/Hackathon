// page_two.dart
//Suggestion
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_markdown/flutter_markdown.dart'; // Import flutter_markdown

class ChatMessage {
  final String text;
  final bool isSentByMe;

  ChatMessage({required this.text, required this.isSentByMe});
}

class PageTwo extends StatefulWidget {
  const PageTwo({Key? key}) : super(key: key);

  @override
  _PageTwoState createState() => _PageTwoState();
}

class _PageTwoState extends State<PageTwo> {

  final TextEditingController _controller = TextEditingController();
  List<ChatMessage> _messages = [];
  List<Map<String, String>> prevM = [];
  bool _isLoading = false; // Add this line


  @override
  void initState() {
    super.initState();
    // Automatically start the conversation with a message from ChatGPT
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _messages.add(ChatMessage(text: "What delicious food do you want me to make?", isSentByMe: false));
      });
    });
  }


  Future<void> _sendMessageToAPI(String message) async {
    // Add the user message to the conversation history
    setState(() {
    _isLoading = true; // Start loading
    });

  final userMessage = {"role": "user", "content": message};
    prevM.add({"role": "user", "content": message});

    final String hiddenContext = "This GPT suggests recipe based on the ingredients user inputs. "
      "Your Main Objectives = Your goal as an exceptional chef\n"
      "1. Overall Idea: This GPT is customized for cooking recipes, and providing nutritional information, including calorie information for each suggestion. It will get users' input on what they have in order to cook. "
      "The GPT is going to suggest a recipe for the meal based on the user's ingredients. This specific chat GPT is only specialized in cooking. "
      "Other than cooking, meals, recipes, etc, it will not have knowledge of it. It only specializes in food. The GPT is also going to show the "
      "nutrition amount of the food that is created. For nutrients show it in bullet points.\n"
      "If the user input's something other than food. GPT is going to suggest 5 different recipes to users"
      "2. Respond format: direct links, along with concise text, resonate with me. \n"
      "3. Tone: Maintain a professional tone, occasionally sprinkled with design jargon\n"
      "4. Resource References: Direct me to renowned recipe blogs or platforms for the latest insights.\n\n"
      "User asks: $message";
    
    const String url = 'https://api.openai.com/v1/chat/completions';
    const String apiKey = 'APIKEY'; // Insert your actual API key here
    const Map<String, String> headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'model': 'gpt-4-turbo-preview', // Update this model name if necessary
      'messages': prevM,
       'max_tokens': 500,
      'temperature': 0.5,
    });

  //   try {
  //   final response = await http.post(Uri.parse(url), headers: headers, body: body);

  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> responseData = jsonDecode(response.body);
  //     final String result = responseData['choices'][0]['message']['content'];

  //     setState(() {
  //       _messages.add(ChatMessage(text: message, isSentByMe: true));
  //       _messages.add(ChatMessage(text: result, isSentByMe: false));
  //       _isLoading = false; // Stop loading after response
  //     });
  //   } else {
  //     setState(() {
  //       _messages.add(ChatMessage(text: 'Error: Server returned an error status: ${response.statusCode}', isSentByMe: false));
  //       _isLoading = false; // Stop loading on error
  //     });
  //   }
  // } catch (e) {
  //   setState(() {
  //     _messages.add(ChatMessage(text: 'Error: Unable to process your request. Exception: $e', isSentByMe: false));
  //     _isLoading = false; // Stop loading on exception
  //   });
  //   }
  try {
    final response = await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      String result = responseData['choices'][0]['message']['content'];

      // Process the result to remove unwanted characters/patterns
      // Example: Removing multiple hashtags
      result = result.replaceAll(RegExp(r'#+'), ""); // Adjust RegExp according to your needs

      // Removing other unwanted patterns or characters
      // Example: If you want to remove repetitive newlines or trim whitespace
      result = result.replaceAll(RegExp(r'\n\n+'), "\n").trim();

      setState(() {
        _messages.add(ChatMessage(text: message, isSentByMe: true));
        _messages.add(ChatMessage(text: result, isSentByMe: false));
        _isLoading = false; // Stop loading after response
      });
    } else {
      setState(() {
        _messages.add(ChatMessage(text: 'Error: Server returned an error status: ${response.statusCode}', isSentByMe: false));
        _isLoading = false; // Stop loading on error
      });
    }
  } catch (e) {
    setState(() {
      _messages.add(ChatMessage(text: 'Error: Unable to process your request. Exception: $e', isSentByMe: false));
      _isLoading = false; // Stop loading on exception
    });
  }
  }
  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Chat with the Master Chef"),
    ),
    backgroundColor: const Color.fromARGB(255, 88, 75, 75),

    body: Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            itemCount: _isLoading ? _messages.length + 1 : _messages.length, // Adjusted for loading indicator
            itemBuilder: (context, index) {
              // Show loading indicator as the last item if _isLoading is true
              if (_isLoading && index == _messages.length) {
                return Center(child: CircularProgressIndicator());
              }
              // Message display logic for existing messages
              final msg = _messages[index];
              return ListTile(
                title: Align(
                  alignment: msg.isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: msg.isSentByMe ? Colors.grey[300] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    // child: Text(
                    //   msg.text,
                    //   style: TextStyle(
                    //     color: msg.isSentByMe ? Colors.white : Colors.black,
                    //   ),
                    // ), 
                    child: MarkdownBody(
                        data: msg.text,
                        styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                          p: const TextStyle(fontSize: 16, color: Colors.black),
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
            color: Colors.white, // Change input text color to white
            fontWeight: FontWeight.bold, // Make input text bolder
          ),
          decoration: InputDecoration(
            labelText: 'Enter your message',
            labelStyle: TextStyle(
              color: Colors.white, // Change label text color to white
            ),
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white), // Change border color to white
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white), // Optional: Change border color when focused
            ),
          ),
          cursorColor: Colors.white, // Optional: Change cursor color to white
        ),
      ),
      IconButton(
        icon: Icon(Icons.send, color: Colors.white), // Optional: Change send icon color to white
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



