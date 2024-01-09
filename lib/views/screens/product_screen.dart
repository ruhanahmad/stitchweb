import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stitch_app_web_admin/views/widgets/product_list_screen.dart';

class ProductScreen extends StatefulWidget {
  static const String routeName = '\ProductScreen';

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
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

 TextEditingController taskiController = TextEditingController();
   TextEditingController deadlineController = TextEditingController();
    TextEditingController onTimeController = TextEditingController();
     TextEditingController statusController = TextEditingController();
 void  _showEditDialog(BuildContext context, String id, String price,
      String title,  String description) {

           taskiController.text = price;
      deadlineController.text = title;
 
     statusController.text = description;
     print(onTimeController.text);
    print(id + "asdasdasdasdasdsd");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: taskiController,
                decoration:
                    InputDecoration(labelText: 'Price', hintText: price),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: deadlineController,
                decoration:
                    InputDecoration(labelText: 'title', hintText:title),
              ),
            
              SizedBox(height: 16.0),
              TextField(
                controller: statusController,
                decoration: InputDecoration(
                    labelText: 'description', hintText: description),
              ),
              SizedBox(height: 16.0),
              //   Row(
              //     children: [
              //       Text('Deadline: ${selectedDate.toLocal()}'),
              //       SizedBox(width: 10.0),
              //       ElevatedButton(
              //         onPressed: () => _selectDate(context, selectedDate),
              //         child: Text('Select Date'),
              //       ),
              //     ],
              //   ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _updateTasksJoin(
                    id,
                    taskiController.text,
                    deadlineController.text,
                  
