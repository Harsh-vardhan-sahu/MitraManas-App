import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../modals/chat_message.dart';
import '../service/gemini_service.dart';
import '../storage/local_storage.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadOldMessages();
  }

  void _loadOldMessages() {
    final stored = LocalStorage.getMessages();
    _messages.clear();
    for (var item in stored) {
      _messages.add(ChatMessage(message: item['msg'], isUser: item['isUser']));
    }
    setState(() {});
  }

  Future<void> _sendMessage() async {
    final input = _controller.text.trim();
    if (input.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(message: input, isUser: true));
      _isLoading = true;
    });
    LocalStorage.saveMessage(input, true);
    _controller.clear();

    final response = await GeminiService.sendMessage(input);
    setState(() {
      _messages.add(ChatMessage(message: response, isUser: false));
      _isLoading = false;
    });
    LocalStorage.saveMessage(response, false);
  }

  void _deleteAll() {
    LocalStorage.deleteAll();
    setState(() => _messages.clear());
  }

  Widget _buildChatBubble(ChatMessage msg) {
    final isUser = msg.isUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.all(14),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: isUser ? Colors.indigo[100] : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 16),
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(2, 2),
            )
          ],
        ),
        child: Text(
          msg.message,
          style: TextStyle(
            fontSize: 15,
            color: isUser ? Colors.black : Colors.black87, // ← Important fix
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingAnimation() {
    return const Padding(
      padding: EdgeInsets.all(12),
      child: SpinKitThreeBounce(
        color: Colors.lightBlueAccent,
        size: 24,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: const Text('Gemini ChatBot'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteAll,
          )
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
          child: Image.asset(
          'assets/img.png',
        fit:BoxFit.cover,
      ),
      ),
          Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                padding: const EdgeInsets.only(top: 16),
                itemCount: _messages.length + (_isLoading ? 1 : 0),
                itemBuilder: (_, index) {
                  if (_isLoading && index == 0) return _buildLoadingAnimation();
                  final msg = _messages[_messages.length - 1 - (index - (_isLoading ? 1 : 0))];
                  return _buildChatBubble(msg);
                },
              ),
            ),
            const Divider(height: 1),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style:const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Ask something...',
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Colors.indigo,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
            ],
      ),
    );
  }
}
