import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stitch_app_web_admin/views/widgets/buyers_list.dart';

class BuyersScreen extends StatefulWidget {
  static const String id = '\buyersScreen';

  @override
  State<BuyersScreen> createState() => _BuyersScreenState();
}

class _BuyersScreenState extends State<BuyersScreen> {
  Widget _rowHeader(int flex, String text) {
    return Expanded(
        flex: flex,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade700),
            color: Colors.yellow.shade900,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
  
        children: [
            SizedBox(height: 40,),
              Table(
             border: TableBorder.all(),
            children:[
           TableRow(
              children: [
                TableCell(
                  child: Center(child: Text('Step')),
                ),
                TableCell(
                  child: Center(child: Text('email')),
                ),
                TableCell(
                  child: Center(child: Text('Full Name')),
                ),
                 TableCell(
                  child: Center(child: Text('Phone Number')),
                ),
               
                  TableCell(
                  child: Center(child: Text('Del')),
                ),
              ],
            ),
            ]
            
            
            ),

 StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
           stream: FirebaseFirestore.instance.collection('buyers').where("role",isEqualTo: "customer").snapshots(),
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
                  
              return ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  var ids = documents[index].id;
                  var data = documents[index].data();
                  var user_id = data["userId"];
                  return 
              
                          //          GestureDetector(
                          //            onTap: (){
                          //  print("error");
                          //  //             print(ids);
                          //  //             Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                          //  // ServicesGrid(id:ids)
                          //  //             ));
                          //    // Get.to(()=>);
                          //            },
                          //            child: Container(
                          //            height: 80,
                          //            width: 120,
                          //            decoration: BoxDecoration(color: Colors.amber),
                          //            margin: EdgeInsets.all(8.0),
                          //            child: ListTile(
                          //          title: Text(data["email"]),
                          //          subtitle:Text(data["fullName"] + " Phone Number" + data["phoneNumber"] ) ,
                          //            trailing:     
                          // IconButton(
                          //                          icon: Icon(Icons.delete),
                          //                          onPressed: () async {
                          //                            try {
                          //                              await FirebaseFirestore.instance
                          //                                  .collection("buyers")
                          //                                  .doc(ids)
                          //                                  .delete();
                          //                            } catch (e) {
                          //                              print(
                          //                                  'Error deleting document: $e');
                          //                            }
                          //                            // Call your Firebase delete function or use a service class
                          //                            // to handle the deletion of the task
                          //                            // Example: FirebaseService.deleteTask(task.id);
                          //                          },
                          //                        ), 
                          //            ),
                          //              ),
                          //          );
              
                               Center(
                      child: 
                      Table(
                        border: TableBorder.all(),
                        children: [
                         
                          TableRow(
                            children: [
                              TableCell(
                 child: Center(child: Text('${index}')),
                              ),
                              TableCell(
                 child: Center(child: Text(data["email"])),
                              ),
                              TableCell(
                 child: Center(child: Text(data["fullName"])),
                              ),
                                
                              TableCell(
                 child: Center(child: Text(data["phoneNumber"])),
                              ),
                TableCell(
                 child: Center(child:  
                  IconButton(
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
                              ), ),
                              ),
                            ],
                          ),
                          
                        ],
                      ),
                    );
              
              
                  // FlutterCard(
                  //   title: data['name'],
                  //   id:ids
                   
                  // );
                },
              );
            },
          ),
            
          // StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          //   stream: FirebaseFirestore.instance.collection('buyers').where("role",isEqualTo: "customer").snapshots(),
          //   builder: (context, snapshot) {
          //     if (snapshot.hasError) {
          //       return Center(
          //         child: Text('Error: ${snapshot.error}'),
          //       );
          //     }
                 
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       return Center(
          //         child: CircularProgressIndicator(),
          //       );
          //     }
                 
          //     List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
          //         snapshot.data!.docs;
                 
          //     return Container(
          //       height: 200,
          //       width: 800,
                
          //       child: ListView.builder(
          //         shrinkWrap: true,
          //         scrollDirection: Axis.vertical,
          //         itemCount: documents.length,
          //         itemBuilder: (context, index) {
          //           var ids = documents[index].id;
          //           var data = documents[index].data();
          //           return 
          //        Container(
          //        height: 80,
          //        width: 120,
          //        decoration: BoxDecoration(color: Colors.amber),
          //        margin: EdgeInsets.all(8.0),
          //        child: ListTile(
          //       title: Text(data["email"]),
          //       subtitle:Text(data["fullName"] + " Phone Number" + data["phoneNumber"] ) ,
          //        trailing:      IconButton(
          //                       icon: Icon(Icons.delete),
          //                       onPressed: () async {
          //                         try {
          //                           await FirebaseFirestore.instance
          //                               .collection("buyers")
          //                               .doc(ids)
          //                               .delete();
          //                         } catch (e) {
          //                           print(
          //                               'Error deleting document: $e');
          //                         }
          //                         // Call your Firebase delete function or use a service class
          //                         // to handle the deletion of the task
          //                         // Example: FirebaseService.deleteTask(task.id);
          //                       },
          //                     ), 
          //        ),
          //           );
          //           // FlutterCard(
          //           //   title: data['name'],
          //           //   id:ids
                     
          //           // );
          //         },
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}
