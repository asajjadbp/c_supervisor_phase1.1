

// ignore_for_file: avoid_print, duplicate_ignore

import 'dart:io';

import 'package:c_supervisor/Network/response_handler.dart';
import 'package:image_picker/image_picker.dart';

import '../Model/request_model/end_visit_request.dart';
import '../Model/request_model/get_check_list_request.dart';
import '../Model/request_model/journey_plan_request.dart';
import '../Model/request_model/login_request.dart';
import '../Model/request_model/start_journey_plan_request.dart';
import '../Model/response_model/checklist_responses/check_list_response_list_model.dart';
import '../Model/response_model/journey_responses_plan/journey_plan_response_list.dart';
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

  //Journey Plan List
  Future<JourneyPlanResponseModel> userJourneyPlanList(JourneyPlanRequestModel journeyPlanRequestModel) async {

    const url = ApplicationURLs.API_JP;
    // ignore: avoid_print
    print(url);

    final response = await _handler.post(Uri.parse(url), journeyPlanRequestModel.toJson());
    JourneyPlanResponseModel journeyPlanResponseModel = JourneyPlanResponseModel.fromJson(response);

    return journeyPlanResponseModel;
  }

  //Start Journey Plan
  Future<dynamic> startJourneyPlan(StartJourneyPlanRequestModel startJourneyPlanRequestModel,XFile photoFile) async {

    const url = ApplicationURLs.API_START_VISIT;
    // ignore: avoid_print
    print(url);

    final response = await _handler.postImage(url, startJourneyPlanRequestModel.toJson(),photoFile);
    // JourneyPlanResponseModel journeyPlanResponseModel = JourneyPlanResponseModel.fromJson(response);

    return response;
  }

  //Get Check List
  Future<CheckListResponseModel> getCheckList(GetCheckListRequest getCheckListRequest) async {

    const url = ApplicationURLs.API_CHECK_LIST;
    // ignore: avoid_print
    print(url);

    final response = await _handler.post(Uri.parse(url), getCheckListRequest.toJson());
    CheckListResponseModel checkListResponseModel = CheckListResponseModel.fromJson(response);

    return checkListResponseModel;
  }

  //update Check List
  Future<dynamic> updateCheckListWithJson(CheckListResponseModel param) async {

    const url = ApplicationURLs.API_UPDATE_CHECK_LIST;
    // ignore: avoid_print
    print(url);

    final response = await _handler.postWithJsonRequest(Uri.parse(url), param);
    // JourneyPlanResponseModel journeyPlanResponseModel = JourneyPlanResponseModel.fromJson(response);

    return response;
  }

  //End Visit
  Future<dynamic> endVisit(EndVisitRequestModel endVisitRequestModel) async {

    const url = ApplicationURLs.API_END_VISIT;
    // ignore: avoid_print
    print(url);

    final response = await _handler.post(Uri.parse(url), endVisitRequestModel.toJson());
    // JourneyPlanResponseModel journeyPlanResponseModel = JourneyPlanResponseModel.fromJson(response);

    return response;
  }

}
