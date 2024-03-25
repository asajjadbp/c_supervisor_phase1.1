// ignore_for_file: avoid_print, duplicate_ignore

import 'dart:io';
import 'dart:math';

import 'package:c_supervisor/Model/request_model/business_trips.dart';
import 'package:c_supervisor/Model/request_model/get_attendence_request.dart';
import 'package:c_supervisor/Model/request_model/knowledge_share_request.dart';
import 'package:c_supervisor/Model/request_model/myconverter.dart';
import 'package:c_supervisor/Model/request_model/recruit_suggest.dart';
import 'package:c_supervisor/Model/request_model/time_motion.dart';
import 'package:c_supervisor/Model/request_model/update_attendence_response.dart';
import 'package:c_supervisor/Model/response_model/attendence_response/attendence_response.dart';
import 'package:c_supervisor/Model/response_model/attendence_response/update_attendence_response.dart';
import 'package:c_supervisor/Model/response_model/business_trips_response/business_trips_list_model.dart';
import 'package:c_supervisor/Model/response_model/knowledge_share/knowledge_share_model.dart';
import 'package:c_supervisor/Model/response_model/my_team_responses/my_team_jp_responses/my_team_jp_list_response.dart';
import 'package:c_supervisor/Model/response_model/my_team_responses/team_kpi_reponses/team_kpi_list_response_model.dart';
import 'package:c_supervisor/Model/response_model/recruit_suggest_responses/recruit_suggest_list_model.dart';
import 'package:c_supervisor/Model/response_model/time_motion_response/time_motion_list_response_model.dart';
import 'package:c_supervisor/Network/response_handler.dart';
import 'package:c_supervisor/provider/license_provider.dart';
import 'package:image_picker/image_picker.dart';

import '../Model/request_model/check_in_status_request.dart';
import '../Model/request_model/common_api_call_request.dart';
import '../Model/request_model/delete_special_visit.dart';
import '../Model/request_model/device_info_request.dart';
import '../Model/request_model/end_visit_request.dart';
import '../Model/request_model/get_check_list_request.dart';
import '../Model/request_model/image_upload_insde_store_request.dart';
import '../Model/request_model/journey_plan_request.dart';
import '../Model/request_model/login_request.dart';
import '../Model/request_model/save_special_visit.dart';
import '../Model/request_model/save_user_location_request.dart';
import '../Model/request_model/start_journey_plan_request.dart';
import '../Model/request_model/update_efficiency_feedback_request_model.dart';
import '../Model/request_model/update_tmr_user_in_coverage.dart';
import '../Model/request_model/upload_check_list_photo_request.dart';
import '../Model/response_model/check_in_response/check_in_response.dart';
import '../Model/response_model/check_in_response/check_in_status_response_details.dart';
import '../Model/response_model/checklist_responses/check_list_response_list_model.dart';
import '../Model/response_model/common_list/comon_list_response_model.dart';
import '../Model/response_model/journey_responses_plan/journey_plan_response_list.dart';
import '../Model/response_model/login_responses/login_response_model.dart';
import '../Model/response_model/my_coverage_response/uploaded_store_images_list_response.dart';
import '../Model/response_model/my_team_responses/add_special_visit/client_list_model_response.dart';
import '../Model/response_model/my_team_responses/add_special_visit/companies_list_model_response.dart';
import '../Model/response_model/my_team_responses/add_special_visit/reason_list_model_response.dart';
import '../Model/response_model/my_team_responses/add_special_visit/special_visit_list_model_response.dart';
import '../Model/response_model/my_team_responses/add_special_visit/store_list_model_response.dart';
import '../Model/response_model/my_team_responses/team_kpi_reponses/feedback_list_response_model.dart';
import '../Model/response_model/my_team_responses/visits_history_responses/visit_history_list_model.dart';
import '../Model/response_model/tmr_responses/tmr_list_response.dart';
import 'api_urls.dart';

class HTTPManager {
  final ResponseHandler _handler = ResponseHandler();

  // IPS Location List
  Future<IpcLocationResponseModel> getIPCLocation() async {
    var url = LicenseProvider.basepath + ApplicationURLs.API_IPC_LOCATIONS;
    // var url = ApplicationURLs.API_IPC_LOCATIONS;
    // ignore: avoid_print
    print(url);

    final response = await _handler.get(Uri.parse(url));
    IpcLocationResponseModel ipcLocationResponseModel =
        IpcLocationResponseModel.fromJson(response);

    return ipcLocationResponseModel;
  }

