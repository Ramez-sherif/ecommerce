import 'package:ecommerce/models/chat_room.dart';
import 'package:ecommerce/pages/chatting.dart';
import 'package:ecommerce/providers/user.dart';
import 'package:ecommerce/services/chat_room.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerSupportPage extends StatelessWidget {
  const CustomerSupportPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Customer Support Messages'),
        ),
        body: FutureBuilder<List<ChatRoomModel>>(
            future: ChatRoomService.getAllChatRooms(
                context.read<UserProvider>().user.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return  Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              List<ChatRoomModel> chatRooms = snapshot.data!;
              return ListView.builder(
                  itemCount: chatRooms.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(chatRooms[index].sender.username[0]),
                      ),
                      title: Text(chatRooms[index].sender.username),
                      onTap: () {
                        // Add action when a user is tapped
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(chatRoomId: chatRooms[index].id,)));
                      },
                    );
                  });
            }));
  }
}
