import 'package:chat_app/enums/connection_type_enums.dart';

class Payload {
  final String ip;
  final int port;
  final ConnectionTypes type;

  Payload({
    required this.ip,
    required this.port,
    required this.type,
  });

  factory Payload.fromJson(Map<String, dynamic> json) {
    return Payload(
      ip: json['ip'],
      port: json['port'],
      type: ConnectionTypes.values[json['type']],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ip': ip,
      'port': port,
      'type': type.index,
    };
  }
}

class ConnectionRequest extends Payload{
  final String name;
  final String uuid;
  final type = ConnectionTypes.request;

  ConnectionRequest({
    required this.name,
    required this.uuid,
    required String ip,
    required int port,
  }) : super(ip: ip, port: port, type: ConnectionTypes.request);

  factory ConnectionRequest.fromJson(Map<String, dynamic> json) {
    return ConnectionRequest(
      name: json['name'],
      uuid: json['uuid'],
      ip: json['ip'],
      port: json['port'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'uuid': uuid,
      'ip': ip,
      'port': port,
      'type': type.index,
    };
  }
}

class ConnectionAccepted extends Payload {
  final String name;
  final String uuid;
  final type = ConnectionTypes.accepted;

  ConnectionAccepted({
    required this.name,
    required this.uuid,
    required String ip,
    required int port,
  }) : super(ip: ip, port: port, type: ConnectionTypes.accepted);

  factory ConnectionAccepted.fromJson(Map<String, dynamic> json) {
    return ConnectionAccepted(
      name: json['name'],
      uuid: json['uuid'],
      ip: json['ip'],
      port: json['port'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'uuid': uuid,
      'ip': ip,
      'port': port,
      'type': type.index,
    };
  }
}

class Message extends Payload {
  final String message;
  final String uuid;
  final type = ConnectionTypes.message;

  Message({
    required this.message,
    required this.uuid,
    required String ip,
    required int port,
  }) : super(ip: ip, port: port, type: ConnectionTypes.message);

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['message'],
      uuid: json['uuid'],
      ip: json['ip'],
      port: json['port'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'uuid': uuid,
      'ip': ip,
      'port': port,
      'type': type.index,
    };
  }
}