  //Save USer Current Location
  Future<dynamic> saveUserCurrentLocation(
      SaveUserLocationRequestModel saveUserLocationRequestModel) async {
    // var url = ApplicationURLs.API_SAVE_USER_LOCATION;
    var url = LicenseProvider.basepath + ApplicationURLs.API_SAVE_USER_LOCATION;
    // ignore: avoid_print
    print(url);

    final response = await _handler.post(
        Uri.parse(url), saveUserLocationRequestModel.toJson());
    // IpcLocationResponseModel ipcLocationResponseModel = IpcLocationResponseModel.fromJson(response);

    return response;
  }

  //Check In Status
  Future<CheckInStatusResponseModel> getCheckInStatus(
      CheckInRequestModel checkInRequestModel) async {
    // var url = ApplicationURLs.API_IPC_CHECK_IN_STATUS;
    var url =
        LicenseProvider.basepath + ApplicationURLs.API_IPC_CHECK_IN_STATUS;
    // ignore: avoid_print
    print("object+++++++++++");
    print(url);

    final response =
        await _handler.post(Uri.parse(url), checkInRequestModel.toJson());
    CheckInStatusResponseModel checkInStatusResponseModel =
        CheckInStatusResponseModel.fromJson(response);
    print("object--------------------");
    return checkInStatusResponseModel;
  }

  //Check In
  Future<dynamic> setCheckIn(
      CheckInStatusUpdateRequestModel checkInStatusUpdateRequestModel,
      XFile image) async {
    // var url = ApplicationURLs.API_IPC_CHECK_IN;
    var url = LicenseProvider.basepath + ApplicationURLs.API_IPC_CHECK_IN;
    // ignore: avoid_print
    print(url);

    final response = await _handler.postImage(
        url, checkInStatusUpdateRequestModel.toJson(), image);
    // CheckInStatusDetailsItem checkInStatusDetailsItem = CheckInStatusDetailsItem.fromJson(response['data'][0]);

    return response;
  }

  //Check Out
  Future<dynamic> setCheckOut(
      CheckOutStatusUpdateRequestModel checkOutStatusUpdateRequestModel) async {
    // var url = ApplicationURLs.API_IPC_CHECK_OUT;
    var url = LicenseProvider.basepath + ApplicationURLs.API_IPC_CHECK_OUT;
    // ignore: avoid_print
    print(url);

    final response = await _handler.post(
        Uri.parse(url), checkOutStatusUpdateRequestModel.toJson());
    // CheckInStatusDetailsItem checkInStatusDetailsItem = CheckInStatusDetailsItem.fromJson(response['data']);

    return response;
  }

  Future<LogInResponseModel> loginUser(
      LoginRequestModel loginRequestModel) async {
    // print(LicenseProvider.basepath);

    // print(ApplicationURLs().getBaseUrl());
    // var url = ApplicationURLs.API_LOGIN;
    var url = LicenseProvider.basepath + ApplicationURLs.API_LOGIN;

    print(url);

    final response =
        await _handler.post(Uri.parse(url), loginRequestModel.toJson());
    LogInResponseModel logInResponseModel =
        LogInResponseModel.fromJson(response);

    return logInResponseModel;
  }

