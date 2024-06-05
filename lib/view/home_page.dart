import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';
import 'package:stackoverflow_api_riverpod/model/question_model.dart';
import 'package:stackoverflow_api_riverpod/provider/data_provider.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class HomePage extends ConsumerWidget {
  HomePage({super.key});
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context, ref) {
    final _data = ref.watch(questionDataProvider);
    final String searchTerm = ref.watch(searchTermProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Stackoverflow Question'),
      ),
      body: Stack(
        children: [
          RiveAnimation.asset(
            'assets/new_file.riv',
            fit: BoxFit.cover,
          ),
          Positioned.fill(
              child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: SizedBox(),
          )),
          SafeArea(
            child: Container(
              margin: EdgeInsets.all(15),
              child: Column(
                children: [
                  Container(
                    child: SearchBar(
                      controller: searchController,
                      onChanged: (value) {
                        ref.read(searchTermProvider.notifier).state = value;
                      },
                      elevation: MaterialStatePropertyAll(1),
                      hintText: 'Search Question',
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _data.when(data: (_data) {
                    List<QuestionModel> questionList = _data
                        .where((question) => question.title!
                            .toLowerCase()
                            .contains(searchTerm.toLowerCase()))
                        .toList();

                    return Expanded(
                      child: RefreshIndicator(
                        onRefresh: () {
                          ref.read(searchTermProvider.notifier).state = '';
                          searchController.clear();
                          FocusScope.of(context).unfocus();
                          return ref.refresh(questionDataProvider.future);
                        },
                        child: ListView.builder(
                          itemCount: questionList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () async {
                                if (!await launchUrl(
                                  Uri.parse(questionList[index].url!),
                                )) {
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Something went wrong, try again')));
                                }
                              },
                              child: Container(
                                  margin: EdgeInsets.all(3),
                                  child: Card(
                                      color: Colors.blueGrey.withOpacity(0.3),
                                      child: Container(
                                        margin: EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 40,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    child: Image.network(
                                                        questionList[index]
                                                            .image!),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    questionList[index].name!,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18),
                                                  ),
                                                ),
                                                Icon(Icons
                                                    .reduce_capacity_outlined),
                                                Text(questionList[index]
                                                    .reputation!)
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              questionList[index].title!,
                                              style: TextStyle(),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Wrap(spacing: 10, children: [
                                              Icon(Icons.comment_outlined),
                                              Text(
                                                questionList[index].answer!,
                                              ),
                                              Icon(
                                                  Icons.remove_red_eye_rounded),
                                              Text(questionList[index].view!),
                                            ]),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            SizedBox(
                                              height: 50,
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: questionList[index]
                                                    .tags
                                                    .length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int indexx) {
                                                  var tags = questionList[index]
                                                      .tags[indexx];
                                                  return Card(
                                                    color: Colors.blueAccent
                                                        .withOpacity(0.5),
                                                    elevation: 4,
                                                    child: Container(
                                                        margin:
                                                            EdgeInsets.all(5),
                                                        child: Container(
                                                            margin:
                                                                EdgeInsets.all(
                                                                    3),
                                                            child: Text(tags
                                                                .toString()))),
                                                  );
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      ))),
                            );
                          },
                        ),
                      ),
                    );
                  }, error: (error, e) {
                    return Center(
                      child: Text(error.toString()),
                    );
                  }, loading: () {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  })
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
