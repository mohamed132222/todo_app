class Task {
  static const String collectionName = "task";

  String? id;
  String? title;
  String? description;
  DateTime? date;
  bool? isDone;

  Task({
    this.id = "",
    required this.title,
    required this.description,
    required this.date,
    this.isDone = false,
  });

  Task.fromFireStore(Map<String, dynamic> data)
    : this(
        id: data['id'] as String?,
        title: data['title'] as String?,
        description: data['description'] as String?,
        date: DateTime.fromMillisecondsSinceEpoch(data['date']) as DateTime?,
        isDone: data['isDone'] as bool?,
      );

  Map<String, dynamic> toFireStore() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "date": date?.millisecondsSinceEpoch,
      "isDone": isDone,
    };
  }
}
