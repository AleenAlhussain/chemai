class RegisterRequest {
  final String fullName;
  final String email;
  final String password;
  final String gender; // 'male' | 'female'

  const RegisterRequest({
    required this.fullName,
    required this.email,
    required this.password,
    required this.gender,
  });

  Map<String, dynamic> toJson() => {
        'full_name': fullName,
        'email': email,
        'password': password,
        'gender': gender,
      };
}

class LoginRequest {
  final String email;
  final String password;

  const LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}

class AuthResponse {
  final String accessToken;
  final String tokenType;
  final UserAuth user;

  const AuthResponse({
    required this.accessToken,
    required this.tokenType,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> j) => AuthResponse(
        accessToken: j['access_token'] as String? ?? '',
        tokenType: j['token_type'] as String? ?? 'bearer',
        user: UserAuth.fromJson(j['user'] as Map<String, dynamic>? ?? {}),
      );
}

class UserAuth {
  final String id;
  final String fullName;
  final String email;
  final String gender;

  const UserAuth({
    required this.id,
    required this.fullName,
    required this.email,
    required this.gender,
  });

  factory UserAuth.fromJson(Map<String, dynamic> j) => UserAuth(
        id: j['id']?.toString() ?? '',
        fullName: j['full_name'] as String? ?? '',
        email: j['email'] as String? ?? '',
        gender: j['gender'] as String? ?? '',
      );
}
