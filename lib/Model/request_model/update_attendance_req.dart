import 'package:c_supervisor/Model/request_model/update_attendence_response.dart';

class UpdateAttendanceConverter {
  static Map<String, dynamic> requestToUpdateAttendance(
      UpdateAttendenceRequestModel updateAttendenceRequestModel) {
    Map<String, dynamic> myMap = {
      "el_id": updateAttendenceRequestModel.elId,
      "user_record_id": updateAttendenceRequestModel.userRecordId,
      // "is_present": updateAttendenceRequestModel.isPresent
      "att_changed": updateAttendenceRequestModel.attChanged,
      "id": updateAttendenceRequestModel.id
    };
    return myMap;
  }
}
