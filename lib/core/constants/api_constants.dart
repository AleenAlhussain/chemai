abstract final class ApiConstants {
  static const baseUrl        = 'https://d7eb-5-155-5-83.ngrok-free.app';
  static const connectTimeout = Duration(seconds: 15);
  static const receiveTimeout = Duration(seconds: 30);

  // ── Auth ───────────────────────────────────────────────────────────────────
  static const login          = '/auth/login';
  static const register       = '/auth/register';
  static const logout         = '/auth/logout';
  static const account        = '/auth/account';
  static const refresh        = '/auth/refresh';
  static const changePassword = '/auth/change-password';
  static const updateProfile  = '/auth/profile';
  static const forgotPassword = '/auth/forgot-password';
  static const resetPassword  = '/auth/reset-password';

  // ── User ───────────────────────────────────────────────────────────────────
  static const profile  = '/user/profile';
  static const progress = '/user/progress';

  // ── Content ────────────────────────────────────────────────────────────────
  static const chapters = '/chapters';
  static const lessons  = '/lessons';
  static const mentors  = '/mentors';

  // ── Student ────────────────────────────────────────────────────────────────
  static const studentMe          = '/students/me';
  static const studentPreferences = '/students/preferences';

  // ── AI / Chat ──────────────────────────────────────────────────────────────
  static const askAi         = '/ai/chat';
  static const conversations = '/chat/conversations';
}
