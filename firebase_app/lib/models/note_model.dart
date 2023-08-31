class NoteModel {
  String id;
  String? text;
  String? title;

  NoteModel({required this.id, required this.text, required this.title});

  NoteModel.fromJson(Map<String, dynamic> json, this.id) {
    text = json["text"];
    title = json["title"];
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "text": text,
      "title": title,
    };
  }
}
