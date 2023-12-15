

// ignore_for_file: avoid_print, duplicate_ignore

import 'dart:io';

import 'package:c_supervisor/Network/response_handler.dart';
import 'package:image_picker/image_picker.dart';

import '../Model/request_model/check_in_status_request.dart';
import '../Model/request_model/end_visit_request.dart';
import '../Model/request_model/get_check_list_request.dart';
import '../Model/request_model/image_upload_insde_store_request.dart';
import '../Model/request_model/journey_plan_request.dart';
import '../Model/request_model/login_request.dart';
import '../Model/request_model/save_user_location_request.dart';
import '../Model/request_model/start_journey_plan_request.dart';
import '../Model/request_model/upload_check_list_photo_request.dart';
import '../Model/response_model/check_in_response/check_in_response.dart';
import '../Model/response_model/check_in_response/check_in_status_response.dart';
import '../Model/response_model/check_in_response/check_in_status_response_details.dart';
import '../Model/response_model/checklist_responses/check_list_response_list_model.dart';
import '../Model/response_model/journey_responses_plan/journey_plan_response_list.dart';
import '../Model/response_model/login_responses/login_response_model.dart';
import '../Model/response_model/my_coverage_response/uploaded_store_images_list_response.dart';
import 'api_urls.dart';

class HTTPManager {
  final ResponseHandler _handler = ResponseHandler();

  // IPS Location List
  Future<IpcLocationResponseModel> getIPCLocation() async {

    const url = ApplicationURLs.API_IPC_LOCATIONS;
    // ignore: avoid_print
    print(url);

    final response = await _handler.get(Uri.parse(url));
    IpcLocationResponseModel ipcLocationResponseModel = IpcLocationResponseModel.fromJson(response);

    return ipcLocationResponseModel;
  }

  //Save USer Current Location
  Future<dynamic> saveUserCurrentLocation(SaveUserLocationRequestModel saveUserLocationRequestModel) async {

    const url = ApplicationURLs.API_SAVE_USER_LOCATION;
    // ignore: avoid_print
    print(url);

    final response = await _handler.post(Uri.parse(url),saveUserLocationRequestModel.toJson());
    // IpcLocationResponseModel ipcLocationResponseModel = IpcLocationResponseModel.fromJson(response);

    return response;
  }

  //Check In Status
  Future<CheckInStatusResponseModel> getCheckInStatus(CheckInRequestModel checkInRequestModel) async {

    const url = ApplicationURLs.API_IPC_CHECK_IN_STATUS;
    // ignore: avoid_print
    print(url);

    final response = await _handler.post(Uri.parse(url),checkInRequestModel.toJson());
    CheckInStatusResponseModel checkInStatusResponseModel = CheckInStatusResponseModel.fromJson(response);

    return checkInStatusResponseModel;
  }

  //Check In
  Future<dynamic> setCheckIn(CheckInStatusUpdateRequestModel checkInStatusUpdateRequestModel,XFile image) async {

    const url = ApplicationURLs.API_IPC_CHECK_IN;
    // ignore: avoid_print
    print(url);

    final response = await _handler.postImage(url,checkInStatusUpdateRequestModel .toJson(),image);
    // CheckInStatusDetailsItem checkInStatusDetailsItem = CheckInStatusDetailsItem.fromJson(response['data'][0]);

    return response;
  }

  //Check Out
  Future<dynamic> setCheckOut(CheckOutStatusUpdateRequestModel checkOutStatusUpdateRequestModel) async {

    const url = ApplicationURLs.API_IPC_CHECK_OUT;
    // ignore: avoid_print
    print(url);

    final response = await _handler.post(Uri.parse(url),checkOutStatusUpdateRequestModel.toJson());
    // CheckInStatusDetailsItem checkInStatusDetailsItem = CheckInStatusDetailsItem.fromJson(response['data']);

    return response;
  }

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

  //Start Journey Plan
  Future<dynamic> checkListPostImage(UploadCheckListRequestModel uploadCheckListRequestModel,XFile photoFile) async {

    const url = ApplicationURLs.API_SAVE_CHECK_LIST_PHOTO;
    // ignore: avoid_print
    print(url);

    final response = await _handler.postImage(url, uploadCheckListRequestModel.toJson(),photoFile);
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

  //My Coverage Plan
  Future<dynamic> storeImagesUpload(ImageUploadInStoreRequestModel imageUploadInStoreRequestModel,XFile photoFile) async {

    const url = ApplicationURLs.API_PHOTO_UPLOAD_STORE;
    // ignore: avoid_print
    print(url);

    final response = await _handler.postImage(url, imageUploadInStoreRequestModel.toJson(),photoFile);
    // JourneyPlanResponseModel journeyPlanResponseModel = JourneyPlanResponseModel.fromJson(response);

    return response;
  }

  //My Coverage Plan Store Image List
  Future<StoreImageResponseModel> storeImagesList(UploadedImagesRequestModel uploadedImagesRequestModel) async {

    const url = ApplicationURLs.API_UPLOADED_PHOTO_STORE;
    // ignore: avoid_print
    print(url);

    final response = await _handler.post(Uri.parse(url), uploadedImagesRequestModel.toJson());
    StoreImageResponseModel storeImageResponseModel = StoreImageResponseModel.fromJson(response);

    return storeImageResponseModel;
  }

  //Store Image List Item
  Future<dynamic> storeImagesDelete(DeleteImageRequestModel deleteImageRequestModel) async {

    const url = ApplicationURLs.API_DELETE_PHOTO_STORE;
    // ignore: avoid_print
    print(url);

    final response = await _handler.post(Uri.parse(url), deleteImageRequestModel.toJson());
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
