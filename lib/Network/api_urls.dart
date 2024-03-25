// ignore_for_file: constant_identifier_names

import 'package:c_supervisor/provider/license_provider.dart';

class ApplicationURLs {
  //Live Base URL
  // static const BASE_URL_APP = "https://cstore.catalist-me.com/CSupervisor/";
  static const COMMON_LIST_API = "getControlListForSelectEL";

  String baseUrl = "";

  // void setBaseUrl(String baseValue) {
  //   // baseUrl = "${baseValue}CSupervisor/";
  //   baseUrl = baseValue;
  //   print("license set successfully");
  //   print(baseUrl);
  // }

  // String getBaseUrl() {
  //   return baseUrl;
  // }

  //Image Base URL
  // static const BASE_URL_IMAGE =
  //     "https://images.cstore.catalist-me.com/capture_photo/";

  // static var BASE_URL_IMAGE = LicenseProvider.imageBasePath;

  //IPS Location
  // static const API_IPC_LOCATIONS = "${BASE_URL_APP}checkInIPCLocations";
  static const API_IPC_LOCATIONS = "checkInIPCLocations";

  //Save Location After 20 min
  // static const API_SAVE_USER_LOCATION = "${BASE_URL_APP}saveLocation";
  static const API_SAVE_USER_LOCATION = "saveLocation";

  //Check In Status
  // static const API_IPC_CHECK_IN_STATUS = "${BASE_URL_APP}checkInStatus";
  static const API_IPC_CHECK_IN_STATUS = "checkInStatus";

  //TMR USER LIST
  static const API_TMR_USER_LIST = "elTmrs";

  //Clients LIST
  static const API_CLIENT_LIST = "elClients";

  //Stores LIST
  static const API_STORES_LIST = "elStores";

  //Companies LIST
  static const API_COMPANIES_LIST = "elCompanies";

  //Reasons List
  static const API_REASON_LIST = "specialVisitReason";

  //Special Visit List
  static const API_SPECIAL_VISIT_LIST = "viewSpecialVisits";

  //Save Special Visit
  static const API_SAVE_SPECIAL_VISIT = "saveSpecialVisit";

  //Delete Special Visit
  static const API_DELETE_SPECIAL_VISIT = "deleteSpecialVisit";

  //TMR Coverage LIST
  static const API_TMR_UPDATE_USER = "updateElCoverageTMR";

  //Check In
  // static const API_IPC_CHECK_IN = "${BASE_URL_APP}checkIn";
  static const API_IPC_CHECK_IN = "checkIn";

  //Check Out
  // static const API_IPC_CHECK_OUT = "${BASE_URL_APP}checkOut";
  static const API_IPC_CHECK_OUT = "checkOut";

  //Authentication
  // static const API_LOGIN = "${BASE_URL_APP}loginUser";
  static const API_LOGIN = "loginUser";

  //Journey Plan
  // static const API_JP = "${BASE_URL_APP}getJourneyPlan";
  static const API_JP = "getJourneyPlan";

  //Start Visit
  // static const API_START_VISIT = "${BASE_URL_APP}startVisit";
  static const API_START_VISIT = "startVisit";

  //Get Check List
  // static const API_CHECK_LIST = "${BASE_URL_APP}getChecklist";
  static const API_CHECK_LIST = "getChecklist";

  //Get Check List
  // static const API_UPDATE_CHECK_LIST = "${BASE_URL_APP}updateCheckList";
  static const API_UPDATE_CHECK_LIST = "updateCheckList";

  //Get Check List
  // static const API_SAVE_CHECK_LIST_PHOTO = "${BASE_URL_APP}saveCheckListPhoto";
  static const API_SAVE_CHECK_LIST_PHOTO = "saveCheckListPhoto";

  //My Coverage Plan
  // static const API_PHOTO_UPLOAD_STORE = "${BASE_URL_APP}takePhotoInsideStore";
  static const API_PHOTO_UPLOAD_STORE = "takePhotoInsideStore";

  //Store Image List
  // static const API_UPLOADED_PHOTO_STORE = "${BASE_URL_APP}getInStoreImages";
  static const API_UPLOADED_PHOTO_STORE = "getInStoreImages";

  //Store Selfie Availability
  static const API_SELFIE_AVAILABILITY = "getInStoreSelfie";

  //Visit History
  static const API_VISIT_HISTORY = "visitHistory";

  //EL Team JP List
  static const API_MY_TEAM_JP_LIST = "elTeamJP";

  //EL Team KPI List
  static const API_TEAM_KPI_LIST = "elTeamKPI";

  //Feed back drop down List
  static const API_GET_FEEDBACK_DROPDOWN_LIST = "getFeedBackReason";

  //Update efficiency feedback
  static const API_UPDATE_EFFICIENCY_FEEDBACK = "updateEffFeedback";

  //Delete Store Image
  // static const API_DELETE_PHOTO_STORE =
  // "${BASE_URL_APP}deleteInStoreCapturePhoto";
  static const API_DELETE_PHOTO_STORE = "deleteInStoreCapturePhoto";

  //End Visit
  // static const API_END_VISIT = "${BASE_URL_APP}endVisit";
  static const API_END_VISIT = "endVisit";

  // Getting Team Attendence
  static const API_TEAM_ATTENDENCE = "getUserAttendance";

// api update leave status
  static const API_UPDATE_LEAVE_STATUS = "updateLeaveStatus";

// api get knowledge share data
  static const API_KNOWLEDGE_SHARE = "getKnowledgeShare";

  //save device info
  static const API_DEVICE_INFO = "deviceDataCollection";

  //Business Trips url
  static const API_ADD_BUSINESS_TRIPS = "buisnessTrip";
  static const API_GET_BUSINESS_TRIPS = "getBuisnessTrip";
  static const API_UPDATE_BUSINESS_TRIPS = "updateBuisnessTrip";
  static const API_DELETE_BUSINESS_TRIPS = "deleteBuisnessTrip";

  //Recruit Suggest url
  static const API_ADD_RECRUIT_SUGGEST = "recruitSuggest";
  static const API_GET_RECRUIT_SUGGEST = "getRecruitSuggestion";
  static const API_UPDATE_RECRUIT_SUGGEST = "updateRecruitSuggestion";
  static const API_DELETE_RECRUIT_SUGGEST = "deleteRecruitSuggestion";

  //Time Motion url
  static const API_ADD_TIME_MOTION = "timeMotionStudy";
  static const API_GET_TIME_MOTION = "getTimeMotionStudy";
  static const API_UPDATE_TIME_MOTION = "updateTimeMotionStudy";
  static const API_DELETE_TIME_MOTION = "deleteTimeMotionStudy";
}
