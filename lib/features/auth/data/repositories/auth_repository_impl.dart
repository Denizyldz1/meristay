import 'package:dio/dio.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<User> login(String email, String password) async {
    // Gerçek API gelene kadar mock data
    await Future.delayed(const Duration(seconds: 1));

    // Basit validasyon — API gelince bu blok tamamen değişecek
    if (email == 'test@meristay.com' && password == '123456') {
      return const User(
        id: 1,
        name: 'Deniz',
        email: 'test@meristay.com',
        token: 'mock_jwt_token_123',
      );
    }

    throw Exception('E-posta veya şifre hatalı');
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Token temizleme API gelince buraya yazılacak
  }

  @override
  Future<User?> getCurrentUser() async {
    // Token varsa kullanıcı bilgisini döndür
    // Şimdilik null dönüyor — API gelince düzenlenecek
    return null;
  }
}