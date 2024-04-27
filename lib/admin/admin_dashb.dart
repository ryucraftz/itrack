import 'package:flutter/material.dart';
import 'package:itrack/admin/add_class.dart';
import 'package:itrack/admin/student_list.dart';
import 'package:itrack/admin/view_classes.dart';
import 'package:itrack/main.dart';
import 'package:itrack/models/colors.dart';
import 'package:itrack/services/auth_service.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  Future<String> getNumberOfUsers() async {
    // String numberOfUsers='N';
    return await dbReference.child('users').once().then(
      (value) {
        var data = value.snapshot.value;

        String numberOfUsers =
            Map<String, dynamic>.from(data as Map<Object?, Object?>)
                .length
                .toString();

        return numberOfUsers;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
    );
  }

  Widget getBody() {
    final authService = Provider.of<AuthService>(context);
    var size = MediaQuery.of(context).size;
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
                            "Teacher's",
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Dashboard',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () async {
                          await authService.signOut();
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.03),
                              borderRadius: BorderRadius.circular(12)),
                          child: const Center(
                            child: Icon(LineIcons.alternateSignOut),
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
                    height: 145,
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: ThemeColor.shadow,
                            blurRadius: 100,
                            spreadRadius: 5,
                            offset: Offset(0, 25)),
                      ],
                      borderRadius: BorderRadius.circular(30),
                      color: ThemeColor.primary,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Flexible(
                            child: SizedBox(
                              width: (size.width),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Number of Students",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: ThemeColor.white),
                                  ),
                                  const Text(
                                    "COMP/AIDS",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color: ThemeColor.white),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const StudentList()),
                                      );
                                    },
                                    child: Container(
                                      width: 100,
                                      height: 35,
                                      decoration: BoxDecoration(
                                          color: ThemeColor.secondary,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: const Center(
                                        child: Text(
                                          "View Students",
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: ThemeColor.white),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Container(
                            width: 100,
                            height: 100,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: ThemeColor.secondary),
                            child: Center(
                              child: FutureBuilder(
                                future: getNumberOfUsers(),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                      snapshot.data,
                                      style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: ThemeColor.white),
                                    );
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: double.infinity,
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
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Create Class",
                            style: TextStyle(
                                fontSize: 17,
                                color: ThemeColor.black,
                                fontWeight: FontWeight.w600),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const AddClass()),
                              );
                            },
                            child: Container(
                              width: 70,
                              height: 35,
                              decoration: BoxDecoration(
                                  color: ThemeColor.secondary,
                                  borderRadius: BorderRadius.circular(20)),
                              child: const Center(
                                child:
                                    Icon(LineIcons.plus, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
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
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "View Classes",
                            style: TextStyle(
                                fontSize: 17,
                                color: ThemeColor.black,
                                fontWeight: FontWeight.w600),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ViewClasses()),
                              );
                            },
                            child: Container(
                              width: 70,
                              height: 35,
                              decoration: BoxDecoration(
                                  color: ThemeColor.secondary,
                                  borderRadius: BorderRadius.circular(20)),
                              child: const Center(
                                child: Icon(LineIcons.arrowRight,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
