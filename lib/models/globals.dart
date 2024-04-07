library globals;

String userID = 'null';
String userName = '';
bool isAdmin = false;

String selSubforAttendance = 'Subject';
String classMode = 'mode';
String timeOfClass = 'time';

//SUBJECTS FOR COUNTING CLASSES
List<String> subjects = [
  'DSA',
  'M3',
  'PPL',
  'MP',
  'SE',
  'IOT',
  'MIS',
  'STATS'
];

List subjectsAttendance = [];
List subjectsTotalClass = [];
String attendancePercent = 'null';

//LOCATION BASED ATTENDANCE


double latitude = 15.0843241;
double longitude = 79.4849571;
bool streamStarted = false;
