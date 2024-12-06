enum ImMessageType { text, image, audio, video }

class ImMessage {
  final String messageId;
  final int timestamp;
  final String userId;
  final String userType;
  final String sender;
  final String content;
  final ImMessageType type;
  final bool isRecalled;

  ImMessage({
    required this.messageId,
    required this.timestamp,
    required this.userId,
    required this.userType,
    required this.sender,
    required this.content,
    required this.type,
    this.isRecalled = false,
  });

  ImMessage copyWith({
    String? messageId,
    int? timestamp,
    String? userId,
    String? userType,
    String? sender,
    String? content,
    ImMessageType? type,
    bool? isRecalled,
  }) {
    return ImMessage(
      messageId: messageId ?? this.messageId,
      timestamp: timestamp ?? this.timestamp,
      userId: userId ?? this.userId,
      userType: userType ?? this.userType,
      sender: sender ?? this.sender,
      content: content ?? this.content,
      type: type ?? this.type,
      isRecalled: isRecalled ?? this.isRecalled,
    );
  }

  // 从 JSON 创建 ImMessage 对象
  factory ImMessage.fromJson(Map<String, dynamic> json) {
    return ImMessage(
      messageId: json['messageId'],
      timestamp: json['timestamp'],
      userId: json['userId'],
      userType: json['userType'],
      sender: json['userName'],
      content: json['message'],
      type: _parseMessageType(json['messageType']),
    );
  }

  // 将 ImMessage 对象转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
      'timestamp': timestamp,
      'userId': userId,
      'userType': userType,
      'userName': sender,
      'message': content,
      'messageType': _messageTypeToString(type),
    };
  }

  // 判断是否是自己的消息
  bool get isOwner => userType == 'owner';

  // 解析消息类型
  static ImMessageType _parseMessageType(String type) {
    switch (type.toLowerCase()) {
      case 'text':
        return ImMessageType.text;
      case 'image':
        return ImMessageType.image;
      case 'audio':
        return ImMessageType.audio;
      case 'video':
        return ImMessageType.video;
      default:
        return ImMessageType.text;
    }
  }

  // 将消息类型转换为字符串
  static String _messageTypeToString(ImMessageType type) {
    switch (type) {
      case ImMessageType.text:
        return 'text';
      case ImMessageType.image:
        return 'image';
      case ImMessageType.audio:
        return 'audio';
      case ImMessageType.video:
        return 'video';
    }
  }
}
