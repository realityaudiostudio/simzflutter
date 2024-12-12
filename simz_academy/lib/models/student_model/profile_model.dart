import 'package:simz_academy/controllers/constants/supabase_functions.dart';
//import '../../controllers/functions/edit_profile_controller.dart';

class ProfileModel{
  String name = getCurrentUserName();
  String email = getCurrentUserEmail();
  String phone = getCurrentUserPhone();
  String yearOfAdmission = '';
  late String password;
}