                    statusController.text);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }



    Future<void> _updateTasksJoin(String id, String price, String title,
      String description,) async {
    await FirebaseFirestore.instance.collection('products').doc(id).update(
      {
        'price': price,
        'name': title,
       
        "description": description,
      },
    );

    // taskController.text == "";
    // deadlineController.text == "";
    // onTimeController.text == "";
    // statusController.text == "";
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  child: Center(child: Text('Sr')),
                ),
                TableCell(
                  child: Center(child: Text('image')),
                ),
                TableCell(
                  child: Center(child: Text('name')),
                ),
                 TableCell(
                  child: Center(child: Text('description')),
                ),
               
                  TableCell(
                  child: Center(child: Text('price')),
                ),
                TableCell(
                  child: Center(child: Text('action')),
                ),
                //   TableCell(
                //   child: Center(child: Text('Del')),
                // ),
              ],
            ),
            ]
            
            
            ),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance.collection('products').snapshots(),
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
            
            return
             Expanded(
               child: ListView.builder(
                //  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //    crossAxisCount: 2,
                //    crossAxisSpacing: 8.0,
                //    mainAxisSpacing: 8.0,
                //  ),
                 itemCount: documents.length,
                 itemBuilder: (context, index) {
                   var data = documents[index].data();
                   return 
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
                 child: Center(child:
                 
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                                height: 100.0,
                                width: 100,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(data["image"]),
                                  ),
                                ),
                              ),
                  ),
                  
                  ),
                              ),
                              TableCell(
                 child: Center(child: Text(data["name"])),
                              ),
                                
                              TableCell(
                 child: Center(child: Text(data["description"])),
                              ),
                                TableCell(
                 child: Center(child: Text(data["price"])),
                              ),
                               TableCell(
                 child: Center(child: 
                Row(
                  children: [
                    IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () {
                                              _showEditDialog(context, documents[index].id, data["price"],
                                                  data["name"],  data["description"]);
                                            },
                                          ),
                                           IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                    try {
                                            await FirebaseFirestore.instance
                                                .collection("products")
                                                .doc(documents[index].id)
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
                  ],
                ),
                 
                 ),
                              ),
                               
                //                 TableCell(
                //  child: Center(child:  
                //   IconButton(
                //                 icon: Icon(Icons.delete),
                //                 onPressed: () async {
                //                     try {
                //                             await FirebaseFirestore.instance
                //                                 .collection("products")
                //                                 .doc(documents[index].id)
                //                                 .delete();
                //                           } catch (e) {
                //                             print(
                //                                 'Error deleting document: $e');
                //                           }
                //                   // Call your Firebase delete function or use a service class
                //                   // to handle the deletion of the task
                //                   // Example: FirebaseService.deleteTask(task.id);
                //                 },
                //               ), 
                //               ),
                //               ),
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




                  //  ServiceCard(
                  //    imageUrl: data['image'],
                  //    price: data['price'],
                  //    title: data['name'],
                  //    // hour: data['time'],
                  //    description: data['description'],
                  //    id:documents[index].id
                    
                  //  );
                 },
               ),
             );
                  },
                ),
          ],
        )
      // Padding(
      //   padding: const EdgeInsets.all(16.0),
      //   child: SingleChildScrollView(
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         Container(
      //           alignment: Alignment.topLeft,
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: [
      //               Text(
      //                 'Manage Products',
      //                 style: TextStyle(
      //                   fontSize: 22,
      //                   fontWeight: FontWeight.w700,
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //         SizedBox(
      //           height: 15,
      //         ),
      //         Row(
      //           children: [
      //             _rowHeader(1, 'Image'),
      //             _rowHeader(3, 'Name '),
      //             _rowHeader(2, 'Price'),
      //             _rowHeader(2, 'Quantity'),
      //             _rowHeader(1, 'ACTION'),
      //             _rowHeader(1, 'VIEW MORE'),
      //           ],
      //         ),
      //         ProductListWidget(),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
class ServiceCard extends StatelessWidget {
  final String imageUrl;
  final String price;
  final String title;

  final String description;
 final String id;  
 

  ServiceCard({
    required this.imageUrl,
    required this.price,
    required this.title,

    required this.description,
    required this.id,

  });
  TextEditingController taskiController = TextEditingController();
   TextEditingController deadlineController = TextEditingController();
    TextEditingController onTimeController = TextEditingController();
     TextEditingController statusController = TextEditingController();
 void  _showEditDialog(BuildContext context, String id, String price,
      String title,  String description) {

           taskiController.text = price;
      deadlineController.text = title;
 
     statusController.text = description;
     print(onTimeController.text);
    print(id + "asdasdasdasdasdsd");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: taskiController,
                decoration:
                    InputDecoration(labelText: 'Price', hintText: price),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: deadlineController,
                decoration:
                    InputDecoration(labelText: 'title', hintText:title),
              ),
            
              SizedBox(height: 16.0),
              TextField(
                controller: statusController,
                decoration: InputDecoration(
                    labelText: 'description', hintText: description),
              ),
              SizedBox(height: 16.0),
              //   Row(
              //     children: [
              //       Text('Deadline: ${selectedDate.toLocal()}'),
              //       SizedBox(width: 10.0),
              //       ElevatedButton(
              //         onPressed: () => _selectDate(context, selectedDate),
              //         child: Text('Select Date'),
              //       ),
              //     ],
              //   ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _updateTasksJoin(
                    id,
                    taskiController.text,
                    deadlineController.text,
                  
                    statusController.text);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
    Future<void> _updateTasksJoin(String id, String price, String title,
      String description,) async {
    await FirebaseFirestore.instance.collection('tasks').doc(id).update(
      {
        'price': price,
        'name': title,
       
        "description": description,
      },
    );

    // taskController.text == "";
    // deadlineController.text == "";
    // onTimeController.text == "";
    // statusController.text == "";
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(imageUrl),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Price: $price',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('Title: $title'),
              
                Text('Description: $description'),
              ],
            ),
          ),
            Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          _showEditDialog(context, id, price,
                                              title,  description);
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () async {
                                          try {
                                            await FirebaseFirestore.instance
                                                .collection("products")
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
                                    ],
                                  ),
        ],
      ),
    );
  }
}