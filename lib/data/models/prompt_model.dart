class PromptModel {
  PromptModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.promptText,
    required this.categoryId,
    required this.aiType,
    required this.isTrending,
    required this.isActive,
  });

  final String id;
  final String title;
  final String imageUrl;
  final String promptText;
  final String categoryId;
  final String aiType;
  final bool isTrending;
  final bool isActive;

  factory PromptModel.fromMap(String id, Map<String, dynamic> map) {
    final rawTrending = map['isTrending'] ?? map['is_trending'];
    final rawActive = map['isActive'] ?? map['is_active'];
    final rawCategoryId = map['categoryId'] ?? map['category_id'];

    return PromptModel(
      id: id,
      title: map['title'] ?? '',
      imageUrl: map['imageUrl'] ?? map['image_url'] ?? '',
      promptText: map['promptText'] ?? map['prompt_text'] ?? '',
      categoryId: rawCategoryId?.toString() ?? '',
      aiType: map['aiType'] ?? map['ai_type'] ?? 'other',
      isTrending: rawTrending == true || rawTrending == 1,
      isActive: rawActive != false && rawActive != 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'promptText': promptText,
      'categoryId': categoryId,
      'aiType': aiType,
      'isTrending': isTrending,
      'isActive': isActive,
    };
  }
}
