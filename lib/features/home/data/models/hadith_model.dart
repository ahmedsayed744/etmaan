class HadithModel {
  final int id;
  final int bookId;
  final int chapterId;
  final String bookName;
  final String text;

  const HadithModel({
    required this.id,
    required this.bookId,
    required this.chapterId,
    required this.bookName,
    required this.text,
  });

  factory HadithModel.fromJson(Map<String, dynamic> json) {
    return HadithModel(
      id: json['id'] as int,
      bookId: json['bookId'] as int,
      chapterId: json['chapterId'] as int,
      bookName: json['bookName'] as String,
      text: json['text'] as String,
    );
  }
}