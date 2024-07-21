import 'package:c_supervisor/Model/request_model/update_attendence_response.dart';
import 'package:c_supervisor/Model/response_model/attendence_response/attendance_types.dart';
import 'package:c_supervisor/Screens/utills/app_colors_new.dart';
import 'package:c_supervisor/Screens/widgets/toast_message_show.dart';
import 'package:c_supervisor/provider/license_provider.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Network/http_manager.dart';
import '../utills/user_constants.dart';

class AttendanceCard extends StatefulWidget {
  final String employeeName;
  final String employeeFirstName;
  final String employeeLastName;
  final String employeeId;
  final String location;
  final String imageUrl;
  final String checkInTime;
  final String userId;
  final String userRecordId;
  final int employeeAttendance;
  // final String updateByEl;
  final String previousAttendance;
  Function updateAttendanceView;
  List<AttendanceTypeData> attendanceType;

  AttendanceCard(
      {super.key,
      required this.employeeId,
      required this.employeeName,
      required this.employeeFirstName,
      required this.employeeLastName,
      required this.location,
      required this.imageUrl,
      required this.checkInTime,
      required this.userId,
      required this.userRecordId,
      required this.employeeAttendance,
      // required this.updateByEl,
      required this.updateAttendanceView,
      required this.attendanceType,
      required this.previousAttendance});

  @override
  State<AttendanceCard> createState() => _AttendanceCardState();
}

class _AttendanceCardState extends State<AttendanceCard> {
  int _groupValue = -1;

  String _currentValue = "-1";
  bool isBottomSheetLoading = false;

