// ignore_for_file: constant_identifier_names

class ApplicationURLs {

  //Live Base URL
   static const BASE_URL_APP = "https://cstoretest.catalist-me.com/CSupervisor/";

   //Image Base URL
   static const BASE_URL_IMAGE = "https://images.catalystmea.com/visits/";

   //IPS Location
   static const API_IPC_LOCATIONS = "${BASE_URL_APP}checkInIPCLocations";

   //Save Location After 20 min
   static const API_SAVE_USER_LOCATION = "${BASE_URL_APP}saveLocation";

   //Check In Status
   static const API_IPC_CHECK_IN_STATUS = "${BASE_URL_APP}checkInStatus";

   //Check In
   static const API_IPC_CHECK_IN = "${BASE_URL_APP}checkIn";

   //Check Out
   static const API_IPC_CHECK_OUT = "${BASE_URL_APP}checkOut";

  //Authentication
  static const API_LOGIN = "${BASE_URL_APP}loginUser";

  //Journey Plan
  static const API_JP = "${BASE_URL_APP}getJourneyPlan";

  //Start Visit
  static const API_START_VISIT = "${BASE_URL_APP}startVisit";

   //Get Check List
   static const API_CHECK_LIST = "${BASE_URL_APP}getChecklist";

   //Get Check List
   static const API_UPDATE_CHECK_LIST = "${BASE_URL_APP}updateCheckList";

   //Get Check List
   static const API_SAVE_CHECK_LIST_PHOTO = "${BASE_URL_APP}saveCheckListPhoto";

   //My Coverage Plan
   static const API_PHOTO_UPLOAD_STORE = "${BASE_URL_APP}takePhotoInsideStore";

   //Store Image List
   static const API_UPLOADED_PHOTO_STORE = "${BASE_URL_APP}getInStoreImages";

   //Delete Store Image
   static const API_DELETE_PHOTO_STORE = "${BASE_URL_APP}deleteInStoreCapturePhoto";

   //End Visit
   static const API_END_VISIT = "${BASE_URL_APP}endVisit";

}
