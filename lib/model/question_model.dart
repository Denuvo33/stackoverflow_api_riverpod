class QuestionModel {
  String? name, title, image, profile, view, url, answer, reputation;
  List<dynamic> tags;

  QuestionModel(
      {required this.image,
      required this.tags,
      required this.reputation,
      required this.answer,
      required this.name,
      required this.profile,
      required this.title,
      required this.url,
      required this.view});

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      reputation: json['owner']['reputation'].toString(),
      answer: json['answer_count'].toString(),
      name: json['owner']['display_name'],
      image: json['owner']['profile_image'],
      profile: json['owner']['link'],
      title: json['title'],
      url: json['link'],
      view: json['view_count'].toString(),
      tags: json['tags'],
    );
  }
}
