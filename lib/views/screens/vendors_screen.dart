import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stitch_app_web_admin/views/screens/vendorExtended.dart';
import 'package:stitch_app_web_admin/views/widgets/vendors_list.dart';

class VendorsScreen extends StatefulWidget {
  static const String id = '\vendorScreen';

  @override
  State<VendorsScreen> createState() => _VendorsScreenState();
}

class _VendorsScreenState extends State<VendorsScreen> {
 // Widget _rowHeader(int flex, String text) {
  //   return Expanded(
  //       flex: flex,
  //       child: Container(
  //         decoration: BoxDecoration(
  //           border: Border.all(color: Colors.grey.shade700),
  //           color: Colors.yellow.shade900,
  //         ),
  //         child: Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: Text(
  //             text,
  //             style: TextStyle(
  //               color: Colors.white,
  //             ),
  //           ),
  //         ),
  //       ));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
         Row(
          children: [
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection('buyers').where("role",isEqualTo: "seller").snapshots(),
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
                  width: 900,
                  
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      var ids = documents[index].id;
                      var data = documents[index].data();
                      var user_id = data["userId"];
                      return 
        GestureDetector(
          onTap: (){
            print("error");
            print(ids);
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
ServicesGrid(id:ids)
            ));
              // Get.to(()=>);
          },
          child: Container(
          height: 80,
          width: 120,
          decoration: BoxDecoration(color: Colors.amber),
          margin: EdgeInsets.all(8.0),
          child: ListTile(
                    title: Text(data["email"]),
                    subtitle:Text(data["fullName"] + " Phone Number" + data["phoneNumber"] ) ,
          trailing:      IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () async {
                                      try {
                                        await FirebaseFirestore.instance
                                            .collection("buyers")
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
      ),
    );
  }
}