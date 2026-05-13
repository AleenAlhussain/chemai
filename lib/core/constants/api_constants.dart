abstract final class ApiConstants {
  static const baseUrl        = 'https://api.chemai.app/v1';
  static const connectTimeout = Duration(seconds: 15);
  static const receiveTimeout = Duration(seconds: 30);

  // Auth
  static const login    = '/auth/login';
  static const register = '/auth/register';

  // User
  static const profile   = '/user/profile';
  static const progress  = '/user/progress';

  // Content
  static const chapters  = '/chapters';
  static const lessons   = '/lessons';
  static const mentors   = '/mentors';

  // AI
  static const askAi     = '/ai/chat';
}
