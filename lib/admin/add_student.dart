import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:itrack/main.dart';
import 'package:itrack/models/colors.dart';
import 'package:itrack/models/main_button.dart';
import 'package:line_icons/line_icons.dart';
import 'package:itrack/models/globals.dart' as globals;
import 'package:intl/intl.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:firebase_database/firebase_database.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({Key? key}) : super(key: key);

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final database = dbReference.child("users");
  String selectedClassFilter = ''; // Default selected class filter
  String selectedClass = 'SE COMP A';
  String dropdownValue = 'Select';
  String classDropdownValue = 'Select';
  bool chipSelection = true;
  final TextEditingController idController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                          'Add Student',
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
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          style: TextStyle(
                            color: ThemeColor.primary,
                          ),
                          controller: idController,
                          decoration: InputDecoration(labelText: 'ID'),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(labelText: 'Name'),
                        ),
                        SizedBox(
                          height: 20,
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
                        SizedBox(
                          height: 20,
                        ),
                        MainButton(
                            text: "Add",
                            onTap: () {
                              _addStudentToDatabase();
                              Navigator.pop(context);
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

  void _addStudentToDatabase() {
    String id = idController.text.trim();
    String name = nameController.text.trim();
    if (id.isNotEmpty && name.isNotEmpty) {
      database.push().set({
        'id': id,
        'name': name,
        'class': classDropdownValue,
      });
      // Clear text fields after adding student
      idController.clear();
      nameController.clear();
    } else {
      // Show error message if any of the fields are empty
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('ID and Name cannot be empty!'),
        backgroundColor: Colors.red,
      ));
    }
  }
}
