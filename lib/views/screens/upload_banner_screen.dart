import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:stitch_app_web_admin/views/screens/authController.dart';
import 'package:stitch_app_web_admin/views/widgets/upload_banner_list.dart';




import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:image_picker/image_picker.dart';

class UploadBanners extends StatefulWidget {
    static const String id = '\UploadBanners';
  @override
  State<UploadBanners> createState() => _UploadBannersState();
}

class _UploadBannersState extends State<UploadBanners> {
   
  final AuthController _authController = AuthController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String title;

  late String description;



  late String price;

  bool _isLoading = false;

  Uint8List? _image;
 final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
    addServices(title, description, price, _image) async{
      EasyLoading.show(status: "Running");
 String profileImageUrl = await _uploadProfileImageToStorage(_image);

   if (
    
        title.isNotEmpty &&
        description.isNotEmpty &&
       
        price.isNotEmpty 
        
        ) {
      await _firestore.collection('products').add({
        // 'category': selectedService,
        'name': title,
        'description': description,
        'price': price,
       
        "image":profileImageUrl,
        
      });

     // Clear text field controllers after saving
      // title.clear();
      // description.clear();
    
      // price.clear();

      // You can add further logic or navigation after saving
      EasyLoading.dismiss();
      print('Product saved successfully!');
    } else {
       EasyLoading.dismiss();
      print('Please fill in all fields');
    }

}

  _uploadProfileImageToStorage(Uint8List? image) async {
    Reference ref =
        _storage.ref().child('productPics').child(_auth.currentUser!.uid);

    UploadTask uploadTask = ref.putData(image!);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
EasyLoading.dismiss();
    return downloadUrl;
  }

  // _signUpUser(String selectedRole) async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   if (_formKey.currentState!.validate()) {
  //     await _authController
  //         .signUpUSers(email, fullName, phoneNumber, password, _image,selectedRole)
  //         .whenComplete(() {
  //       setState(() {
  //         _formKey.currentState!.reset();
  //         _isLoading = false;
  //       });
  //     });

  //     return showSnack(
  //         context, 'Congratulations Account has been Created For You');
  //   } else {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     return showSnack(context, 'Please Fields must not be empty');
  //   }
  // }

  selectGalleryImage() async {
    Uint8List im = await _authController.pickProfileImage(ImageSource.gallery);

    setState(() {
      _image = im;
    });
  }

  selectCameraImage() async {
    Uint8List im = await _authController.pickProfileImage(ImageSource.camera);

    setState(() {
      _image = im;
    });
  }
String selectedRole = 'customer'; // Default value
  late List<String> serviceList;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
@override
  void initState() {
    super.initState();
    _servicesStream = _firestore
        .collection('cat')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => doc['name'] as String)
            .toList());
  }
  
  Future<void> fetchServices() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('cat').get();

    setState(() {
      serviceList = snapshot.docs.map((doc) => doc.id).toList();
    });
  }
  late Stream<List<String>> _servicesStream;
  String selectedService = '';

 
  // _signUpUser() async {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Add Product',
                  style: TextStyle(fontSize: 20),
                ),
                Stack(
                  children: [
                    _image != null
                        ? 
                        Container(
  width: 128,
  height: 128,
  decoration: BoxDecoration(
    // shape: BoxShape.circle,
    color: Colors.blue.shade900,
    image: DecorationImage(
      fit: BoxFit.cover,
      image: 
      MemoryImage(_image!),
    ),
  ),
)
                        // CircleAvatar(
                        //     radius: 64,
                        //     backgroundColor: Colors.blue.shade900,
                        //     backgroundImage: MemoryImage(_image!),
                        //   )
                        : 
                       Container(
  width: 208,
  height: 208,
  decoration: BoxDecoration(
    // shape: BoxShape.circle,
    color: Colors.blue.shade900,
    image: DecorationImage(
      fit: BoxFit.cover,
      image: NetworkImage(
          'https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg'),
    ),
  ),
),
                    Positioned(
                      right: 0,
                      top: 5,
                      child: IconButton(
                        onPressed: () {
                          selectGalleryImage();
                        },
                        icon: Icon(
                          CupertinoIcons.photo,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please name must not be empty';
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      title = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'Enter Name',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Description must not be empty';
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      description = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'Enter Description',
                    ),
                  ),
                ),
               
                   Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please price must not be empty';
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      price = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'Enter Price',
                    ),
                  ),
                ),
            //  ElevatedButton(
            //   onPressed: () {
            //     showBottomSheet(context);
            //   },
            //   child: Text('Select a service'),
            // ),
                // Padding(
                //   padding: const EdgeInsets.all(13.0),
                //   child: TextFormField(
                //     obscureText: true,
                //     validator: (value) {
                //       if (value!.isEmpty) {
                //         return 'Please Password must not be empty';
                //       } else {
                //         return null;
                //       }
                //     },
                //     onChanged: (value) {
                //       password = value;
                //     },
                //     decoration: InputDecoration(
                //       labelText: 'Password',
                //     ),
                //   ),
                // ),
                   Text("${selectedService}"),
        
                GestureDetector(
                  onTap: ()async {
 if(_formKey.currentState!.validate()){
  addServices(title, description,  price, _image);
 }
                  // }

      // print(documents.first["inOut"]);
     
                
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade900,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                        child: _isLoading
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'Add Product',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 4,
                                ),
                              )),
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Text('Already Have An Account?'),
                //     TextButton(
                //       onPressed: () {
                //         Navigator.push(context,
                //             MaterialPageRoute(builder: (context) {
                //           return LoginScreen();
                //         }));
                //       },
                //       child: Text('Login'),
                //     ),
                //   ],
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
    void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StreamBuilder<List<String>>(
          stream: _servicesStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<String> serviceList = snapshot.data!;
              return ListView.builder(
                itemCount: serviceList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(serviceList[index]),
                    onTap: () {
                      setState(() {
                        selectedService = serviceList[index];
                        // nameController.text = selectedService;
                      });
                      Navigator.pop(context); // Close the bottom sheet
                    },
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return CircularProgressIndicator();
            }
          },
        );
      },
    );
  }

  
}













