import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stitch_app_web_admin/main.dart';



import 'package:stitch_app_web_admin/service/utiles.dart';
import 'package:stitch_app_web_admin/views/dashboard_screens/dashboard_screens.dart';
import 'package:stitch_app_web_admin/views/screens/authController.dart';
import 'package:stitch_app_web_admin/views/screens/registrationScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController _authController = AuthController();
  late String email;

  late String password;

  bool _isLoading = false;

  _loginUsers() async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      String res = await _authController.loginUsers(email, password);

      if (res == 'success' ) {
        setState(() {
          _isLoading = false;
        });
  //       List<DocumentSnapshot> documents = [];
  // List cardEx = [];

  // String? typeofUser;


  //   documents.clear();
  //   final QuerySnapshot result = await FirebaseFirestore.instance
  //       .collection('buyers')
  //       .where('email', isEqualTo: email)
     
  //       .get();
  //   documents = result.docs;
  
  //   print(documents.length);
  //   // if (documents.length > 0) {
  //     cardEx.add(result.docs);
    
  //     // print(documents.first["inOut"]);
  //    var  nameOfUser = documents.first["role"];
  //   print(documents.first["userName"] + "qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq");
  //    userController.inOut  = documents.first["inOut"];
  //  userController.total = documents.first["totalHours"];
  //    userController.update();
  //  if (taskController.text.isNotEmpty) {
      // Assign task to the selected user


      
    // } 
    // else {
      // Get.snackbar("Information Missing Or invalid",
      //     "Please write correct information ");
      //     EasyLoading.dismiss();

    // }
   // String username =  await PreferencesManager.instance.getUserName(); 

 



        return Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return email == "admin@gmail.com" ? SideMenu(): LoginScreen() ;
        }));
      } else {
        setState(() {
          _isLoading = false;
        });
        return showSnack(context, res);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      return showSnack(context, 'Please feidls most not be empty');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login Admin Account',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(13.0),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Email feild most not be empty';
                    } else {
                      return null;
                    }
                  },
                  onChanged: ((value) {
                    email = value;
                  }),
                  decoration: InputDecoration(
                    labelText: ' Enter Email Address',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(13.0),
                child: TextFormField(
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Password most not be empty';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Enter Password',
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  _loginUsers();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.blue.shade900,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: _isLoading
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            'Login',
                            style: TextStyle(
                              letterSpacing: 5,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Need An Account?'),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: ((context) {
                        return BuyerRegisterScreen();
                      })));
                    },
                    child: Text(
                      'Register',
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}




//  _loginUsers() async {
//     setState(() {
//       _isLoading = true;
//     });
//     if (_formKey.currentState!.validate()) {
//       await _authController.loginUsers(email, password);
//       return Navigator.pushReplacement(context,
//           MaterialPageRoute(builder: (BuildContext context) {
//         return MainScreen();
//       }));
//     } else {
//       setState(() {
//         _isLoading = false;
//       });
//       return showSnack(context, 'Please feidls most not be empty');
//     }
//   }