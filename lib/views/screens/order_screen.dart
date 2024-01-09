// import 'package:flutter/material.dart';

// import '../widgets/order_widget.dart';

// class OrderScreen extends StatefulWidget {
//   static const String routeName = '\orderScreen';

//   @override
//   State<OrderScreen> createState() => _OrderScreenState();
// }

// class _OrderScreenState extends State<OrderScreen> {
//   Widget _rowHeader(int flex, String text) {
//     return Expanded(
//         flex: flex,
//         child: Container(
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.grey.shade700),
//             color: Colors.yellow.shade900,
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               text,
//               style: TextStyle(
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 alignment: Alignment.topLeft,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Manage Orders',
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               Row(
//                 children: [
//                   _rowHeader(1, 'Image'),
//                   _rowHeader(3, 'Full Name '),
//                   _rowHeader(2, 'Address'),
//                   _rowHeader(1, 'ACTION'),
//                   _rowHeader(1, 'VIEW MORE'),
//                 ],
//               ),
//               OrderWidget(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class OrderScreen extends StatelessWidget {
  static const String routeName = '\orderScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders List'),
      ),
      body: 
        Column(
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
                  child: Center(child: Text('Name')),
                ),
                TableCell(
                  child: Center(child: Text('Adress')),
                ),
                 TableCell(
                  child: Center(child: Text('Phone Number')),
                ),
               
                  TableCell(
                  child: Center(child: Text('Amount')),
                ),
                TableCell(
                  child: Center(child: Text('Del')),
                ),
              ],
            ),
            ]
            
            
            ),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
               stream: FirebaseFirestore.instance.collection('orders').snapshots(),
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
                 child: Center(child: Text(data["name"])),
                              ),
                              TableCell(
                 child: Center(child: Text(data["address"])),
                              ),
                                
                              TableCell(
                 child: Center(child: Text(data["phoneNumber"])),
                              ),
                                TableCell(
                 child: Center(child: Text(data["total"])),
                              ),
                                TableCell(
                 child: Center(child:  
                  IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                  try {
                                    await FirebaseFirestore.instance
                                        .collection("orders")
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
                // TableCell(
                //  child: Center(child:  
                //   IconButton(
                //                 icon: Icon(Icons.delete),
                //                 onPressed: () async {
                //                   try {
                //                     await FirebaseFirestore.instance
                //                         .collection("buyers")
                //                         .doc(ids)
                //                         .delete();
                //                   } catch (e) {
                //                     print(
                //                         'Error deleting document: $e');
                //                   }
                //                   // Call your Firebase delete function or use a service class
                //                   // to handle the deletion of the task
                //                   // Example: FirebaseService.deleteTask(task.id);
                //                 },
                //               ), ),
                //               ),
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





































        ],
      ),
      // StreamBuilder(
      //   stream: FirebaseFirestore.instance.collection('orders').snapshots(),
      //   builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return CircularProgressIndicator();
      //     } else if (snapshot.hasError) {
      //       return Text('Error: ${snapshot.error}');
      //     } else {
      //       List<DocumentSnapshot> orders = snapshot.data!.docs;

      //       return ListView.builder(
      //         itemCount: orders.length,
      //         itemBuilder: (context, index) {
      //           Map<String, dynamic> orderData = orders[index].data() as Map<String, dynamic>;

      //           return Card(
      //              elevation: 4,
      //             child: ListTile(
                    
      //               title: Text('Name: ${orderData['name']}'),
      //               subtitle: Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   Text('Address: ${orderData['address']}'),
      //                   Text('Phone Number: ${orderData['phoneNumber']}'),
      //                   Text('Total: \$${orderData['total']}'),
      //                 ],
      //               ),
      //             ),
      //           );
      //         },
      //       );
      //     }
      //   },
      // ),
    );
  }
}

