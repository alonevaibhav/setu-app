class DraftSurvey {
  final String id;
  final String userId;
  final Map<String, dynamic> formData;
  final int currentStep;
  final int currentSubStep;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String status; // 'draft', 'in_progress', 'completed'
  final String? title; // User-friendly title

  DraftSurvey({
    required this.id,
    required this.userId,
    required this.formData,
    required this.currentStep,
    required this.currentSubStep,
    required this.createdAt,
    required this.updatedAt,
    this.status = 'draft',
    this.title,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'formData': formData,
    'currentStep': currentStep,
    'currentSubStep': currentSubStep,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'status': status,
    'title': title,
  };

  factory DraftSurvey.fromJson(Map<String, dynamic> json) => DraftSurvey(
    id: json['id'],
    userId: json['userId'],
    formData: Map<String, dynamic>.from(json['formData'] ?? {}),
    currentStep: json['currentStep'] ?? 0,
    currentSubStep: json['currentSubStep'] ?? 0,
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    status: json['status'] ?? 'draft',
    title: json['title'],
  );

  DraftSurvey copyWith({
    String? id,
    String? userId,
    Map<String, dynamic>? formData,
    int? currentStep,
    int? currentSubStep,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? status,
    String? title,
  }) =>
      DraftSurvey(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        formData: formData ?? this.formData,
        currentStep: currentStep ?? this.currentStep,
        currentSubStep: currentSubStep ?? this.currentSubStep,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        status: status ?? this.status,
        title: title ?? this.title,
      );
}