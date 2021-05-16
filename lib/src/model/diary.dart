class Diary {
  int id;
  String title;
  String text;
  String date;
  List tags;

  Diary({this.id, this.title, this.text, this.date, this.tags});

  factory Diary.fromJson(Map<String, dynamic> json) => Diary(
    id: json['id'],
    title: json['title'],
    text: json['text'],
    date: json['date'],
    tags: json['tags']
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'text': text,
    'date': date,
    'tags': tags
  };
}