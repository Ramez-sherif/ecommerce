import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/chat_room.dart';
import 'package:ecommerce/models/message.dart';
import 'package:ecommerce/models/user.dart';
import 'package:ecommerce/services/collections_config.dart';
import 'package:ecommerce/services/user.dart';

class ChatRoomService {
  static final db = FirebaseFirestore.instance;

  static Future<ChatRoomModel> createChatRoom(String senderId, String receiverId) async {
    UserModel Sender = await UserService.getUserDetails(senderId);
    //UserModel receiver = await UserService.getUserDetails(receiverId);

    DocumentReference doc = db.collection(CollectionConfig.chatRoom).doc();

    await doc.set(
        {"sender_id": senderId, "receiver_id": receiverId, "status": true});

    CollectionReference messagesCollection =
        doc.collection(CollectionConfig.messages);

    Timestamp timestamp = Timestamp.now();
    String messageTemp = "Hi, How can we help?";

    await messagesCollection.add(
        {"message": messageTemp, "date": timestamp, "sender_id": receiverId,"username": "Customer Support"});

    
    List<MessageModel> messages = [];

    messages.add(
        MessageModel(sender: Sender.uid, message: messageTemp, date: timestamp, name: Sender.username));

    ChatRoomModel chatroom = ChatRoomModel(
        sender: Sender,
        receiver: await UserService.getUserDetails(receiverId),
        messages: messages,
        id: doc.id);

    return chatroom;
  }

  static Future<void> sendMessage(String chatRoomId,String message,String senderId,String username)  async{
      DocumentReference chatRoomDoc = db.collection(CollectionConfig.chatRoom).doc(chatRoomId);
      CollectionReference messagesCollection = chatRoomDoc.collection(CollectionConfig.messages);
      await messagesCollection.add({
        "sender_id":senderId,
        "date":Timestamp.now(),
        "message":message,
        "username":username
      });
  } 
  static Future<ChatRoomModel> getChatRoombyUserData(
      String senderId, String receiverId) async {
    CollectionReference chatRoomRef = db.collection(CollectionConfig.chatRoom);
    var doc = await chatRoomRef
        .where("sender_id", isEqualTo: senderId)
        .where("receiver_id", isEqualTo: receiverId)
        .where("session_status", isEqualTo: true)
        .limit(1)
        .get();
    if (doc.docs.isEmpty) {
      // No chat room found, handle accordingly (e.g., return null or perform an action)
      // Example: Log a message and return null

      return await createChatRoom(senderId, receiverId);
    }
    //print("getting first document");
    QueryDocumentSnapshot<Object?> firstDoc = doc.docs.first;
     List<MessageModel> messages = await getChatRoomMessages(firstDoc.id);
    //print(firstDoc.id);
    ChatRoomModel chatRoom = ChatRoomModel(
        sender: await UserService.getUserById(senderId),
        receiver: await UserService.getUserById(receiverId),
        messages: messages,
        id: firstDoc.id);

    return chatRoom;
  }

  static Future<List<MessageModel>> getChatRoomMessages(String id) async {
    CollectionReference messagesCollection = db
        .collection(CollectionConfig.chatRoom)
        .doc(id)
        .collection(CollectionConfig.messages);
    QuerySnapshot querySnapshot = await messagesCollection.orderBy('date',descending: true).get();
    List<MessageModel> messages = [];

    for(var snap in querySnapshot.docs){
      UserModel user = await UserService.getUserById(snap["sender_id"]);
      messages.add(
        MessageModel(
          sender: user.uid,
          message: snap["message"],
          date: snap["date"], name: user.username));
    }
    return messages;
  }
}
