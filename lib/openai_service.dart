import 'dart:convert';

import 'package:allen/secrets.dart';
import 'package:http/http.dart' as http;

class OpenAIService {


  // Future<String> isArtPromptAPI(String prompt) async {
  //   try {
  //     final res = await http.post(
  //       Uri.parse('https://api.openai.com/v1/chat/completions'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $openAIAPIKey',
  //       },
  //       body: jsonEncode({
  //         "model": "gpt-3.5-turbo",
  //         "messages": [
  //           {
  //             'role': 'user',
  //             'content':
  //                 'Does this message want to generate an AI picture, image, art or anything similar? $prompt . Simply answer with a yes or no.',
  //           }
  //         ],
  //       }),
  //     );
  //     print(res.body);
  //     if (res.statusCode == 200) {
  //       String content =
  //           jsonDecode(res.body)['choices'][0]['message']['content'];
  //       content = content.trim();

  //       switch (content) {
  //         case 'Yes':
  //         case 'yes':
  //         case 'Yes.':
  //         case 'yes.':
  //           final res = await dallEAPI(prompt);
  //           return res;
  //         default:
  //           final res = await chatGPTAPI(prompt);
  //           return res;
  //       }
  //     }
  //     print(jsonDecode(res.body)['error']['message']);
  //     if(res.statusCode == 429 && (jsonDecode(res.body)['error']['message']).contains('Please try again in 20s')){
  //       return 'Rate Limit Exceed. You can ask 3 questions per minute in free tier. To remove this limitation please purchase our premium pack for Rupees 200 per month';
  //     }
  //     return "error";
  //   } catch (e) {
  //     return e.toString();
  //   }
  // }
  final List<Map<String, String>> messages = [];
  Future<String> chatGPTAPI(String prompt) async {
    messages.add({
      'role': 'user',
      'content': prompt,
    });
    try {
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAIAPIKey',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": messages,
        }),
      );
      print(res.body);
      if (res.statusCode == 200) {
        String content =
            jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();

        messages.add({
          'role': 'assistant',
          'content': content,
        });
        return content;
      }
     print(jsonDecode(res.body)['error']['message']);
      if(res.statusCode == 429 && (jsonDecode(res.body)['error']['message']).contains('Please try again in 20s')){
        return 'Rate Limit Exceed. You can ask 3 questions per minute in free tier. To remove this limitation please purchase our premium pack for Rupees 200 per month';
      }
      return "An error occured with response code: ${res.statusCode}. Contact our Support team for more details";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> dallEAPI(String prompt) async {
    messages.add({
      'role': 'user',
      'content': prompt,
    });
    try {
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/images/generations'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAIAPIKey',
        },
        body: jsonEncode({
          'prompt': prompt,
          'n': 1,
        }),
      );
      print(res.body);
      if (res.statusCode == 200) {
        String imageUrl = jsonDecode(res.body)['data'][0]['url'];
        imageUrl = imageUrl.trim();

        messages.add({
          'role': 'assistant',
          'content': imageUrl,
        });
        return imageUrl;
      }
      return "An error occured with response code: ${res.statusCode}. Contact our Support team for more details";
    } catch (e) {
      return e.toString();
    }
  }
}