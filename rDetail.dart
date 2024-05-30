import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_markdown/flutter_markdown.dart'; // Import flutter_markdown

class rDetail extends StatelessWidget {
  final String recipeTitle;

  const rDetail({Key? key, required this.recipeTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          recipeTitle,
          style: const TextStyle(fontWeight: FontWeight.bold), // Make the title bold
        ),
        // You can also adjust the AppBar background color here if needed
      ),
      backgroundColor: const Color.fromARGB(255, 67, 54, 54), // Set the background color of the page
      body: FutureBuilder<String>(
        future: GPT('Give me the detailed recipe for the following food: '+recipeTitle+'. The string is going to be displayed to the user, so DO NOT INCLUDE ANY UNNECESSARY GREETINGS, just the details for the recipe (ingredient, portion, instruction, tips etc)'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            // Updated part to split the recipe into paragraphs and wrap each in a "text bubble"
            var paragraphs = snapshot.data?.split('\n\n') ?? [];
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: paragraphs.map((paragraph) => _buildTextBubble(paragraph, context)).toList(),
              ),
            );
          }
        },
      ),
    );
  }

Widget _buildTextBubble(String text, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08), 
        borderRadius: BorderRadius.circular(10), 
      ),
      child: MarkdownBody(
        data: text,
        styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
          p: const TextStyle(fontSize: 20, color: Colors.white), 
          listBullet: TextStyle(fontSize: 22, color: Colors.white), 
        ),
      ),
    ),
  );
}

  static Future<String> GPT(String message) async{
  List<Map<String,String>> pM = [];
  List<String> words = message.split(RegExp(r'\W+')).where((s) => s.isNotEmpty).toList();
  String iMessage = 'Given that I have '+words.length.toString()+' ingredients available, please provide me with a detailed recipe with complete steps and tips. DO NOT INCLUDE ANY UNNECESSARY WORDS IN YOUR RESPONSE, JUST GIVE THE PURE DATA AS A MULTILINE TEXT.';
      final sysMessage = {"role": "system", "content": iMessage};
      pM.add(sysMessage);

  final userMessage = {"role": "user", "content": message};
  pM.add(userMessage);

  const String url = 'https://api.openai.com/v1/chat/completions';
  const String apiKey = 'API-KKEY';
  final Map<String, String> headers = {
    'Authorization': 'Bearer $apiKey',
    'Content-Type': 'application/json',
  };

  final body = jsonEncode({
    'model': 'gpt-4-turbo-preview',
    'messages': pM,
    'max_tokens': 500,
    'temperature': 0.5,
  });

  try {
    final response = await http.post(Uri.parse(url), headers: headers, body: body);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print('API Response: ${jsonEncode(responseData)}'); // For debuggin
      final String result = responseData['choices'][0]['message']['content']?.trim() ?? "No response text found.";
      return result;
    } 
  } catch (e) {
    print('Exception caught: $e');
  }
  return '';
  }
  
}
