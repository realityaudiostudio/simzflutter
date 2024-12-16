class StudentDetails {
  String userId;
  bool isStudent;
  List<String> lessons;
  List<String> courses;
  Map<String, dynamic> attendanceDetails;
  String? yearAdm;
  List<String> prevLearn;
  List<String> currLearn;
  num? feeDue;
  List<String>? badges;
  List<String>? certificates;

  StudentDetails({
    required this.userId,
    required this.isStudent,
    required this.lessons,
    required this.courses,
    required this.attendanceDetails,
    this.yearAdm,
    required this.prevLearn,
    required this.currLearn,
    this.feeDue,
    this.badges,
    this.certificates,
  });

  // Convert the object to JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'is_student': isStudent,
      'lessons': lessons,
      'courses': courses,
      'attendance_details': attendanceDetails,
      'year_adm': yearAdm,
      'prev_learn': prevLearn,
      'curr_learn': currLearn,
      'fee_due': feeDue,
      'badges': badges,
      'certificates': certificates,
    };
  }
}
