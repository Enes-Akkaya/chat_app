import 'package:chat_app/components/chat_bubble.dart';
import 'package:chat_app/components/log_text_field.dart';
import 'package:flutter/material.dart';

import '../services/auth/auth_service.dart';
import '../services/chat/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String recieverEmail;
  final String recieverId;
  final String recieverName;

  ChatPage(
      {super.key,
      required this.recieverEmail,
      required this.recieverId,
      required this.recieverName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  //chat controller
  final TextEditingController _chatController = TextEditingController();

  //services
  final AuthService _auth = AuthService();

  final ChatService _chat = ChatService();

  //focus node for seeing the last message
  final FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();

    //add listener focus
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        Future.delayed(
          const Duration(microseconds: 400),
          () => scrollDown(),
        );
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _chatController.dispose();
    super.dispose();
  }

  //scroll controller
  final ScrollController _scrollController = ScrollController();
  void scrollDown() {
    _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 500,
        duration: const Duration(seconds: 2),
        curve: Curves.fastOutSlowIn);
  }

  //send message
  void sendMessage() async {
    await _chat.sendMessage(widget.recieverId, _chatController.text);
    _chatController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recieverName),
      ),
      body: Column(
        children: [
          //message list
          Expanded(child: _buildMessageList()),

          //message input
          _buildMessageInput(context),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderId = _auth.getCurrentUser()!.uid;
    return StreamBuilder(
        stream: _chat.getMessageStream(senderId, widget.recieverId),
        builder: (context, snapshot) {
          //handle errors
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
          //loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading...");
          }

          //display messages in list
          return ListView(
            controller: _scrollController,
            children: snapshot.data!.docs
                .map((doc) => _buildMessageItem(doc))
                .toList(),
          );
        });
  }

  Widget _buildMessageItem(doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    bool isCurrentUser = data["senderId"] == _auth.getCurrentUser()!.uid;

    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    //for other user

    return ChatBubble(isCurrentUser: isCurrentUser, message: data["message"]);
  }

  Widget _buildMessageInput(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: TextStyle(color: Colors.black),
              controller: _chatController,
              decoration: InputDecoration(
                hintText: "Type your message...",
                hintStyle:
                    TextStyle(color: Theme.of(context).colorScheme.tertiary),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
              focusNode: _focusNode,
            ),
          ),
          SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {
                sendMessage();
                scrollDown();
              },
              icon: Icon(Icons.send,
                  color: Theme.of(context).colorScheme.inversePrimary),
            ),
          ),
        ],
      ),
    );
  }
}
