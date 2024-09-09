class Message {
  final String sender;
  final DateTime time;
  final String text;
  final bool isLiked;
  final bool isSender;

  Message({
    required this.sender,
    required this.time,
    required this.text,
    required this.isLiked,
    required this.isSender,
  });

  //toJson and fromJson
  Map<String, dynamic> toJson() => {
    'sender': sender,
    'time': time.toIso8601String(),
    'text': text,
    'isLiked': isLiked,
    'isSender': isSender,
  };

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    sender: json['sender'],
    time: DateTime.parse(json['time']),
    text: json['text'],
    isLiked: json['isLiked'],
    isSender: json['isSender'],
  );
}