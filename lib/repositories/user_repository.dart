import 'dart:convert';
import 'client.dart';
import 'package:dio/dio.dart';

class UserRepository {
  Future<ApiResponse> authenUser(
      String serviceApi, String userName, String passWord) async {
    Dio client = Client().init(serviceApi);

    try {
      final response = await client
          .post('/login', data: {"username": userName, "password": passWord});
      try {
        final result = json.decode(response.toString());
        final rawData = {"success": result["success"], "data": result};

        print(rawData);

        if (rawData['error'] != null) {
          String errorMessage = '${rawData['code']}: ${rawData['message']}';
          print(errorMessage);
          throw new Exception('${rawData['code']}: ${rawData['message']}');
        }

        return ApiResponse.fromMap(rawData);
      } catch (ex) {
        print(ex);
        throw Exception(ex);
      }
    } on DioError catch (ex) {
      String errorMessage = ex.response.toString();
      if (ex.type == DioErrorType.connectTimeout) {
        throw Exception('Connection Timeout');
      }
      if (ex.type == DioErrorType.receiveTimeout) {
        throw Exception('unable to connect to the server');
      }
      if (ex.type == DioErrorType.other) {
        throw Exception('Something went wrong');
      }
      if (ex.type == DioErrorType.response) {
        print(ex.response?.statusCode);
        throw Exception('User Not Found');
      }

      print(errorMessage);

      throw Exception(errorMessage);
    }
  }

  Future<dynamic> requestOPT(String telephoneNumber) async {
    Dio client = Dio();

    try {
      final response = await client.post(
          'https://smsapi.deecommerce.co.th:4300/service/v1/otp/request',
          data: {
            "accountId": "08992231310610",
            "secretKey": "U2FsdGVkX19gSK0SR/xX5DAa6B2Mn1wDyEo1es83LNQ=",
            "type": "OTP",
            "lang": 'th',
            "to": telephoneNumber,
            "sender": "deeSMS.OTP",
            "isShowRef": '1'
          });
      try {
        final rawData = json.decode(response.toString());

        print(rawData);

        if (rawData['error'] != '0') {
          throw new Exception('${rawData['msg']}');
        }

        return rawData['result'];
      } catch (ex) {
        print(ex);
        throw Exception(ex);
      }
    } on DioError catch (ex) {
      String errorMessage = ex.response.toString();
      print(errorMessage);
      throw Exception(errorMessage);
    }
  }

  Future<bool> verifyOPT(String token, String pin) async {
    Dio client = Dio();

    try {
      final response = await client.post(
          'https://smsapi.deecommerce.co.th:4300/service/v1/otp/verify',
          data: {
            "accountId": "08992231310610",
            "secretKey": "U2FsdGVkX19gSK0SR/xX5DAa6B2Mn1wDyEo1es83LNQ=",
            "token": token,
            "pin": pin,
          });
      try {
        final rawData = json.decode(response.toString());

        print(rawData);

        if (rawData['error'] != '0') {
          throw new Exception('${rawData['msg']}');
        }

        return true;
      } catch (ex) {
        print(ex);
        throw Exception(ex);
      }
    } on DioError catch (ex) {
      String errorMessage = ex.response.toString();
      print(errorMessage);
      throw Exception(errorMessage);
    }
  }
}
