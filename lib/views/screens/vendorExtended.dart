import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';




class ServicesGrid extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
   String? id;
   ServicesGrid({this.id});
  @override
  Widget build(BuildContext context) {
    return
     StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('services').where("userId",isEqualTo:id ).snapshots(),
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
         Column(
          children: [
            Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Services',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  var data = documents[index].data();
                  return ServiceCard(
                    imageUrl: data['image'],
                    price: data['price'],
                    title: data['name'],
                    hour: data['time'],
                    description: data['description'],
                    id:documents[index].id
                   
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String imageUrl;
  final String price;
  final String title;
  final String hour;
  final String description;
 final String id;  
 

  ServiceCard({
    required this.imageUrl,
    required this.price,
    required this.title,
    required this.hour,
    required this.description,
    required this.id,

  });
  TextEditingController taskiController = TextEditingController();
   TextEditingController deadlineController = TextEditingController();
    TextEditingController onTimeController = TextEditingController();
     TextEditingController statusController = TextEditingController();
 void  _showEditDialog(BuildContext context, String id, String price,
      String title, String hour, String description) {

           taskiController.text = price;
      deadlineController.text = title;
         onTimeController.text = hour;
     statusController.text = description;
     print(onTimeController.text);
    print(id + "asdasdasdasdasdsd");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Task'),
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
                controller: onTimeController,
                decoration:
                    InputDecoration(labelText: 'hour', hintText: hour),
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
                    onTimeController.text,
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
    Future<void> _updateTasksJoin(String id, String task, String diets,
      String onTime, String status) async {
    await FirebaseFirestore.instance.collection('tasks').doc(id).update(
      {
        'price': task,
        'name': diets,
        "time": onTime,
        "description": status,
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
      height: 300,
      width: 200,
      // elevation: 5.0,
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
                Text('Category: $title'),
                Text('Hour: $hour'),
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
                                              title, hour, description);
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () async {
                                          try {
                                            await FirebaseFirestore.instance
                                                .collection("services")
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
