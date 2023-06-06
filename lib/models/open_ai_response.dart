import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:siku/models/place_detail_response.dart';
import '../constants.dart';

Future<ChatCompletionResponse>  processPlaceDetailAI(Result placeDetail) async {
  var headers = {
    'Authorization': 'Bearer $openAiKey',
    'Content-Type': 'application/json',
  };


  String prompt = 'Place Name: ${placeDetail.name != null ? placeDetail.name! : 'Not available'}\n'
      'Formatted Address: ${placeDetail.formattedAddress ?? 'Not available'}\n'
      // 'Coordinates: Latitude - ${placeDetail.geometry?.location?.lat ?? 'Not available'}, Longitude - ${placeDetail.geometry?.location?.lng ?? 'Not available'}\n'
      // 'Opening Hours: ${placeDetail.weekdayText?.join(', ') ?? 'Not available'}\n'
      'Rating: ${placeDetail.rating ?? 'Not available'}\n'
      'Editorial Summary: ${placeDetail.editorialSummary?.overview ?? 'Not available'}\n'
      'Price Level: ${placeDetail.priceLevel ?? 'Not available'}\n'
      'Reservable: ${placeDetail.reservable ?? 'Not available'}\n'
      'Types: ${placeDetail.types?.join(', ') ?? 'Not available'}\n'
      'User Ratings Total: ${placeDetail.userRatingsTotal ?? 'Not available'}\n'
      'Website: ${placeDetail.website ?? 'Not available'}\n';

  String reviews = 'Reviews:\n';


  if (placeDetail.reviews != null) {
    for ( var review in placeDetail.reviews!){
      reviews += 'Review - ${review.text}, Rating - ${review.rating}\n';
      print(review.rating);
    }
  } else {
    reviews += 'No reviews available.';
  }

  prompt += reviews;

  prompt +=  """
  
  
This is json file about some restaurant. Can you guess the what is the nationality of this restaurant’ food is and what are the menu they are focusing on. 
If you can not guess what is the answer then please leave it as N/A. Be precise on the 'Nationality of Restaurant' and 'Suggested Menu'.
Can you give some summary that explains on what kind of this place is and atmosphere of this place and what are the good thing and bad things of this place?
 In the summary try to avoid the information provided in the section prior. 
 Please provide detailed information and if information is not enough, add your own rich details and go beyond the obvious within correct information.

Answer should follow bellow format.

Nationality of Restaurant:
Sub-category of Restaurant:

Suggested Menu of Restaurant: 
Good Side of Restaurant: 
Downside Side of Restaurant: 

Overall Summary of Restaurant:""";

  // print(prompt);
  // print(placeDetail.placeId);
  var data = {
    'model': 'gpt-3.5-turbo',
    'messages': [{'role': 'user', 'content': prompt}],
    'max_tokens': 3000,
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
  print(responseBody.choices);
  print(response.statusCode);
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
  final nationalityRegex = RegExp(r'Nationality of Restaurant:\s*(.*)');
  final subCategoryRegex = RegExp(r'Sub-category of Restaurant:\s*(.*)');
  final suggestedMenuRegex = RegExp(r'Suggested Menu of Restaurant:\s*(.*)');
  final goodSideRegex = RegExp(r'Good Side of Restaurant:\s*(.*)');
  final downsideRegex = RegExp(r'Downside Side of Restaurant:\s*(.*)');
  final summaryRegex = RegExp(r'Overall Summary of Restaurant:\s*(.*)');

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


  // Return the extracted values as a class
//   return 'Nationality: $nationality\n'
//       'Suggested Menu: $suggestedMenu\n'
//       'Good Side: $goodSide\n'
//       'Downside: $downside\n'
//       'Summary: $summary';
// }
// Return the extracted values as a Map
  return {
    'Nationality': nationality,
    'Sub-Category' : subCategory,
    'Suggested Menu': suggestedMenu,
    'Good Side': goodSide,
    'Downside': downside,
    'Summary': summary,
  };
}



