import 'package:riverpod/riverpod.dart';
import 'package:stackoverflow_api_riverpod/model/question_model.dart';
import 'package:stackoverflow_api_riverpod/services/api_services.dart';

final questionDataProvider = FutureProvider<List<QuestionModel>>((ref) async {
  return ref.watch(questionProvider).fetchData();
});

final searchTermProvider = StateProvider((ref) => '');
