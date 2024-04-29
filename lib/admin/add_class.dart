import 'package:flutter/material.dart';
import 'package:itrack/main.dart';
import 'package:itrack/models/colors.dart';
import 'package:itrack/models/main_button.dart';
import 'package:line_icons/line_icons.dart';
import 'package:itrack/models/globals.dart' as globals;
import 'package:intl/intl.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:firebase_database/firebase_database.dart';

class AddClass extends StatefulWidget {
  const AddClass({Key? key}) : super(key: key);

  @override
  State<AddClass> createState() => _AddClassState();
}

class _AddClassState extends State<AddClass> {
  final dateToday = DateTime.now();

  String getDate() {
    String formattedDate = DateFormat.yMMMMd('en_US').format(dateToday);
    return formattedDate;
  }

  TimeOfDay _time = const TimeOfDay(hour: 9, minute: 0);

  String formatTime(TimeOfDay time) {
    String amOrPm = 'AM';
    int hour = time.hour;
    if (hour >= 12) {
      amOrPm = 'PM';
      if (hour > 12) {
        hour -= 12;
      }
    }
    String hourStr = hour.toString().padLeft(2, '0');
    String minuteStr = time.minute.toString().padLeft(2, '0');
    return '$hourStr:$minuteStr $amOrPm';
  }

  void onTimeChanged(TimeOfDay newTime) {
    setState(() {
      _time = newTime;
    });
  }

  String dropdownValue = 'Select';
  String classDropdownValue = 'Select';
  bool chipSelection = true;

  @override
  Widget build(BuildContext context) {
    getDate();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                      children: const [
                        Text(
                          "COMP/AIDS",
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Add Lecture',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.03),
                            borderRadius: BorderRadius.circular(12)),
                        child: const Center(
                          child: Icon(LineIcons.arrowLeft),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  width: double.infinity,
                  height: 350,
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                          color: ThemeColor.shadow,
                          blurRadius: 100,
                          spreadRadius: 1,
                          offset: Offset(0, 10)),
                    ],
                    borderRadius: BorderRadius.circular(30),
                    color: ThemeColor.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Date: ",
                              style: TextStyle(
                                  color: ThemeColor.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${getDate()}",
                              style: const TextStyle(
                                  color: ThemeColor.secondary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const Text(
                              "Subject: ",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            DropdownButton(
                                isDense: true,
                                borderRadius: BorderRadius.circular(30),
                                hint: Text(
                                  dropdownValue,
                                  style: const TextStyle(
                                      color: ThemeColor.primary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                items: globals.subjects
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Center(
                                          child: Text(
                                            e,
                                            style: const TextStyle(
                                                color: ThemeColor.primary,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    dropdownValue = value.toString();
                                  });
                                }),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "Class: ",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            DropdownButton(
                                isDense: true,
                                borderRadius: BorderRadius.circular(30),
                                hint: Text(
                                  classDropdownValue,
                                  style: const TextStyle(
                                      color: ThemeColor.primary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                items: ['SE COMP A', 'SE COMP B', 'SE AIDS A']
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Center(
                                          child: Text(
                                            e,
                                            style: const TextStyle(
                                                color: ThemeColor.primary,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    classDropdownValue = value.toString();
                                  });
                                }),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "Mode: ",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 10),
                            ChoiceChip(
                                onSelected: (value) {
                                  setState(() {
                                    chipSelection = false;
                                  });
                                },
                                selectedColor: ThemeColor.primary,
                                backgroundColor: ThemeColor.grey,
                                label: const Text(
                                  'Online',
                                  style: TextStyle(
                                      color: ThemeColor.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                selected: !chipSelection),
                            const SizedBox(width: 10),
                            ChoiceChip(
                                onSelected: (value) {
                                  setState(() {
                                    chipSelection = true;
                                  });
                                },
                                selectedColor: ThemeColor.primary,
                                backgroundColor: ThemeColor.grey,
                                label: const Text(
                                  'Offline',
                                  style: TextStyle(
                                      color: ThemeColor.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                selected: chipSelection),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "Time: ",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  showPicker(
                                    disableMinute: true,
                                    minHour: 8.0,
                                    maxHour: 17.0,
                                    is24HrFormat: false,
                                    iosStylePicker: true,
                                    context: context,
                                    value: timeOfDayToTime(_time),
                                    onChange: onTimeChanged,
                                  ),
                                );
                              },
                              child: Text(
                                formatTime(_time),
                                style: const TextStyle(
                                    color: ThemeColor.primary,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        MainButton(
                            text: "Create",
                            onTap: () {
                              String dateForDB =
                                  "${dateToday.year}/${dateToday.month}/${dateToday.day}/$dropdownValue";

                              final classReference = dbReference
                                  .child('class/timetable/$dateForDB');
                              classReference.set({
                                'subject': dropdownValue,
                                'class': classDropdownValue,
                                'mode': chipSelection,
                                'time': formatTime(_time),
                                'isnottaken': true,
                                'islistening': false
                              }).then((value) => Navigator.pop(context));
                            })
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Time timeOfDayToTime(TimeOfDay timeOfDay) {
  return Time(hour: timeOfDay.hour, minute: timeOfDay.minute);
}
