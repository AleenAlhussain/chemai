// ── Response models ───────────────────────────────────────────────────────────

class StudentProfile {
  final String id;
  final String userId;
  final int grade;
  final String preferredLanguage;
  final String? avatarUrl;
  final bool onboardingCompleted;
  final String createdAt;
  final String updatedAt;

  const StudentProfile({
    required this.id,
    required this.userId,
    required this.grade,
    required this.preferredLanguage,
    this.avatarUrl,
    required this.onboardingCompleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StudentProfile.fromJson(Map<String, dynamic> j) => StudentProfile(
        id: j['id'] as String? ?? '',
        userId: j['user_id'] as String? ?? '',
        grade: j['grade'] as int? ?? 9,
        preferredLanguage: j['preferred_language'] as String? ?? 'en',
        avatarUrl: j['avatar_url'] as String?,
        onboardingCompleted: j['onboarding_completed'] as bool? ?? false,
        createdAt: j['created_at'] as String? ?? '',
        updatedAt: j['updated_at'] as String? ?? '',
      );
}

class StudentPreferences {
  final String id;
  final String userId;
  final String teachingStyle;
  final String learningMode;
  final String createdAt;
  final String updatedAt;

  const StudentPreferences({
    required this.id,
    required this.userId,
    required this.teachingStyle,
    required this.learningMode,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StudentPreferences.fromJson(Map<String, dynamic> j) =>
      StudentPreferences(
        id: j['id'] as String? ?? '',
        userId: j['user_id'] as String? ?? '',
        teachingStyle: j['teaching_style'] as String? ?? '',
        learningMode: j['learning_mode'] as String? ?? '',
        createdAt: j['created_at'] as String? ?? '',
        updatedAt: j['updated_at'] as String? ?? '',
      );
}

// ── Request models ────────────────────────────────────────────────────────────

class UpdateStudentRequest {
  final int? grade;
  final String? preferredLanguage;
  final String? avatarUrl;
  final bool? onboardingCompleted;

  const UpdateStudentRequest({
    this.grade,
    this.preferredLanguage,
    this.avatarUrl,
    this.onboardingCompleted,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (grade != null) map['grade'] = grade;
    if (preferredLanguage != null) map['preferred_language'] = preferredLanguage;
    if (avatarUrl != null) map['avatar_url'] = avatarUrl;
    if (onboardingCompleted != null) map['onboarding_completed'] = onboardingCompleted;
    return map;
  }
}

class UpdatePreferencesRequest {
  final String? teachingStyle;
  final String? learningMode;

  const UpdatePreferencesRequest({
    this.teachingStyle,
    this.learningMode,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (teachingStyle != null) map['teaching_style'] = teachingStyle;
    if (learningMode != null) map['learning_mode'] = learningMode;
    return map;
  }
}
