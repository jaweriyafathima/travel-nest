
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../services/ai_chat_service.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final AIChatService _chatService = AIChatService();

  final TextEditingController _messageController =
      TextEditingController();

  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> _messages = [];

  bool _isLoading = false;
  bool _isInitializing = true;

  static const Color purple = Color(0xFF7355A5);
  static const Color background = Color(0xFFF8F5FC);

  User? get _currentUser => FirebaseAuth.instance.currentUser;

  CollectionReference<Map<String, dynamic>> get _messagesCollection {
    final user = _currentUser;

    if (user == null) {
      throw Exception('Please log in to use Travel Nest AI.');
    }

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('chats')
        .doc('main')
        .collection('messages');
  }

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  // LOAD PREVIOUS CHAT HISTORY
  Future<void> _loadMessages() async {
    try {
      if (_currentUser == null) {
        throw Exception('Please log in first.');
      }

      final snapshot = await _messagesCollection
          .orderBy('createdAt')
          .get();

      final loadedMessages = snapshot.docs.map((doc) {
        final data = doc.data();

        return <String, dynamic>{
          'id': doc.id,
          'text': (data['text'] ?? '').toString(),
          'isUser': data['isUser'] == true,
        };
      }).toList();

      _chatService.restoreHistory(loadedMessages);

      if (!mounted) return;

      setState(() {
        _messages
          ..clear()
          ..addAll(loadedMessages);
        _isInitializing = false;
      });

      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isInitializing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not load chat history: $e'),
        ),
      );
    }
  }

  // SAVE MESSAGE TO FIRESTORE
  Future<void> _saveMessage({
    required String text,
    required bool isUser,
  }) async {
    await _messagesCollection.add({
      'text': text,
      'isUser': isUser,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // SEND MESSAGE TO AI
  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();

    if (message.isEmpty || _isLoading || _isInitializing) {
      return;
    }

    if (_currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please log in first.'),
        ),
      );
      return;
    }

    setState(() {
      _messages.add({
        'text': message,
        'isUser': true,
      });
      _isLoading = true;
    });

    _messageController.clear();
    _scrollToBottom();

    try {
      // Save user message first.
      await _saveMessage(
        text: message,
        isUser: true,
      );

      // Get AI response.
      final answer = await _chatService.sendMessage(message);

      // Save AI response.
      await _saveMessage(
        text: answer,
        isUser: false,
      );

      if (!mounted) return;

      setState(() {
        _messages.add({
          'text': answer,
          'isUser': false,
        });
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _messages.add({
          'text': 'Sorry, something went wrong.\n\nDetails: $e',
          'isUser': false,
          'isError': true,
        });
        _isLoading = false;
      });
    }

    _scrollToBottom();
  }

  // SCROLL TO LATEST MESSAGE
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // CLEAR SAVED CHAT
  Future<void> _clearChat() async {
    if (_isLoading || _isInitializing) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Clear conversation?'),
          content: const Text(
            'This will permanently delete your saved chat history.',
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pop(dialogContext, true),
              child: const Text(
                'Clear',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      final snapshot = await _messagesCollection.get();

      for (var start = 0;
          start < snapshot.docs.length;
          start += 450) {
        final batch = FirebaseFirestore.instance.batch();

        final end = (start + 450 < snapshot.docs.length)
            ? start + 450
            : snapshot.docs.length;

        for (var i = start; i < end; i++) {
          batch.delete(snapshot.docs[i].reference);
        }

        await batch.commit();
      }

      _chatService.resetChat();

      if (!mounted) return;

      setState(() {
        _messages.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Chat history cleared successfully.'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not clear chat: $e'),
        ),
      );
    }
  }

  // CHATGPT-STYLE MESSAGE BOX
  Widget _messageBubble(Map<String, dynamic> message) {
    final bool isUser = message['isUser'] == true;
    final bool isError = message['isError'] == true;

    final String messageText =
        (message['text'] ?? '').toString();

    return Align(
      alignment: isUser
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.90,
        ),
        margin: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 12,
        ),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isUser
              ? purple
              : isError
                  ? const Color(0xFFFFEEEE)
                  : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: isUser
              ? null
              : Border.all(
                  color: const Color(0xFFE9DFF3),
                ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: isUser
            ? SelectableText(
                messageText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  height: 1.6,
                ),
              )
            : MarkdownBody(
                data: messageText,
                selectable: true,
                styleSheet: MarkdownStyleSheet(
                  p: TextStyle(
                    fontSize: 15,
                    height: 1.7,
                    color: isError
                        ? Colors.red.shade900
                        : const Color(0xFF292535),
                  ),
                  h1: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: purple,
                  ),
                  h2: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: purple,
                  ),
                  h3: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: purple,
                  ),
                  strong: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: purple,
                  ),
                  em: const TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                  listBullet: const TextStyle(
                    fontSize: 15,
                    color: purple,
                  ),
                  code: const TextStyle(
                    fontSize: 13,
                    color: purple,
                    backgroundColor: Color(0xFFF1EAF8),
                  ),
                  codeblockDecoration: BoxDecoration(
                    color: const Color(0xFFF3EFF8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  blockquoteDecoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: purple,
                        width: 4,
                      ),
                    ),
                  ),
                  blockquotePadding: const EdgeInsets.all(12),
                  blockSpacing: 12,
                ),
              ),
      ),
    );
  }

  // WELCOME SCREEN
  Widget _welcomeMessage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.travel_explore,
              size: 75,
              color: purple,
            ),
            const SizedBox(height: 18),
            const Text(
              'Hello, Traveller! ✈️',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: purple,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Ask me anything about your next trip.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                'Plan a trip to Paris',
                'Suggest budget destinations',
                'What should I pack?',
              ].map((suggestion) {
                return ActionChip(
                  label: Text(suggestion),
                  onPressed:
                      _isLoading || _isInitializing
                          ? null
                          : () {
                              _messageController.text =
                                  suggestion;
                              _sendMessage();
                            },
                  backgroundColor: Colors.white,
                  side: const BorderSide(
                    color: Color(0xFFD9C9EC),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: purple,
        foregroundColor: Colors.white,
        title: const Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.travel_explore,
                color: purple,
              ),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Travel Nest AI',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Your personal travel assistant',
                  style: TextStyle(fontSize: 11),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Clear chat',
            onPressed:
                _isLoading || _isInitializing
                    ? null
                    : _clearChat,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isInitializing
                ? const Center(
                    child: CircularProgressIndicator(
                      color: purple,
                    ),
                  )
                : _messages.isEmpty
                    ? _welcomeMessage()
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                        itemCount: _messages.length +
                            (_isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == _messages.length) {
                            return const Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 17,
                                      height: 17,
                                      child:
                                          CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: purple,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Travel Nest AI is typing...',
                                      style: TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          return _messageBubble(
                            _messages[index],
                          );
                        },
                      ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(
              12,
              10,
              12,
              15,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Color(0xFFE8DFF1),
                ),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      enabled: !_isLoading &&
                          !_isInitializing,
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: 'Ask Travel Nest AI...',
                        filled: true,
                        fillColor: background,
                        contentPadding:
                            const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 13,
                        ),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 24,
                    backgroundColor:
                        _isLoading || _isInitializing
                            ? Colors.grey
                            : purple,
                    child: IconButton(
                      onPressed:
                          _isLoading || _isInitializing
                              ? null
                              : _sendMessage,
                      icon: const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 21,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
