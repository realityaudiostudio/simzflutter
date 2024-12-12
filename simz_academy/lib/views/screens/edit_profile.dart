import 'package:flutter/material.dart';
import 'package:simz_academy/models/student_model/profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../controllers/constants/supabase_functions.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final ProfileModel _profileModel = ProfileModel();
  final yearOfAdmissionController = TextEditingController();
  bool setPassword = false;
  @override
  void initState() {
    super.initState();
    getYearOfAdmission();
  }

  Future<void> getYearOfAdmission() async {
    final userId = getUserId();
    final response = await Supabase.instance.client
        .from('student_details')
        .select('year_adm')
        .eq('user_id', userId);
    if (response[0]['year_adm'] != null) {
      yearOfAdmissionController.text = response[0]['year_adm'].toString();
    } else {
      yearOfAdmissionController.text = 'Not Available';
    }
  }



  @override
  Widget build(BuildContext context) {
    TextEditingController nameController =
        TextEditingController(text: _profileModel.name);
    // TextEditingController emailController =
    //     TextEditingController(text: _profileModel.email);
    TextEditingController phoneNumberController =
        TextEditingController(text: _profileModel.phone);
    TextEditingController passwordController = TextEditingController();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
              ),
              // TextField(
              //   controller: emailController,
              //   decoration: InputDecoration(
              //     labelText: 'Email',
              //   ),
              // ),
              TextField(
                controller: phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Phone',
                ),
              ),
              TextField(
                controller: yearOfAdmissionController,
                decoration: InputDecoration(
                  labelText: 'Year of Admission',
                ),
              ),
              if (setPassword)
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                ),
              TextButton(
                onPressed: () {
                  setState(
                    () {
                      setPassword = !setPassword;
                    },
                  );
                },
                child: setPassword ? Text('Cancel') : Text('Add new Password'),
              ),
              SizedBox(height: 20,),
              ElevatedButton(onPressed: (){
                updateProfile(passwordController.text, nameController.text, phoneNumberController.text);
              }, child: Text('Save Changes'))
            ],
          ),
        ),
      ),
    );
  }
  void updateProfile(String password,String name, String phone) async{
    final userId = getUserId();

    try{
      final response = await Supabase.instance.client
          .from('student_details')
          .update({
        'year_adm': yearOfAdmissionController.text,
      })
          .eq('user_id', userId);

      debugPrint(response);
      if (setPassword && password.isNotEmpty) {
        final response1 = await Supabase.instance.client.auth.updateUser(
          UserAttributes(password: password),
        );
        debugPrint(response1.toString());
      }

      final response2 = await Supabase.instance.client.auth.updateUser(
        UserAttributes(
            data: {"username": name,"phone": phone}
        ),
      );
      debugPrint("response  2 : $response2");
    }catch(e){
      debugPrint(e.toString());
    }
  }
}
