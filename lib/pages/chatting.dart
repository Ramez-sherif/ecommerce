import 'package:ecommerce/models/chat_room.dart';
import 'package:ecommerce/models/message.dart';
import 'package:ecommerce/models/user.dart';
import 'package:ecommerce/providers/profile.dart';
import 'package:ecommerce/providers/user.dart';
import 'package:ecommerce/services/chat_room.dart';
import 'package:ecommerce/services/user.dart';
import 'package:flutter/material.dart'; // Import Flutter material package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:provider/provider.dart'; // Import Cloud Firestore package

class ChatScreen extends StatefulWidget {
  ChatScreen({super.key,required this.chatRoomId});

  // Define a StatefulWidget named ChatScreen
  @override
  _ChatScreenState createState() =>
      _ChatScreenState(); // Create state for ChatScreen
      final String chatRoomId;
}

class _ChatScreenState extends State<ChatScreen> {
  // Define state for ChatScreen widget
  final TextEditingController _textController =
      TextEditingController(); // Text editing controller for input
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Firestore instance for database operations
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Build method to create the UI
    //!  userId = context.read<UserProvider>().user.uid;
    return Scaffold(
      // Scaffold widget for app structure
      appBar: AppBar(
        // AppBar at the top
        title: const Text('Flutter Chat'), // Title of the app
      ),
      body: Column(
        // Column to arrange children vertically
        children: <Widget>[
          Expanded(
            // Expanded widget to take remaining space
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              // StreamBuilder for real-time data
              stream: FirebaseFirestore
                  .instance // Stream messages from Firestore collection 'messages'
                  .collection('chat_room')
                  .doc(widget.chatRoomId)
                  .collection("messages")
                  .orderBy('date',descending: true)
                  .snapshots(),
              // Stream.fromFuture(ChatRoomService.getChatRoombyUserData(
              //     "gNmhq1PO4mdzm93CrLmqrYsDeMl1",
              //     "4uNcJ0L2jrcXJuBD4ightE8P6382"),)

              builder: (context, snapshot) {
                // Builder function to handle snapshot data
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Check if data is loading
                  return const Center(
                    // Show loading indicator
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData || snapshot.data == null) {
                  // Check if there's no data
                  return const Center(
                    // Show 'No messages yet' if no data available
                    child: Text('No messages yet'),
                  );
                }
                List<MessageModel> messages = [];
                for (var item in snapshot.data!.docs) {
                  messages.add(MessageModel(
                      message: item["message"],
                      sender: item["sender_id"],
                      date: item["date"],
                      name: item["username"]));
                }
                final chatRoom = snapshot.data!;
                // Reverse order of retrieved messages
                //print(messages[0].message);
                // /print(messages[0].message);
                List<Widget> messageWidgets =
                    []; // List to store message widgets
                for (var message in messages) {
                  // Loop through each message
                  final messageText = message.message; // Get message text
                  final messageSenderId =
                      message.sender; // Get message sender
                  final messageSender = message.name;
                  final messageWidget = MessageBubble(
                    // Create a message bubble widget
                    sender: messageSender, // Pass sender to the widget
                    text: messageText, // Pass text to the widget
                    isMe: messageSenderId ==
                        context.read<UserProvider>().user.uid, // Check if the message is from the current user
                  );
                  messageWidgets
                      .add(messageWidget); // Add the message widget to the list
                }

                return ListView(
                  // Display messages in a scrollable list view
                  reverse: true, // Start displaying messages from the bottom
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0), // Padding for the list
                  children: messageWidgets, // Show the list of message widgets
                );
              },
            ),
          ),
          Container(
            // Container for text input field and send button
            margin: const EdgeInsets.only(top: 8.0), // Margin from the top
            padding: const EdgeInsets.symmetric(
                horizontal: 8.0), // Padding for the container
            child: Form(
              child: Row(
                // Row to arrange children horizontally
                children: <Widget>[
                  Expanded(
                    // Expanded widget to take remaining space
                    child: TextField(
                      // Text field for entering messages
                      controller: _textController, // Use the text controller
                      onChanged: (value) {}, // Handle text field changes
                      decoration: const InputDecoration(
                        // Input decoration for the text field
                        hintText:
                            'Enter your message...', // Hint text for the text field
                      ),
                    ),
                  ),
                  IconButton(
                    // Icon button for sending messages
                    icon: const Icon(Icons.send), // Send icon
                    onPressed: () async {
                      // Handle button press
                      if (_textController.text.isNotEmpty && widget.chatRoomId != "") {
                        // Check if text field is not empty
                        UserModel user = await UserService.getUserDetails(context.read<UserProvider>().user.uid);
                        await ChatRoomService.sendMessage(
                            widget.chatRoomId,
                            _textController.text,
                            user.uid,user.username); // Send the message //4uNcJ0L2jrcXJuBD4ightE8P6382

                        _textController.clear();
                      }
                    },
                  ),
                ],
              ),
              onWillPop: () async {
                _textController.clear();
                return true;
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  // Define a StatelessWidget named MessageBubble
  MessageBubble(
      {required this.sender,
      required this.text,
      required this.isMe}); // Constructor

  final String sender; // Sender's name or ID
  final String text; // Message text
  final bool isMe; // Boolean to check if the message is from the current user

  @override
  Widget build(BuildContext context) {
    // Build method for MessageBubble
    return Padding(
      // Padding widget to add space around the content
      padding: const EdgeInsets.all(8.0), // Padding for the content
      child: Column(
        // Column to arrange children vertically
        crossAxisAlignment: // Align based on the sender
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            // Text widget to display sender's name
            sender,
            style: const TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
            // Material widget for message bubble
            borderRadius:
                BorderRadius.circular(10.0), // Border radius for the bubble
            elevation: 5.0, // Elevation for shadow effect
            color: isMe
                ? Colors.blue
                : Colors.grey[300], // Bubble color based on sender
            child: Padding(
              // Padding for the bubble content
              padding: const EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: 15.0), // Padding for the content
              child: Text(
                // Text widget to display the message
                text,
                style: TextStyle(
                  fontSize: 15.0,
                  color: isMe ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
