import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:siku/models/place_detail_response.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart' ;

Future<ChatCompletionResponse>  processPlaceDetailAI(Result placeDetail) async {

  final String openAiKey = dotenv.get('OPEN_AI_API_KEY');
  var headers = {
    'Authorization': 'Bearer $openAiKey',
    'Content-Type': 'application/json',
  };


  String reviews =  'These are the reviews \n ';
  int r = 1;



  if (placeDetail.reviews != null) {
    for ( var review in placeDetail.reviews!){
      reviews += 'Review $r:  ${review.text} \n';
      r++;
    }
  } else {
    reviews += 'No reviews available.';
  }


  String prompt =  """You are making the summary of the reviews of one restrauant.  
    This JSON file contains information about a specific restaurant. From the information provided, could you infer the cuisine nationality and the type of dishes the restaurant specializes in? If it's not possible to make an informed guess, kindly indicate with "N/A". Please be as accurate as possible when identifying the 'Cuisine Nationality' and 'Specialty Dishes'.
    Moreover, we'd appreciate a comprehensive summary that describes the ambiance of the restaurant, its strengths, and its weaknesses. Please avoid repeating information already mentioned in the previous sections.

    Your summary should enrich our understanding of the place. If the details provided are insufficient, feel free to augment them with plausible extrapolations while maintaining the integrity of the information.


    Please adhere to the following format for your response:

    Cuisine Nationality:
    Restaurant Type:
    Specialty Dishes:
    Strengths of the Restaurant:
    Areas for Improvement:
    Overall Summary of the Restaurant:
    """;


  var data = {
    'model': 'gpt-3.5-turbo',
    'messages': [{'role': 'system', 'content': prompt},
                {'role': 'user', 'content': reviews}],
    'temperature' : 0,
  };

  var body = json.encode(data);

  var response = await http.post(
    Uri.parse('https://api.openai.com/v1/chat/completions'),
    headers: headers,
    body: body,
  );
  final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
  final ChatCompletionResponse responseBody =
  ChatCompletionResponse.fromJson(jsonResponse);
  return responseBody;
}


class ChatCompletionResponse {
  final List<Choice> choices;

  ChatCompletionResponse({
    required this.choices,
  });

  factory ChatCompletionResponse.fromJson(Map<String, dynamic> json) {
    // final choicesList = json['choices'] as List<dynamic>;
    // final choices = choicesList.map((choice) => Choice.fromJson(choice)).toList();
    final choicesList = (json['choices'] as List<dynamic>?) ?? [];
    final choices = choicesList.map((choice) => Choice.fromJson(choice)).toList();

    return ChatCompletionResponse(
      choices: choices,
    );
  }
}

class Choice {
  final Message message;

  Choice({
    required this.message,
  });

  factory Choice.fromJson(Map<String, dynamic> json) {
    final message = Message.fromJson(json['message'] as Map<String, dynamic>);
    return Choice(message: message);
  }
}

class Message {
  final String role;
  final String content;

  Message({
    required this.role,
    required this.content,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    final role = json['role'] as String;
    final content = json['content'] as String;

    return Message(role: role, content: content);
  }
}

class RestaurantInfo {
  final String nationality;
  final String subCategory;
  final String suggestedMenu;
  final String goodSide;
  final String downside;
  final String summary;

  RestaurantInfo({
    required this.nationality,
    required this.subCategory,
    required this.suggestedMenu,
    required this.goodSide,
    required this.downside,
    required this.summary,
  });
}

Map<String, String> processText(String text) {
  // Extract sections using regular expressions
  final nationalityRegex = RegExp(r'Cuisine Nationality:\s*(.*)');
  final subCategoryRegex = RegExp(r'Restaurant Type:\s*(.*)');
  final suggestedMenuRegex = RegExp(r'Specialty Dishes:\s*(.*)');
  final goodSideRegex = RegExp(r'Strengths of the Restaurant:\s*(.*)');
  final downsideRegex = RegExp(r'Areas for Improvement:\s*(.*)');
  final summaryRegex = RegExp(r'Overall Summary of the Restaurant:\s*(.*)');

  // Extracted values
  final nationalityMatch = nationalityRegex.firstMatch(text);
  final subCategoryMatch = subCategoryRegex.firstMatch(text);
  final suggestedMenuMatch = suggestedMenuRegex.firstMatch(text);
  final goodSideMatch = goodSideRegex.firstMatch(text);
  final downsideMatch = downsideRegex.firstMatch(text);
  final summaryMatch = summaryRegex.firstMatch(text);

  // Process and use the extracted values
  final nationality = nationalityMatch?.group(1) ?? 'Not available';
  final subCategory =  subCategoryMatch?.group(1) ?? 'Not available';
  final suggestedMenu = suggestedMenuMatch?.group(1) ?? 'Not available';
  final goodSide = goodSideMatch?.group(1) ?? 'Not available';
  final downside = downsideMatch?.group(1) ?? 'Not available';
  final summary = summaryMatch?.group(1) ?? 'Not available';


  return {
    'Cuisines/Styles': nationality,
    'Restaurant Type' : subCategory,
    'Specialty Dishes': suggestedMenu,
    'Strengths of the Restaurant': goodSide,
    'Areas for Improvement': downside,
    'Overall Summary of the Restaurant': summary,
  };
}



