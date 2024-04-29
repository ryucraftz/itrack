import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:itrack/main.dart';
import 'package:itrack/models/colors.dart';
import 'package:line_icons/line_icons.dart';
import 'package:itrack/models/globals.dart' as globals;

class ViewAttendance extends StatefulWidget {
  const ViewAttendance({Key? key}) : super(key: key);

  @override
  _ViewAttendanceState createState() => _ViewAttendanceState();
}

class _ViewAttendanceState extends State<ViewAttendance> {
  final dateToday = DateTime.now();
  final database = dbReference.child("users");
  String userID = 'UID';
  int numberOfStudents = 0;
  List<bool> isPresent = [];
  List<String> isPresentUID = [];

  void attendanceFetch() {
    String year = dateToday.year.toString();
    String month = dateToday.month.toString();
    String day = dateToday.day.toString();

    String attendancePath =
        "attendance/$year/$month/$day/${globals.selSubforAttendance}";

    for (int i = 0; i < isPresent.length; i++) {
      if (isPresent[i]) {
        int attendanceValue = 1; // Set attendance value to 1 if present
        String studentId = isPresentUID[i];
        String studentAttendancePath = "$attendancePath/$studentId";
        dbReference.child(studentAttendancePath).set(attendanceValue);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          globals.selSubforAttendance,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          'Attendance',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        attendanceFetch(); // Call attendanceFetch when needed
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.03),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Icon(LineIcons.arrowLeft),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                FirebaseAnimatedList(
                  physics: const NeverScrollableScrollPhysics(),
                  query: database,
                  shrinkWrap: true,
                  defaultChild: Center(
                    child: CircularProgressIndicator(),
                  ),
                  itemBuilder: (context, snapshot, animation, index) {
                    userID = snapshot.key.toString();

                    if (numberOfStudents < index + 1) {
                      numberOfStudents = index;
                      isPresent.add(false);
                      isPresentUID.add(userID);
                    }

                    return FutureBuilder(
                      future: dbReference.child("users/$userID/${dateToday.year}/${dateToday.month}/${dateToday.day}/${globals.selSubforAttendance}").get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasData && snapshot.data!.value == 1) {
                          return Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isPresent[index] = !isPresent[index]; // Toggle attendance
                                  });
                                },
                                child: Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: ThemeColor.white,
                                    boxShadow: const [
                                      BoxShadow(
                                        color: ThemeColor.shadow,
                                        blurRadius: 10,
                                        spreadRadius: 0.1,
                                        offset: Offset(0, 10),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 10,
                                      top: 2,
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        "${index + 1}:  ${snapshot.data!.value}", // Access the value of the DataSnapshot
                                        style: const TextStyle(
                                          fontSize: 17,
                                          color: ThemeColor.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return const SizedBox(); // Return an empty SizedBox if not present or attendance value is not 1
                        }
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 60,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
