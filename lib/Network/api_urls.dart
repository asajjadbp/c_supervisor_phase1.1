// ignore_for_file: constant_identifier_names

import 'package:c_supervisor/provider/license_provider.dart';

class ApplicationURLs {
  //Live Base URL
  // static const BASE_URL_APP = "https://cstore.catalist-me.com/CSupervisor/";
  // static const BASE_URL_APP = "https://cstoredev.catalist-me.com/CSupervisor/";

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
}
