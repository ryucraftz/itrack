import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:itrack/main.dart';
import 'package:itrack/models/colors.dart';
import 'package:line_icons/line_icons.dart';

class StudentList extends StatefulWidget {
  const StudentList({Key? key}) : super(key: key);

  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  final database = dbReference.child("users");

  String selectedClassFilter = ''; // Default selected class filter
  String selectedClass = 'SE COMP A'; // Default selected class
  final TextEditingController idController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

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
                      children: const [
                        Text(
                          "SE",
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Students',
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
                  height: 20,
                ),
                // Add Student Button with Dropdown
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'List',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: ThemeColor.primary,
                          borderRadius: BorderRadius.circular(30)),
                      child: DropdownButton<String>(
                        dropdownColor: ThemeColor.primary,
                        borderRadius: BorderRadius.circular(30),
                        value: selectedClassFilter.isEmpty
                            ? 'SE COMP A'
                            : selectedClassFilter,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedClassFilter = newValue!;
                          });
                        },
                        items: <String>[
                          'SE COMP A',
                          'SE COMP B',
                          'SE AIDS A',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                value,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: ThemeColor.white,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                FirebaseAnimatedList(
  physics: NeverScrollableScrollPhysics(),
  query: database,
  shrinkWrap: true,
  defaultChild: Center(
    child: CircularProgressIndicator(),
  ),
  itemBuilder: (context, snapshot, animation, index) {
    String userID = 'UID';
    Future<Map<dynamic, dynamic>> databaseData() async {
      userID = snapshot.key.toString();
      DataSnapshot userSnapshot =
          await dbReference.child("users/$userID").get();
      if (userSnapshot.value != null &&
          userSnapshot.value is Map<dynamic, dynamic>) {
        return userSnapshot.value as Map<dynamic, dynamic>;
      } else {
        // Return an empty map if the value is null or not of the expected type
        return {};
      }
    }

    return FutureBuilder(
      future: databaseData(),
      builder: (BuildContext context,
          AsyncSnapshot<Map<dynamic, dynamic>> snapshot) {
        if (snapshot.hasData) {
          String studentClass = snapshot.data!['class'];
          if (selectedClassFilter.isNotEmpty &&
              selectedClassFilter != studentClass) {
            return SizedBox(); // If class filter is set and not matching, hide the student
          }
          String studentId = snapshot.data!['id']; // Fetching the ID from Firebase
          return Column(
            children: [
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: ThemeColor.shadow,
                            blurRadius: 10,
                            spreadRadius: 0.1,
                            offset: Offset(0, 10)),
                      ],
                      color: ThemeColor.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 10, top: 2),
                    child: ListTile(
                      trailing: InkWell(
                        onTap: () {
                          database.child(userID).remove();
                        },
                        child: Container(
                          width: 70,
                          height: 35,
                          decoration: BoxDecoration(
                              color: ThemeColor.secondary,
                              borderRadius:
                                  BorderRadius.circular(20)),
                          child: const Center(
                            child: Icon(LineIcons.trash,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      title: Text(
                        "$studentId:  ${snapshot.data!['name']}",
                        style: const TextStyle(
                            fontSize: 17,
                            color: ThemeColor.black,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          // Display CircularProgressIndicator when waiting for data
          if (userID.isEmpty) {
            return Container(
              color: Colors.white,
              margin: const EdgeInsets.only(top: 20),
              child: const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.grey,
                  color: Colors.blue,
                ),
              ),
            );
          } else {
            // Display a placeholder while loading data from Firebase
            return SizedBox(
              height: 60, // Adjust height as needed
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.grey,
                  color: Colors.blue,
                ),
              ),
            );
          }
        }
      },
    );
  },
)

              ],
            ),
          ),
        ),
      ),
    );
  }
    
  
}
