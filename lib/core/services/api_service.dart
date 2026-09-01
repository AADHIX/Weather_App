import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../utils/app_logger.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic details;

  ApiException(this.message, {this.statusCode, this.details});

  @override
  String toString() => message;
}

class NetworkException extends ApiException {
  NetworkException([super.message = 'No Internet connection. Please check your network.']);
}

class NotFoundException extends ApiException {
  NotFoundException([super.message = 'Location not found. Please try another search.'])
      : super(statusCode: 404);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException([super.message = 'Invalid or missing API key.'])
      : super(statusCode: 401);
}

class ApiService {
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? queryParams,
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint').replace(
      queryParameters: queryParams,
    );

    AppLogger.info('GET Request: $uri', 'API');

    try {
      final response = await _client
          .get(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              ...?headers,
            },
          )
          .timeout(ApiConstants.connectTimeout);

      return _handleResponse(response);
    } on SocketException catch (e) {
      AppLogger.error('SocketException on $uri', e, null, 'API');
      throw NetworkException();
    } on TimeoutException catch (e) {
      AppLogger.error('TimeoutException on $uri', e, null, 'API');
      throw ApiException('Connection timed out. Please try again.');
    } on http.ClientException catch (e) {
      AppLogger.error('ClientException on $uri', e, null, 'API');
      throw NetworkException('Unable to reach weather server.');
    } catch (e) {
      if (e is ApiException) rethrow;
      AppLogger.error('Unexpected error on $uri', e, null, 'API');
      throw ApiException('An unexpected error occurred: ${e.toString()}');
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    AppLogger.info('Response Code: ${response.statusCode}', 'API');

    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (_) {
      body = response.body;
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (body is Map<String, dynamic>) {
        return body;
      }
      return {'data': body};
    }

    final message = (body is Map && body.containsKey('message'))
        ? body['message'].toString()
        : 'Request failed with status: ${response.statusCode}';

    switch (response.statusCode) {
      case 401:
        throw UnauthorizedException('Invalid API Key. Please configure a valid OpenWeatherMap key.');
      case 404:
        throw NotFoundException('City or location not found.');
      case 429:
        throw ApiException('API rate limit exceeded. Please try again later.', statusCode: 429);
      case 500:
      case 502:
      case 503:
        throw ApiException('Weather service is currently unavailable. Please try later.', statusCode: response.statusCode);
      default:
        throw ApiException(message, statusCode: response.statusCode, details: body);
    }
  }
}
