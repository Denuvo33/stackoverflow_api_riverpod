import 'dart:convert';
import 'package:http/http.dart';
import 'package:riverpod/riverpod.dart';
import 'package:stackoverflow_api_riverpod/model/question_model.dart';

class ApiServices {
  Future<List<QuestionModel>> fetchData() async {
    var responses = await get(Uri.parse(
        'https://api.stackexchange.com/2.3/questions?order=desc&sort=activity&site=stackoverflow'));
    try {
      if (responses.statusCode == 200) {
        final List result = jsonDecode(responses.body)['items'];
        return result.map((e) => QuestionModel.fromJson(e)).toList();
      } else {
        throw Exception(responses.reasonPhrase);
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}

final questionProvider = Provider<ApiServices>((ref) => ApiServices());
