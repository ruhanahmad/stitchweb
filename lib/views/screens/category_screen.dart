import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:stitch_app_web_admin/views/widgets/category_widget.dart';

class CategoryScreen extends StatefulWidget {
  static const String id = '\categoryScreen';
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String categoryName;
  dynamic _image;
  String? fileName;
  pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        _image = result.files.first.bytes;
        fileName = result.files.first.name;
      });
    }
  }

  _uploadImageToStorage(dynamic image) async {
    Reference ref = _firebaseStorage.ref().child('category').child(fileName!);

    UploadTask uploadTask = ref.putData(image!);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();

    return downloadUrl;
  }

  uploadToFirebase() async {
    EasyLoading.show();
    if (_formKey.currentState!.validate()) {
      if (_image != null) {
        String imageUrl = await _uploadImageToStorage(_image);

        await _firestore.collection('categories').doc(fileName).set({
          'image': imageUrl,
          'categoryName': categoryName,
        }).whenComplete(() {
          setState(() {
            _formKey.currentState!.reset();
            _image = null;

            EasyLoading.dismiss();
          });
        });
      } else {
        EasyLoading.dismiss();
      }
    } else {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Categories',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 36,
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey,
                ),
                Row(
                  children: [
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('cat').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
            snapshot.data!.docs;

        return Container(
          height: 200,
          width: 1100,
          
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: documents.length,
            itemBuilder: (context, index) {
              var ids = documents[index].id;
              var data = documents[index].data();
              return 
                Container(
                height: 80,
                width: 120,
                decoration: BoxDecoration(color: Colors.amber),
                margin: EdgeInsets.all(8.0),
                child: ListTile(
          title: Text(data["name"]),
                trailing:      IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () async {
                                            try {
                                              await FirebaseFirestore.instance
                                                  .collection("cat")
                                                  .doc(ids)
                                                  .delete();
                                            } catch (e) {
                                              print(
                                                  'Error deleting document: $e');
                                            }
                                            // Call your Firebase delete function or use a service class
                                            // to handle the deletion of the task
                                            // Example: FirebaseService.deleteTask(task.id);
                                          },
                                        ), 
                ),
              );
              // FlutterCard(
              //   title: data['name'],
              //   id:ids
               
              // );
            },
          ),
        );
      },
    ),
             
                  ],
                ),
                Divider(
                  color: Colors.grey,
                )
              ],
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Category',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 36,
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          CategoryListWidget(),
        ],
      ),
    );
  }
}


class FlutterCard extends StatelessWidget {
  final String title;
  final String id;

  FlutterCard({
    required this.title,
    required this.id,
  
  });

  @override
  Widget build(BuildContext context) {
    return 
    Container(
      height: 80,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(title),
      trailing:      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () async {
                                          try {
                                            await FirebaseFirestore.instance
                                                .collection("cat")
                                                .doc(id)
                                                .delete();
                                          } catch (e) {
                                            print(
                                                'Error deleting document: $e');
                                          }
                                          // Call your Firebase delete function or use a service class
                                          // to handle the deletion of the task
                                          // Example: FirebaseService.deleteTask(task.id);
                                        },
                                      ), 
      ),
    );
  }
}