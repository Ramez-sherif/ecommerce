import 'package:ecommerce/providers/user.dart';
import 'package:flutter/material.dart'; // Import Flutter material package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart'; // Import Cloud Firestore package

class ChatScreen2 extends StatefulWidget {
  // Define a StatefulWidget named ChatScreen
  @override
  _ChatScreenState createState() =>
      _ChatScreenState(); // Create state for ChatScreen
}

class _ChatScreenState extends State<ChatScreen2> {
  // Define state for ChatScreen widget
  final TextEditingController _textController =
      TextEditingController(); // Text editing controller for input
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Firestore instance for database operations
  //!late String userId;
  void _sendMessage(String messageText) {
    // Function to send a message
    _firestore.collection('messages').add({
      // Add message to Firestore collection 'messages'
      'text': messageText, // Message text
      'sender':
          "Ramez", //!userId, // Sender's ID or name (replace with actual sender)
      'timestamp': FieldValue.serverTimestamp(), // Timestamp for the message
    });
    _textController.clear(); // Clear the text field after sending the message
  }

  @override
  Widget build(BuildContext context) {
    // Build method to create the UI
    //!  userId = context.read<UserProvider>().user.uid;
    return Scaffold(
      // Scaffold widget for app structure
      appBar: AppBar(
        // AppBar at the top
        title: Text('Flutter Chat'), // Title of the app
      ),
      body: Column(
        // Column to arrange children vertically
        children: <Widget>[
          Expanded(
            // Expanded widget to take remaining space
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              // StreamBuilder for real-time data
              stream:
                  _firestore // Stream messages from Firestore collection 'messages'
                      .collection('chat_room')
                      .doc("3rt2gAFm5f7ENexIurdT")
                      .collection("messages")
                      .orderBy('date')
                      .snapshots(),
              builder: (context, snapshot) {
                // Builder function to handle snapshot data
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Check if data is loading
                  return Center(
                    // Show loading indicator
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData || snapshot.data == null) {
                  // Check if there's no data
                  return Center(
                    // Show 'No messages yet' if no data available
                    child: Text('No messages yet'),
                  );
                }

                final messages = snapshot
                    .data!.docs.reversed; // Reverse order of retrieved messages

                List<Widget> messageWidgets =
                    []; // List to store message widgets
                for (var message in messages) {
                  // Loop through each message
                  final messageText = message['text']; // Get message text
                  final messageSender = message['sender']; // Get message sender

                  final messageWidget = MessageBubble(
                    // Create a message bubble widget
                    sender: messageSender, // Pass sender to the widget
                    text: messageText, // Pass text to the widget
                    isMe: messageSender ==
                        'Ramez', // Check if the message is from the current user
                  );
                  messageWidgets
                      .add(messageWidget); // Add the message widget to the list
                }

                return ListView(
                  // Display messages in a scrollable list view
                  reverse: true, // Start displaying messages from the bottom
                  padding: EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0), // Padding for the list
                  children: messageWidgets, // Show the list of message widgets
                );
              },
            ),
          ),
          Container(
            // Container for text input field and send button
            margin: EdgeInsets.only(top: 8.0), // Margin from the top
            padding: EdgeInsets.symmetric(
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
                      decoration: InputDecoration(
                        // Input decoration for the text field
                        hintText:
                            'Enter your message...', // Hint text for the text field
                      ),
                    ),
                  ),
                  IconButton(
                    // Icon button for sending messages
                    icon: Icon(Icons.send), // Send icon
                    onPressed: () async{
                      // Handle button press
                      if (_textController.text.isNotEmpty) {
                        // Check if text field is not empty
                        _sendMessage(_textController.text); // Send the message
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
      padding: EdgeInsets.all(8.0), // Padding for the content
      child: Column(
        // Column to arrange children vertically
        crossAxisAlignment: // Align based on the sender
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            // Text widget to display sender's name
            sender,
            style: TextStyle(
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
              padding: EdgeInsets.symmetric(
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
