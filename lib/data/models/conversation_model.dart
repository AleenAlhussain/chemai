class ConversationModel {
  final String id;
  final String title;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ConversationModel({
    required this.id,
    required this.title,
    required this.isArchived,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> j) =>
      ConversationModel(
        id:         j['id']         as String? ?? '',
        title:      j['title']      as String? ?? 'New Chat',
        isArchived: j['is_archived'] as bool?  ?? false,
        createdAt:  DateTime.tryParse(j['created_at'] as String? ?? '') ?? DateTime.now(),
        updatedAt:  DateTime.tryParse(j['updated_at'] as String? ?? '') ?? DateTime.now(),
      );
}
