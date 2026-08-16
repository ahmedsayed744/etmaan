class AzkarModel {
  final int id;
  final String text;
  final int count;
  final String? source;

  const AzkarModel({
    required this.id,
    required this.text,
    required this.count,
    this.source,
  });

  factory AzkarModel.fromJson(Map<String, dynamic> json) {
    return AzkarModel(
      id: json['id'] as int,
      text: json['text'] as String,
      count: json['count'] as int,
      source: json['source'] as String?,
    );
  }
}