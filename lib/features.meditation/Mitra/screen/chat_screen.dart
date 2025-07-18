import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../modals/chat_message.dart';
import '../service/gemini_service.dart';
import '../storage/local_storage.dart';
class ChatBubbleClipper extends CustomClipper<Path> {
  final bool isUser;

  ChatBubbleClipper({required this.isUser});

  @override
  Path getClip(Size size) {
    const radius = 16.0;
    const tailSize = 10.0;
    final path = Path();

    if (isUser) {
      // ✅ Tail on bottom-right
      path.moveTo(0, radius);
      path.quadraticBezierTo(0, 0, radius, 0);
      path.lineTo(size.width - radius, 0);
      path.quadraticBezierTo(size.width, 0, size.width, radius);
      path.lineTo(size.width, size.height - radius);
      path.quadraticBezierTo(
          size.width, size.height, size.width - radius, size.height);

      path.lineTo(size.width - tailSize, size.height);
      path.quadraticBezierTo(
          size.width, size.height, size.width - tailSize, size.height - tailSize);

      path.lineTo(radius, size.height - tailSize);
      path.quadraticBezierTo(0, size.height - tailSize, 0, size.height - radius - tailSize);
      path.lineTo(0, radius);
      path.close();
    } else {

      path.moveTo(tailSize, 0);
      path.quadraticBezierTo(tailSize + radius, 0, tailSize + radius, 0);
      path.lineTo(size.width - radius, 0);
      path.quadraticBezierTo(size.width, 0, size.width, radius);
      path.lineTo(size.width, size.height - radius);
      path.quadraticBezierTo(size.width, size.height, size.width - radius, size.height);
      path.lineTo(tailSize + radius, size.height);
      path.quadraticBezierTo(
          tailSize, size.height, tailSize + radius, size.height - tailSize);

      // Tail curve bottom-left
      path.lineTo(tailSize, size.height - tailSize);
      path.quadraticBezierTo(0, size.height, tailSize, size.height - radius);

      path.lineTo(tailSize, radius);
      path.quadraticBezierTo(tailSize, 0, tailSize + radius, 0);
      path.close();
    }

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}



class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final FlutterTts _flutterTts = FlutterTts();

  bool _isLoading = false;
  bool isTtsMuted = true;
  String lastBotMessage = "";

  @override
  void initState() {
    super.initState();
    _loadOldMessages();

    _flutterTts.setCompletionHandler(() {
      setState(() {
        isTtsMuted = true;
      });
    });
  }

  void _loadOldMessages() {
    final stored = LocalStorage.getMessages();
    _messages.clear();
    for (var item in stored) {
      _messages.add(ChatMessage(message: item['msg'], isUser: item['isUser']));
    }
    setState(() {});
  }

  Future<void> _speakText(String text) async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.42);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.speak(text);
  }

  Future<void> _toggleTts() async {
    if (isTtsMuted) {
      await _speakText(lastBotMessage);
    } else {
      await _flutterTts.stop();
    }
    setState(() {
      isTtsMuted = !isTtsMuted;
    });
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
      lastBotMessage = response;
      isTtsMuted = true; // reset speaker icon
    });
    LocalStorage.saveMessage(response, false);
  }

  void _deleteAll() {
    LocalStorage.deleteAll();
    setState(() {
      _messages.clear();
      lastBotMessage = "";
      _flutterTts.stop();
    });
  }

  Widget _buildChatBubble(ChatMessage msg) {
    final isUser = msg.isUser;
    final isLatestBotMessage = !isUser && msg.message == lastBotMessage;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: IntrinsicWidth(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            child: ClipPath(
              clipper: ChatBubbleClipper(isUser: isUser),
              child: isUser
                  ? Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.indigo[100],
                  border: Border.all(
                    color: Colors.indigo.withOpacity(0.3),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Text(
                  msg.message,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
              )
                  : BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.withOpacity(0.25),
                        Colors.white.withOpacity(0.15),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    color: Colors.white.withOpacity(0.1),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // 💬 Bot message
                      Expanded(
                        child: Text(
                          msg.message,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      // 🔊 Speaker icon
                      if (isLatestBotMessage)
                        GestureDetector(
                          onTap: _toggleTts,
                          child: Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.5),
                            ),
                            child: Icon(
                              isTtsMuted
                                  ? Icons.volume_off
                                  : Icons.volume_up,
                              size: 20,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
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
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Center(child: const Text('Mitra')),
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
              'assets/img_6.png',
              fit: BoxFit.cover,
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
                color: Colors.white.withOpacity(0.9),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: 'Ask something...',
                          filled: true,
                          fillColor: Colors.grey[200],
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
