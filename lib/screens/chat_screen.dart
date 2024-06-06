import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class ChatScreen extends StatefulWidget {
  final ParseUser currentuser;
  final ParseUser otherUser;
  String otheruserobjectid;

  ChatScreen({
    Key? key,
    required this.currentuser,
    required this.otherUser,
    required this.otheruserobjectid,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

final TextEditingController newmessages = TextEditingController();

class _ChatScreenState extends State<ChatScreen> {
  Future<List<ParseObject>?> _fetchMessagesFromCurrentUser() async {
    final QueryBuilder<ParseObject> queryFromCurrentUser =
        QueryBuilder<ParseObject>(ParseObject('chatroom'))
          ..whereEqualTo('messagefrom', widget.currentuser.objectId)
          ..whereEqualTo('messageto', widget.otherUser.username)
          ..orderByAscending('createdAt');

    final List<ParseObject>? messagesFromCurrentUser =
        (await queryFromCurrentUser.query()).results as List<ParseObject>?;

    return messagesFromCurrentUser;
  }

  Future<List<ParseObject>?> _fetchMessagesToCurrentUser() async {
    final QueryBuilder<ParseObject> queryToCurrentUser =
        QueryBuilder<ParseObject>(ParseObject('chatroom'))
          ..whereEqualTo('messageto', widget.currentuser.username)
          ..whereEqualTo('messagefrom', widget.otheruserobjectid)
          ..orderByAscending('createdAt');

    final List<ParseObject>? messagesToCurrentUser =
        (await queryToCurrentUser.query()).results as List<ParseObject>?;

    return messagesToCurrentUser;
  }

  Future<List<ParseObject>?> _fetchCombinedMessages() async {
    final List<ParseObject>? messagesFromCurrentUser =
        await _fetchMessagesFromCurrentUser();
    final List<ParseObject>? messagesToCurrentUser =
        await _fetchMessagesToCurrentUser();

    final List<ParseObject> allMessages = [];
    if (messagesFromCurrentUser != null) {
      allMessages.addAll(messagesFromCurrentUser);
    }

    if (messagesToCurrentUser != null) {
      allMessages.addAll(messagesToCurrentUser);
    }

    allMessages.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));

    return allMessages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.otherUser.username}'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: Future.wait([
                _fetchMessagesFromCurrentUser(),
                _fetchMessagesToCurrentUser(),
                _fetchCombinedMessages(),
              ]),
              builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else {
                  final data = snapshot.data;
                  if (data != null) {
                    final List<ParseObject>? messagesFromCurrentUser =
                        data[0] as List<ParseObject>?;
                    final List<ParseObject>? messagesToCurrentUser =
                        data[1] as List<ParseObject>?;
                    final List<ParseObject>? allMessages =
                        data[2] as List<ParseObject>?;

                    if (messagesFromCurrentUser == null &&
                        messagesToCurrentUser != null &&
                        allMessages != null) {
                      return _buildMessageList(messagesToCurrentUser);
                    } else if (messagesFromCurrentUser != null &&
                        messagesToCurrentUser == null &&
                        allMessages != null) {
                      return _buildMessageList(messagesFromCurrentUser);
                    } else if (allMessages != null) {
                      return _buildMessageList(allMessages);
                    } else {
                      return Center(child: Text("No messages found"));
                    }
                  } else {
                    return Center(child: Text("No data available"));
                  }
                }
              },
            ),
          ),
          _buildBottomAppBar(),
        ],
      ),
    );
  }

  Widget _buildMessageList(List<ParseObject> messages) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        ParseObject message = messages[index];
        final String text = message.get('message') ?? '';
        return Row(
          mainAxisAlignment:
              widget.currentuser.objectId == message.get('messagefrom')
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: widget.currentuser.objectId == message.get('messagefrom')
                    ? Colors.blue
                    : Colors.green,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomRight:
                      widget.currentuser.objectId == message.get('messagefrom')
                          ? Radius.zero
                          : Radius.circular(12),
                  bottomLeft:
                      widget.currentuser.objectId == message.get('messagefrom')
                          ? Radius.circular(12)
                          : Radius.zero,
                ),
              ),
              padding: EdgeInsets.all(12),
              margin: EdgeInsets.symmetric(vertical: 4),
              child: Text(text),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomAppBar() {
    return BottomAppBar(
      color: Colors.white,
      child: Expanded(
        child: TextField(
          controller: newmessages,
          decoration: InputDecoration(
            suffixIcon: InkWell(
              onTap: () async {
                if (newmessages.text.isNotEmpty) {
                  final messages = ParseObject("chatroom")
                    ..set('message', newmessages.text)
                    ..set('messagefrom', widget.currentuser.objectId)
                    ..set('messageto', widget.otherUser.username);
                  await messages.save();
                  newmessages.clear();
                  setState(() {});
                }
              },
              child: Icon(Icons.send),
            ),
            hintText: 'Type your message...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
    );
  }
}
