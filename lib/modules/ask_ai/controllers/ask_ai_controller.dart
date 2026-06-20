import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/chat_message_model.dart';
import '../../../data/models/conversation_model.dart';
import '../../../services/conversation_service.dart';

class AskAiController extends GetxController {
  final ConversationService _conversationService = Get.find<ConversationService>();

  // ── Conversations ──────────────────────────────────────────────────────────
  final conversations        = <ConversationModel>[].obs;
  final currentConversation  = Rxn<ConversationModel>();
  final isLoadingConversations = false.obs;

  // ── Messages ───────────────────────────────────────────────────────────────
  final messages   = <ChatMessage>[].obs;
  final isTyping   = false.obs;
  final teachingStyle   = 'Socratic'.obs;
  final messageController = TextEditingController();
  final scrollController  = ScrollController();

  @override
  void onInit() {
    super.onInit();
    loadConversations();
  }

  // ── Load conversations from API ────────────────────────────────────────────

  Future<void> loadConversations() async {
    isLoadingConversations.value = true;
    try {
      final result = await _conversationService.getConversations();
      conversations.value = result;
      // Auto-select the most recent conversation if none selected
      if (currentConversation.value == null && result.isNotEmpty) {
        selectConversation(result.first);
      }
    } catch (_) {} finally {
      isLoadingConversations.value = false;
    }
  }

  // ── Create a new conversation ──────────────────────────────────────────────

  Future<void> newConversation() async {
    isLoadingConversations.value = true;
    try {
      final created = await _conversationService.createConversation();
      if (created != null) {
        conversations.insert(0, created);
        selectConversation(created);
        Get.back(); // close the conversations sheet
      } else {
        Get.snackbar('error'.tr, 'try_again_later'.tr,
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('error'.tr, e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoadingConversations.value = false;
    }
  }

  // ── Select a conversation ──────────────────────────────────────────────────

  void selectConversation(ConversationModel conv) {
    currentConversation.value = conv;
    messages.clear();
    // Seed the chat with a welcome message for this conversation
    messages.add(ChatMessage(
      id: 'welcome',
      content: 'ask_ai_welcome'.tr,
      isBot: true,
      time: _now(),
    ));
  }

  // ── Send a message ─────────────────────────────────────────────────────────

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    // Auto-create a conversation if none exists yet
    if (currentConversation.value == null) {
      await newConversation();
      if (currentConversation.value == null) return;
    }

    messages.add(ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: text,
      isBot: false,
      time: _now(),
    ));
    messageController.clear();
    isTyping.value = true;
    _scrollToBottom();

    // TODO: wire to real AI endpoint with currentConversation.value!.id
    await Future.delayed(const Duration(seconds: 2));
    isTyping.value = false;

    messages.add(ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: teachingStyle.value == 'Socratic'
          ? 'Interesting question! What do you think happens when atoms share electrons between two non-metals? 🤔'
          : 'That\'s a covalent bond. Hydrogen and oxygen share electrons to form water molecules.',
      isBot: true,
      time: _now(),
    ));
    _scrollToBottom();
  }

  void setStyle(String style) => teachingStyle.value = style;

  String _now() {
    final t = DateTime.now();
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 120), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
