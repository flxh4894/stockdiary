class Memo {
  int id;
  String text;
  String date;
  int checkYn;

  Memo({this.id, this.text, this.checkYn, this.date});

  factory Memo.fromJson(Map<String, dynamic> json) => Memo(
    id: json['id'],
    text: json['text'],
    date: json['date'],
    checkYn: json['check_yn'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'text': text,
    'date': date,
    'checkYn': checkYn
  };

  Map<String, dynamic> toMapDb() => {
    'text': text,
    'date': date,
    'check_yn': checkYn
  };
}