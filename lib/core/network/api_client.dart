import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio;

  // Placeholder URL- will be updated as per user's request
  static const String baseUrl = 'https://api.parceiroassistencial.com.br';

  ApiClient()
      : dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  // Example method for CPF validation
  Future<Response> checkCpf(String cpf) async {
    return await dio.post('/check-cpf', data: {'cpf': cpf.replaceAll(RegExp(r'[^0-9]'), '')});
  }
}
