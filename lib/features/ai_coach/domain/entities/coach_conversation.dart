class CoachConversation {
  final String id;
  final String userId;

  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;

  final String? lastMessagePreview;
  final DateTime? lastMessageAt;

  final bool isArchived;

  const CoachConversation({
    required this.id,
    required this.userId,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    this.lastMessagePreview,
    this.lastMessageAt,
    this.isArchived = false,
  });
}