  Future<void> submitAttendenceForm(
      UpdateAttendenceRequestModel updateAttendenceRequestModel) async {
    // if (updateAttendenceRequestModel.isPresent == "-1") {
    //   showToastMessage(false, "Please select any option");
    //   return;
    // }

    // print(updateAttendenceRequestModel.isPresent);
    // print(updateAttendenceRequestModel.attChanged);
    // print("The present status value is ");
    // print(updateAttendenceRequestModel.userRecordId);
    // print("user record id is above");

    setState(() {
      isBottomSheetLoading = true;
    });
    HTTPManager().updateAttendence(updateAttendenceRequestModel).then((value) {
      setState(() {
        isBottomSheetLoading = false;
      });
      if (value.status) {
        Navigator.of(context).pop();
        showToastMessage(true, value.msg);
        widget.updateAttendanceView();
      }
    }).catchError((onError) {
      setState(() {
        isBottomSheetLoading = false;
      });
      showToastMessage(false, onError.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shadowColor: Colors.black12,
        elevation: 10,
        // shape: const RoundedRectangleBorder(
        //   borderRadius: BorderRadius.only(
        //       topLeft: Radius.circular(10.0),
        //       bottomRight: Radius.circular(10.0),
        //       topRight: Radius.circular(10.0),
        //       bottomLeft: Radius.circular(10.0)),
        // ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, top: 10.0, bottom: 10.0, right: 10.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child:
                      // widget.imageUrl == ""
                      //     ?
                      Image.asset(
                    "assets/myicons/person.jpeg",
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                  )
                  // :
                  //  Image.network(
                  //     LicenseProvider.imageBasePath + widget.imageUrl,
                  //     height: 100,
                  //     width: 100,
                  //     fit: BoxFit.cover,
                  //   ),
                  ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row(
                      //   children: [
                      //     Text(
                      //       widget.employeeName,
                      //       style: const TextStyle(fontWeight: FontWeight.bold),
                      //     ),
                      //   ],
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Text(
                              widget.employeeFirstName,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 5.0),
                      //   child: Text(
                      //     widget.employeeLastName,
                      //     style: const TextStyle(fontWeight: FontWeight.bold),
                      //   ),
                      // ),
                      // Wrap(
                      //   spacing: 2.0,
                      //   direction: Axis.horizontal,
                      //   alignment: WrapAlignment.start,
                      //   children: employeeNameList.map((itm) => Text(itm)).toList(),
                      // ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 5, top: 3, bottom: 3),
                        child: Text(
                          "ID: ${widget.employeeId}",
                          style: const TextStyle(color: AppColors.primaryColor
                              // color: AppColors.paleyellow,
                              // fontWeight: FontWeight.bold
                              ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Row(
                          children: [
                            const Text(
                              "Status: ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(widget.previousAttendance)
                            // Text(widget.checkInTime.isEmpty
                            //     ? "Absent"
                            //     : widget.checkInTime)
                          ],
                        ),
                      ),

                      Row(
                        children: [
                          const Icon(
                            Icons.watch_later,
                            color: AppColors.primaryColor,
                          ),

                          const SizedBox(width: 3),
                          widget.checkInTime.isNotEmpty
                              ? Text(widget.checkInTime)
                              : const Text("--:--"),
                          // const SizedBox(width: 6),
                          // Text(widget.previousAttendance)
                          // Text(widget.checkInTime.isEmpty
                          //     ? "Absent"
                          //     : widget.checkInTime)
                        ],
                      )
                    ],
                  ),
                  Column(
                    children: [
                      // if (widget.updateByEl == "1")
                      // const Icon(
                      //   Icons.check_circle,
                      //   color: AppColors.green,
                      //   size: 20,
                      // ),
                      InkWell(
                        onTap: () {
                          // Scaffold.of(context)
                          //     .
                          _currentValue = widget.previousAttendance;
                          // _singleValue = widget.employeeAttendance;
                          // print("The value is for single");
                          // print(_singleValue);
                          showModalBottomSheet<void>(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(32.0),
                                    topRight: Radius.circular(32.0)),
                              ),
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(
                                  builder: (BuildContext context,
                                          StateSetter setState) =>
                                      Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30),
                                      ),
                                    ),
                                    // height: 200,
                                    margin: const EdgeInsets.only(
                                        top: 15, left: 10),
                                    child: Column(
                                      children: [
                                        const Text(
                                          "Actions List",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.blue),
                                        ),
                                        const Divider(),
                                        Expanded(
                                          child: ListView.builder(
                                              itemCount:
                                                  widget.attendanceType.length,
                                              itemBuilder: (ctx, ind) {
                                                return RadioButton(
                                                  description: widget
                                                      .attendanceType[ind]
                                                      .attDescription,
                                                  // description: attendance[ind],
                                                  // value: attendanceData[ind],
                                                  value: widget
                                                      .attendanceType[ind]
                                                      .attValue,
                                                  groupValue: _currentValue,
                                                  onChanged: (value) {
                                                    setState(
                                                      () => _currentValue =
                                                          value.toString(),
                                                    );
                                                  },
                                                  // activeColor: Colors.red,
                                                  fillColor: Colors.amber,
                                                  textStyle: const TextStyle(
                                                      // fontSize: 30,
                                                      // fontWeight: FontWeight.w600,
                                                      // color: Colors.red,
                                                      ),
                                                );
                                              }),
                                        ),
                                        // Row(
                                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //   children: [
                                        //     const Text("Present"),
                                        //     Radio(
                                        //       toggleable: true,
                                        //       value: 1,
                                        //       groupValue: selectedValue,
                                        //       onChanged: (value) =>
                                        //           {selectedValue = int.parse(value.toString())},
                                        //     )
                                        //   ],
                                        // ),
                                        // const Divider(),
                                        // Row(
                                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //   children: [
                                        //     const Text("L1"),
                                        //     Radio(
                                        //       toggleable: true,
                                        //       value: 2,
                                        //       groupValue: 2,
                                        //       onChanged: (value) => "P",
                                        //     )
                                        //   ],
                                        // ),
                                        // const Divider(),
                                        // Row(
                                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //   children: [
                                        //     const Text("L2"),
                                        //     Radio(
                                        //       toggleable: true,
                                        //       value: 3,
                                        //       groupValue: 3,
                                        //       onChanged: (value) => "P",
                                        //     )
                                        //   ],
                                        // ),
                                        // const Divider(),
                                        // Row(
                                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //   children: [
                                        //     const Text("L3"),
                                        //     Radio(
                                        //       toggleable: true,
                                        //       value: 4,
                                        //       groupValue: "some name",
                                        //       onChanged: (value) => "P",
                                        //     )
                                        // ],
                                        // ),
                                        // const Divider(),
                                        // Container(
                                        //   child: _myRadioButton("Absent", 0, (newValue) {
                                        //     setState(() {
                                        //       _groupValue = newValue;
                                        //     });
                                        //   }),
                                        // ),
                                        // const Divider(),
                                        // Container(
                                        //   child: _myRadioButton("Present", 1, (newValue) {
                                        //     setState(() {
                                        //       _groupValue = newValue;
                                        //     });
                                        //   }),
                                        // ),
                                        // for (int j = 0; j < 26; j++)
                                        //   RadioButton(
                                        //     description: "Present",
                                        //     value: 1,
                                        //     groupValue: _singleValue,
                                        //     onChanged: (value) {
                                        //       print("The value is ");
                                        //       print(value);
                                        //       setState(
                                        //         () => _singleValue =
                                        //             int.parse(value.toString()),
                                        //       );
                                        //     },
                                        //     // activeColor: Colors.red,
                                        //     fillColor: Colors.amber,
                                        //     textStyle: const TextStyle(
                                        //         // fontSize: 30,
                                        //         // fontWeight: FontWeight.w600,
                                        //         // color: Colors.red,
                                        //         ),
                                        //   ),
                                        // RadioButton(
                                        //   description: "Absent",
                                        //   value: 0,
                                        //   groupValue: _singleValue,
                                        //   fillColor: Colors.amber,
                                        //   onChanged: (value) => setState(
                                        //     () {
                                        //       print(value);
                                        //       _singleValue =
                                        //           int.parse(value.toString());
                                        //     },
                                        //   ),

                                        //   // textPosition: RadioButtonTextPosition.right,
                                        // ),
                                        // Row(
                                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //   children: [
                                        //     const Text("Absent"),
                                        //     Radio(
                                        //       // toggleable: true,
                                        //       value: 0,
                                        //       groupValue: selectedValue,
                                        //       onChanged: (value) {
                                        //         setState(() {
                                        //           selectedValue = int.parse(value.toString());
                                        //         });
                                        //       },
                                        //     )
                                        //   ],
                                        // ),
                                        // const Divider(),C

                                        // Container(
                                        //   height: 25,
                                        //   width: double.infinity,
                                        //   decoration: BoxDecoration(
                                        //     // color: Colors.red,
                                        //     image: DecorationImage(
                                        //       image: AssetImage(
                                        //           "assets/backgrounds/splash_bg.png"),
                                        //     ),
                                        //   ),
                                        // ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10.0),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              minimumSize: const Size(
                                                  double.infinity, 45),
                                              backgroundColor:
                                                  AppColors.primaryColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            onPressed: () {
                                              submitAttendenceForm(
                                                UpdateAttendenceRequestModel(
                                                    elId: widget.userId,
                                                    userRecordId:
                                                        widget.userRecordId,
                                                    attChanged: _currentValue
                                                    // isPresent: _singleValue
                                                    //     .toString()
                                                    ),
                                              );
                                            },
                                            child: const Text("Confirm"),
                                          ),
                                        )
                                        // ElevatedButton(
                                        //     onPressed: () {}, child: const Text("Confirm"))
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        child: const Card(
                            child: Icon(
                          Icons.arrow_drop_down,
                          color: AppColors.paleYellow,
                        )
                            //  Icon(Icons.arrow_drop_down, color: AppColors.paleyellow),
                            ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