  //TMR USER LIST
  Future<TmrUserList> tmrUserList(
      JourneyPlanRequestModel journeyPlanRequestModel) async {
    // var url = ApplicationURLs.API_JP;
    var url = LicenseProvider.basepath + ApplicationURLs.API_TMR_USER_LIST;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url), journeyPlanRequestModel.toJson());
    TmrUserList tmrUserList =
    TmrUserList.fromJson(response);

    return tmrUserList;
  }

  //CLIENTS LIST
  Future<ClientListResponseModel> clientList(
      JourneyPlanRequestModel journeyPlanRequestModel) async {
    // var url = ApplicationURLs.API_JP;
    var url = LicenseProvider.basepath + ApplicationURLs.API_CLIENT_LIST;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url), journeyPlanRequestModel.toJson());
    ClientListResponseModel clientListResponseModel =
    ClientListResponseModel.fromJson(response);

    return clientListResponseModel;
  }

  //STORE LIST
  Future<StoresListResponseModel> storeList(
      JourneyPlanRequestModel journeyPlanRequestModel) async {
    // var url = ApplicationURLs.API_JP;
    var url = LicenseProvider.basepath + ApplicationURLs.API_STORES_LIST;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url), journeyPlanRequestModel.toJson());
    StoresListResponseModel storesListResponseModel =
    StoresListResponseModel.fromJson(response);

    return storesListResponseModel;
  }

  //COMPANY LIST
  Future<CompaniesListResponseModel> companyList(
      JourneyPlanRequestModel journeyPlanRequestModel) async {
    // var url = ApplicationURLs.API_JP;
    var url = LicenseProvider.basepath + ApplicationURLs.API_COMPANIES_LIST;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url), journeyPlanRequestModel.toJson());
    CompaniesListResponseModel companiesListResponseModel =
    CompaniesListResponseModel.fromJson(response);

    return companiesListResponseModel;
  }

  //REASON LIST
  Future<ReasonListResponseModel> reasonList() async {
    // var url = ApplicationURLs.API_JP;
    var url = LicenseProvider.basepath + ApplicationURLs.API_REASON_LIST;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.get(Uri.parse(url));
    ReasonListResponseModel reasonListResponseModel =
    ReasonListResponseModel.fromJson(response);

    return reasonListResponseModel;
  }

  // SPECIAL VISIT LIST
  Future<SpecialVisitListResponseModel> specialVisitList(JourneyPlanRequestModel journeyPlanRequestModel) async {
    // var url = ApplicationURLs.API_JP;
    var url = LicenseProvider.basepath + ApplicationURLs.API_SPECIAL_VISIT_LIST;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),journeyPlanRequestModel.toJson());
    SpecialVisitListResponseModel specialVisitListResponseModel =
    SpecialVisitListResponseModel.fromJson(response);

    return specialVisitListResponseModel;
  }

  // SAVE SPECIAL VISIT
  Future<dynamic> saveSpecialVisit(SaveSpecialVisitRequestModel specialVisitRequestModel) async {
    // var url = ApplicationURLs.API_JP;
    var url = LicenseProvider.basepath + ApplicationURLs.API_SAVE_SPECIAL_VISIT;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),specialVisitRequestModel.toJson());

    return response;
  }

  // DELETE SPECIAL VISIT
  Future<dynamic> deleteSpecialVisit(DeleteSpecialVisitRequestModel deleteSpecialVisitRequestModel) async {
    // var url = ApplicationURLs.API_JP;
    var url = LicenseProvider.basepath + ApplicationURLs.API_DELETE_SPECIAL_VISIT;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),deleteSpecialVisitRequestModel.toJson());

    return response;
  }

  //Start Journey Plan
  Future<dynamic> updateTmrUserCoverage(
      UpdateTmrUserInCoverage updateTmrUserInCoverage) async {
    // var url = ApplicationURLs.API_START_VISIT;
    var url = LicenseProvider.basepath + ApplicationURLs.API_TMR_UPDATE_USER;
    // ignore: avoid_print
    print(url);

    final response = await _handler.post(
        Uri.parse(url), updateTmrUserInCoverage.toJson());
    // JourneyPlanResponseModel journeyPlanResponseModel = JourneyPlanResponseModel.fromJson(response);

    return response;
  }

  //Journey Plan List
  Future<JourneyPlanResponseModel> userJourneyPlanList(
      JourneyPlanRequestModel journeyPlanRequestModel) async {
    // var url = ApplicationURLs.API_JP;
    var url = LicenseProvider.basepath + ApplicationURLs.API_JP;
    // ignore: avoid_print
    print("journey plan");
    print(url);

    final response =
        await _handler.post(Uri.parse(url), journeyPlanRequestModel.toJson());
    JourneyPlanResponseModel journeyPlanResponseModel =
        JourneyPlanResponseModel.fromJson(response);

    return journeyPlanResponseModel;
  }

  //Start Journey Plan
  Future<dynamic> startJourneyPlan(
      StartJourneyPlanRequestModel startJourneyPlanRequestModel,
      XFile photoFile) async {
    // var url = ApplicationURLs.API_START_VISIT;
    var url = LicenseProvider.basepath + ApplicationURLs.API_START_VISIT;
    // ignore: avoid_print
    print(url);

    final response = await _handler.postImage(
        url, startJourneyPlanRequestModel.toJson(), photoFile);
    // JourneyPlanResponseModel journeyPlanResponseModel = JourneyPlanResponseModel.fromJson(response);

    return response;
  }

  //Start Journey Plan
  Future<dynamic> checkListPostImage(
      UploadCheckListRequestModel uploadCheckListRequestModel,
      XFile photoFile) async {
    var url =
        LicenseProvider.basepath + ApplicationURLs.API_SAVE_CHECK_LIST_PHOTO;
    // var url = ApplicationURLs.API_SAVE_CHECK_LIST_PHOTO;
    // ignore: avoid_print
    print(url);

    final response = await _handler.postImage(
        url, uploadCheckListRequestModel.toJson(), photoFile);
    // JourneyPlanResponseModel journeyPlanResponseModel = JourneyPlanResponseModel.fromJson(response);

    return response;
  }

  //Get Check List
  Future<CheckListResponseModel> getCheckList(
      GetCheckListRequest getCheckListRequest) async {
    // var url = ApplicationURLs.API_CHECK_LIST;

    var url = LicenseProvider.basepath + ApplicationURLs.API_CHECK_LIST;
    // ignore: avoid_print
    print(url);

    final response =
        await _handler.post(Uri.parse(url), getCheckListRequest.toJson());
    CheckListResponseModel checkListResponseModel =
        CheckListResponseModel.fromJson(response);

    return checkListResponseModel;
  }

  //update Check List
  Future<dynamic> updateCheckListWithJson(CheckListResponseModel param) async {
    // var url = ApplicationURLs.API_UPDATE_CHECK_LIST;
    var url = LicenseProvider.basepath + ApplicationURLs.API_UPDATE_CHECK_LIST;
    // ignore: avoid_print
    print(url);

    final response = await _handler.postWithJsonRequest(Uri.parse(url), param);
    // JourneyPlanResponseModel journeyPlanResponseModel = JourneyPlanResponseModel.fromJson(response);

    return response;
  }

  //My Coverage Plan
  Future<dynamic> storeImagesUpload(
      ImageUploadInStoreRequestModel imageUploadInStoreRequestModel,
      XFile photoFile) async {
    // var url = ApplicationURLs.API_PHOTO_UPLOAD_STORE;

    var url = LicenseProvider.basepath + ApplicationURLs.API_PHOTO_UPLOAD_STORE;
    // ignore: avoid_print
    print(url);

    final response = await _handler.postImage(
        url, imageUploadInStoreRequestModel.toJson(), photoFile);
    // JourneyPlanResponseModel journeyPlanResponseModel = JourneyPlanResponseModel.fromJson(response);

    return response;
  }

  //My Coverage Plan Store Image List
  Future<StoreImageResponseModel> storeImagesList(
      UploadedImagesRequestModel uploadedImagesRequestModel) async {
    // var url = ApplicationURLs.API_UPLOADED_PHOTO_STORE;

    var url =
        LicenseProvider.basepath + ApplicationURLs.API_UPLOADED_PHOTO_STORE;
    // ignore: avoid_print
    print(url);

    final response = await _handler.post(
        Uri.parse(url), uploadedImagesRequestModel.toJson());
    StoreImageResponseModel storeImageResponseModel =
        StoreImageResponseModel.fromJson(response);

    return storeImageResponseModel;
  }

  //My Journey Plan Store Selfie Availability
  Future<StoreSelfieAvailabilityResponseModel> storeSelfieAvailability(
      UploadedImagesRequestModel uploadedImagesRequestModel) async {
    // var url = ApplicationURLs.API_UPLOADED_PHOTO_STORE;

    var url =
        LicenseProvider.basepath + ApplicationURLs.API_SELFIE_AVAILABILITY;
    // ignore: avoid_print
    print(url);

    final response = await _handler.post(
        Uri.parse(url), uploadedImagesRequestModel.toJson());
    StoreSelfieAvailabilityResponseModel selfieAvailabilityResponseModel =
    StoreSelfieAvailabilityResponseModel.fromJson(response);

    return selfieAvailabilityResponseModel;
  }

  //Store Image List Item
  Future<dynamic> storeImagesDelete(
      DeleteImageRequestModel deleteImageRequestModel) async {
    // var url = ApplicationURLs.API_DELETE_PHOTO_STORE;

    var url = LicenseProvider.basepath + ApplicationURLs.API_DELETE_PHOTO_STORE;
    // ignore: avoid_print
    print(url);

    final response =
        await _handler.post(Uri.parse(url), deleteImageRequestModel.toJson());
    // JourneyPlanResponseModel journeyPlanResponseModel = JourneyPlanResponseModel.fromJson(response);

    return response;
  }

  //End Visit
  Future<dynamic> endVisit(EndVisitRequestModel endVisitRequestModel) async {
    // var url = ApplicationURLs.API_END_VISIT;

    var url = LicenseProvider.basepath + ApplicationURLs.API_END_VISIT;
    // ignore: avoid_print
    print(url);

    final response =
        await _handler.post(Uri.parse(url), endVisitRequestModel.toJson());
    // JourneyPlanResponseModel journeyPlanResponseModel = JourneyPlanResponseModel.fromJson(response);

    return response;
  }

