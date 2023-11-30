

// ignore_for_file: avoid_print, duplicate_ignore

import 'package:c_supervisor/Network/response_handler.dart';

import '../Model/request_model/login_request.dart';
import '../Model/response_model/login_responses/login_response_model.dart';
import 'api_urls.dart';

class HTTPManager {
  final ResponseHandler _handler = ResponseHandler();

  Future<LogInResponseModel> loginUser(LoginRequestModel loginRequestModel) async {

    const url = ApplicationURLs.API_LOGIN;
    // ignore: avoid_print
    print(url);

    final response = await _handler.post(Uri.parse(url), loginRequestModel.toJson());
    LogInResponseModel logInResponseModel = LogInResponseModel.fromJson(response);

     return logInResponseModel;
  }

}
