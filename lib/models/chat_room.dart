import 'package:ecommerce/models/message.dart';
import 'package:ecommerce/models/user.dart';

class ChatRoomModel {
  const ChatRoomModel({required this.sender, required this.receiver,required this.messages,required this.id});
  final String id;
  final UserModel sender;
  final UserModel receiver;
  final List<MessageModel> messages;

  
}
