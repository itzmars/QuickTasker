

class Task {
  String content;
  String timeStamp;
  bool done;

  Task({required this.content, required this.timeStamp, required this.done});

  factory Task.froMap(Map task) {
    return Task(
        content: task["content"],
        timeStamp: task["timeStamp"],
        done: task["done"]); 
  }

  Map toMap() {
    return {
      "content": content,
      "timeStamp": timeStamp,
      "done": done,
    };
  }
}