// class UploadBanners extends StatefulWidget {
//   static const String id = '\UploadBanners';
//   const UploadBanners({super.key});

//   @override
//   State<UploadBanners> createState() => _UploadBannersState();
// }

// class _UploadBannersState extends State<UploadBanners> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   dynamic _image;
//   String? fileName;
//   pickImage() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.image,
//       allowMultiple: false,
//     );

//     if (result != null) {
//       setState(() {
//         _image = result.files.first.bytes;
//         fileName = result.files.first.name;
//       });
//     }
//   }

//   _uploadImageToStorage(dynamic image) async {
//     Reference ref =
//         _firebaseStorage.ref().child('homebanners').child(fileName!);

//     UploadTask uploadTask = ref.putData(image!);
//     TaskSnapshot snap = await uploadTask;
//     String downloadUrl = await snap.ref.getDownloadURL();

//     return downloadUrl;
//   }

//   uploadToFirebase() async {
//     EasyLoading.show();
//     if (_formKey.currentState!.validate()) {
//       if (_image != null) {
//         String imageUrl = await _uploadImageToStorage(_image);

//         await _firestore.collection('banners').doc(fileName).set({
//           'image': imageUrl,
//         }).whenComplete(() {
//           setState(() {
//             _formKey.currentState!.reset();
//             _image = null;

//             EasyLoading.dismiss();
//           });
//         });
//       } else {
//         EasyLoading.dismiss();
//       }
//     } else {
//       EasyLoading.dismiss();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 Container(
//                   alignment: Alignment.topLeft,
//                   padding: const EdgeInsets.all(10),
//                   child: const Text(
//                     'Banners',
//                     style: TextStyle(
//                       fontWeight: FontWeight.w700,
//                       fontSize: 36,
//                     ),
//                   ),
//                 ),
//                 Divider(
//                   color: Colors.grey,
//                 ),
//                 Row(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(14.0),
//                       child: Column(
//                         children: [
//                           Container(
//                             height: 140,
//                             width: 150,
//                             decoration: BoxDecoration(
//                               color: Colors.grey.shade500,
//                               border: Border.all(
//                                 color: Colors.grey.shade800,
//                               ),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Center(
//                               child: _image != null
//                                   ? Image.memory(_image)
//                                   : Text(
//                                       'Banner Image',
//                                     ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               primary: Colors.yellow.shade900,
//                             ),
//                             onPressed: () {
//                               pickImage();
//                             },
//                             child: Text(
//                               'Upload  Image',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       width: 20,
//                     ),
//                     SizedBox(
//                       width: 20,
//                     ),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         primary: Colors.yellow.shade900,
//                       ),
//                       onPressed: uploadToFirebase,
//                       child: Text(
//                         'Save',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 20,
//                     )
//                   ],
//                 ),
//                 Divider(
//                   color: Colors.grey,
//                 )
//               ],
//             ),
//           ),
//           Container(
//             alignment: Alignment.topLeft,
//             padding: const EdgeInsets.all(10),
//             child: const Text(
//               'banners',
//               style: TextStyle(
//                 fontWeight: FontWeight.w700,
//                 fontSize: 36,
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 15,
//           ),
//           UploadBannerList(),
//         ],
//       ),
//     );
//   }
// }