// This will get data of attendence of employee
  Future<GetAttendenceResponseModel> teamAttendence(
      GetAttendenceRequestModel getAttendenceRequestModel) async {
    // var url = ApplicationURLs.API_JP;
    var url = LicenseProvider.basepath + ApplicationURLs.API_TEAM_ATTENDENCE;
    // ignore: avoid_print
    print(url);
    final response =
        await _handler.post(Uri.parse(url), getAttendenceRequestModel.toJson());
    GetAttendenceResponseModel attendenceResponseModel =
        GetAttendenceResponseModel.fromJson(response);

    return attendenceResponseModel;
  }

// for updating employee attendence
  Future<UpdateAttendenceResponseModel> updateAttendence(
      UpdateAttendenceRequestModel updateAttendenceRequestModel) async {
    // print(updateAttendenceRequestModel.elId);
    // print(updateAttendenceRequestModel.isPresent);
    // print(updateAttendenceRequestModel.userRecordId);
    // print("++++++++++++++");
    var url =
        LicenseProvider.basepath + ApplicationURLs.API_UPDATE_LEAVE_STATUS;

    print("The value passing to api is ");
    print(updateAttendenceRequestModel.isPresent);

    final response = await _handler.post(
        Uri.parse(url),
        UpdateAttendanceConverter.requestToUpdateAttendance(
            updateAttendenceRequestModel)
        // updateAttendenceRequestModel.toJson()
        );

    UpdateAttendenceResponseModel updateAttendenceResponseModel =
        UpdateAttendenceResponseModel.fromJson(response);
    return updateAttendenceResponseModel;
  }

  Future<KnowledgeShareResponseModel> getKnowledgeShare(
      KnowledgeShareRequestModel knowledgeShareRequestModel) async {
    var url = LicenseProvider.basepath + ApplicationURLs.API_KNOWLEDGE_SHARE;

    final response = await _handler.post(
        Uri.parse(url), knowledgeShareRequestModel.toJson());
    KnowledgeShareResponseModel knowledgeShareResponseModel =
        KnowledgeShareResponseModel.fromJson(response);
    return knowledgeShareResponseModel;
  }

  /// MY Team API calls From Here

  //Visits History
  Future<VisitsHistoryResponseModel> getVisitHistoryList(
      JourneyPlanRequestModel journeyPlanRequestModel) async {
    var url = LicenseProvider.basepath + ApplicationURLs.API_VISIT_HISTORY;
    print(url);
    final response = await _handler.post(
        Uri.parse(url), journeyPlanRequestModel.toJson());
    VisitsHistoryResponseModel visitsHistoryResponseModel =
    VisitsHistoryResponseModel.fromJson(response);
    return visitsHistoryResponseModel;
  }

  //Team KPI
  Future<TeamKpiResponseModel> getMyTeamKpiList(
      JourneyPlanRequestModel journeyPlanRequestModel) async {
    var url = LicenseProvider.basepath + ApplicationURLs.API_TEAM_KPI_LIST;

    final response = await _handler.post(
        Uri.parse(url), journeyPlanRequestModel.toJson());
    TeamKpiResponseModel teamKpiResponseModel =
    TeamKpiResponseModel.fromJson(response);
    return teamKpiResponseModel;
  }

  //Team JP
  Future<MyTeamJpResponseModel> getMyTeamJpList(
      JourneyPlanRequestModel journeyPlanRequestModel) async {
    var url = LicenseProvider.basepath + ApplicationURLs.API_MY_TEAM_JP_LIST;

    final response = await _handler.post(
        Uri.parse(url), journeyPlanRequestModel.toJson());
    MyTeamJpResponseModel myTeamJpResponseModel =
    MyTeamJpResponseModel.fromJson(response);
    return myTeamJpResponseModel;
  }

  //Feedback dropdown list
  Future<FeedbackListResponseModel> getFeedBackList() async {
    var url = LicenseProvider.basepath + ApplicationURLs.API_GET_FEEDBACK_DROPDOWN_LIST;

    final response = await _handler.get(
        Uri.parse(url));
    FeedbackListResponseModel feedbackListResponseModel =
    FeedbackListResponseModel.fromJson(response);
    return feedbackListResponseModel;
  }

  //update Feedback in KPI
  Future<dynamic> updateFeedBackInKpi(
      UpdateEfficiencyFeedbackRequestModel updateEfficiencyFeedbackRequestModel) async {
    var url = LicenseProvider.basepath + ApplicationURLs.API_UPDATE_EFFICIENCY_FEEDBACK;

    final response = await _handler.post(
        Uri.parse(url), updateEfficiencyFeedbackRequestModel.toJson());

    return response;
  }


  //Save Device Info
  Future<dynamic> saveDeviceInfo(
      DeviceInfoRequestModel deviceInfoRequestModel) async {
    var url = LicenseProvider.basepath + ApplicationURLs.API_DEVICE_INFO;
    print(url);

    final response = await _handler.post(
        Uri.parse(url), deviceInfoRequestModel.toJson());

    return response;
  }

  /// Business Trips Api Calls

  Future<BusinessTripsListModel> getBusinessTrips(JourneyPlanRequestModel journeyPlanRequestModel) async {
    var url = LicenseProvider.basepath + ApplicationURLs.API_GET_BUSINESS_TRIPS;
    print(url);

    final response = await _handler.post(
        Uri.parse(url), journeyPlanRequestModel.toJson());

    BusinessTripsListModel businessTripsListModel = BusinessTripsListModel.fromJson(response);

    return businessTripsListModel;
  }

  Future<dynamic> addBusinessTrips(AddBusinessTripsRequestModel addBusinessTripsRequestModel,List<File> filesList) async {
    var url = LicenseProvider.basepath + ApplicationURLs.API_ADD_BUSINESS_TRIPS;
    print(url);

    final response = await _handler.postImageForAddBusinessScreen(url, addBusinessTripsRequestModel.toJson(),filesList);

    return response;
  }

  Future<dynamic> updateBusinessTripsWithFiles(UpdateBusinessTripsRequestModel updateBusinessTripsRequestModel,List<File> filesList) async {
    print(updateBusinessTripsRequestModel.toCity);
    print(updateBusinessTripsRequestModel.fromCity);
    var url = LicenseProvider.basepath + ApplicationURLs.API_UPDATE_BUSINESS_TRIPS;
    print(url);

    final response = await _handler.postImageForAddBusinessScreen(url, updateBusinessTripsRequestModel.toJson(), filesList);

    return response;
  }

  Future<dynamic> updateBusinessTripsWithOutFiles(UpdateBusinessTripsRequestModel updateBusinessTripsRequestModel) async {
    print(updateBusinessTripsRequestModel.toCity);
    print(updateBusinessTripsRequestModel.fromCity);

    var url = LicenseProvider.basepath + ApplicationURLs.API_UPDATE_BUSINESS_TRIPS;
    print(url);

    final response = await _handler.postWithBothString(Uri.parse(url), updateBusinessTripsRequestModel.toJson());

    return response;
  }

  Future<dynamic> deleteBusinessTrips(DeleteBusinessTripsRequestModel deleteBusinessTripsRequestModel) async {
    var url = LicenseProvider.basepath + ApplicationURLs.API_DELETE_BUSINESS_TRIPS;
    print(url);

    final response = await _handler.post(
        Uri.parse(url), deleteBusinessTripsRequestModel.toJson());

    return response;
  }

  /// Time Motion Api Calls

  Future<TimeMotionListModel> getTimeMotion(JourneyPlanRequestModel journeyPlanRequestModel) async {
    var url = LicenseProvider.basepath + ApplicationURLs.API_GET_TIME_MOTION;
    print(url);

    final response = await _handler.post(
        Uri.parse(url), journeyPlanRequestModel.toJson());
    TimeMotionListModel timeMotionListModel = TimeMotionListModel.fromJson(response);
    return timeMotionListModel;
  }

  Future<dynamic> addTimeMotion(AddTimeMotionRequestModel addTimeMotionRequestModel) async {
    var url = LicenseProvider.basepath + ApplicationURLs.API_ADD_TIME_MOTION;
    print(url);

    final response = await _handler.post(
        Uri.parse(url), addTimeMotionRequestModel.toJson());

    return response;
  }

  Future<dynamic> updateTimeMotion(UpdateTimeMotionRequestModel updateTimeMotionRequestModel) async {
    var url = LicenseProvider.basepath + ApplicationURLs.API_UPDATE_TIME_MOTION;
    print(url);

    final response = await _handler.post(
        Uri.parse(url), updateTimeMotionRequestModel.toJson());

    return response;
  }

  Future<dynamic> deleteTimeMotion(DeleteTimeMotionRequestModel deleteTimeMotionRequestModel) async {
    var url = LicenseProvider.basepath + ApplicationURLs.API_DELETE_TIME_MOTION;
    print(url);

    final response = await _handler.post(
        Uri.parse(url), deleteTimeMotionRequestModel.toJson());

    return response;
  }

  /// Recruit Suggest Api Calls

  Future<RecruitSuggestListModel> getRecruitSuggest(JourneyPlanRequestModel journeyPlanRequestModel) async {
    var url = LicenseProvider.basepath + ApplicationURLs.API_GET_RECRUIT_SUGGEST;
    print(url);

    final response = await _handler.post(
        Uri.parse(url), journeyPlanRequestModel.toJson());
    RecruitSuggestListModel recruitSuggestListModel = RecruitSuggestListModel.fromJson(response);
    return recruitSuggestListModel;
  }

  Future<dynamic> addRecruitSuggest(AddRecruitSuggestRequestModel addRecruitSuggestRequestModel,File file) async {
    var url = LicenseProvider.basepath + ApplicationURLs.API_ADD_RECRUIT_SUGGEST;
    print(url);

    final response = await _handler.postImageForAddRecruitSuggestScreen(
        Uri.parse(url), addRecruitSuggestRequestModel.toJson(),file);

    return response;
  }

  Future<dynamic> updateRecruitSuggestWithFile(UpdateRecruitSuggestRequestModel updateRecruitSuggestRequestModel,File file) async {
    var url = LicenseProvider.basepath + ApplicationURLs.API_UPDATE_RECRUIT_SUGGEST;
    print(url);

      final response = await _handler.postImageForAddRecruitSuggestScreen(
          Uri.parse(url), updateRecruitSuggestRequestModel.toJson(), file);
      return response;

  }

  Future<dynamic> updateRecruitSuggestWithoutFile(UpdateRecruitSuggestRequestModel updateRecruitSuggestRequestModel, ) async {
    var url = LicenseProvider.basepath + ApplicationURLs.API_UPDATE_RECRUIT_SUGGEST;
    print(url);

      final response = await _handler.postWithBothString(
          Uri.parse(url), updateRecruitSuggestRequestModel.toJson());
      return response;

  }

  Future<dynamic> deleteRecruitSuggest(DeleteRecruitSuggestRequestModel deleteRecruitSuggestRequestModel) async {
    var url = LicenseProvider.basepath + ApplicationURLs.API_DELETE_RECRUIT_SUGGEST;
    print(url);

    final response = await _handler.post(
        Uri.parse(url), deleteRecruitSuggestRequestModel.toJson());

    return response;
  }


  /// Common List ApI Call

  Future<CommonListModel> commonApiCallForList(CommonApiCallRequestModel commonApiCallRequestModel) async {
    var url = LicenseProvider.basepath + ApplicationURLs.COMMON_LIST_API;
    print(url);

    final response = await _handler.post(
        Uri.parse(url), commonApiCallRequestModel.toJson());
    CommonListModel commonListModel = CommonListModel.fromJson(response);

    return commonListModel;
  }


}
