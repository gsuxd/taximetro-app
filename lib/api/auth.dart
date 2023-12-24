import 'package:dio/dio.dart';
import 'package:malibu/services/dio.dart';

import '../conts.dart';
import '../models/user_model.dart';

class _LoginResponse {
  final User user;
  final String token;
  _LoginResponse(this.user, this.token);
}

abstract class AuthApi {
  // ignore: library_private_types_in_public_api
  static Future<_LoginResponse> login(String email, String password) async {
    try {
      final res = await dio.post('$API_URL/api/auth/login',
          options: Options(contentType: Headers.jsonContentType),
          data: {
            'email': email,
            'password': password,
          });
      return _LoginResponse(User.fromJson(res.data['user']), res.data['token']);
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          switch (e.response!.statusCode) {
            case 401:
              throw Exception('Credenciales inválidas');
            case 400:
              if (e.response!.data['message'] ==
                  'El correo no ha sido verificado') {
                throw Exception('EMAIL_NOT_VERIFIED');
              }
              throw Exception(e.response!.data['message']);
            default:
          }
        }
      }
      throw Exception('Error de conexión');
    }
  }
}
