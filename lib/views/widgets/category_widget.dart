import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class CategoryListWidget extends StatelessWidget {
  const CategoryListWidget({super.key});
   addServices(title,) async{
      EasyLoading.show(status: "Running");


   if (
    
        title.isNotEmpty 
      
        ) {
      await FirebaseFirestore.instance.collection('cat').add({
        // 'category': selectedService,
        'name': title,
       
        
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
  @override
  Widget build(BuildContext context) {
      late String title;
bool _isLoading = false;

    return
    Column(children: [
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
                           GestureDetector(
                  onTap: ()async {
 
  addServices(title);
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
                                'Add Category',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 4,
                                ),
                              )),
                  ),
                ),
    ],);
    
    //  StreamBuilder<QuerySnapshot>(
    //   stream: _categoryStream,
    //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    //     if (snapshot.hasError) {
    //       return Text('Something went wrong');
    //     }

    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return Material(
    //         child: CircularProgressIndicator(color: Colors.yellow.shade900),
    //       );
    //     }

    //     if (snapshot.data!.docs.isEmpty) {
    //       return Center(
    //         child: Text(
    //           'No Categories\n Added yet',
    //           style: TextStyle(
    //             color: Colors.blueGrey,
    //             fontSize: 30,
    //           ),
    //         ),
    //       );
    //     }
    //     return GridView.builder(
    //         shrinkWrap: true,
    //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //           crossAxisCount: 6,
    //           mainAxisSpacing: 8,
    //           crossAxisSpacing: 8,
    //         ),
    //         itemCount: snapshot.data!.docs.length,
    //         itemBuilder: (context, index) {
    //           var data = snapshot.data!.docs[index];

    //           return Padding(
    //             padding: const EdgeInsets.all(15.0),
    //             child: Container(
    //               child: Column(
    //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                 children: [
    //                   SizedBox(
    //                     height: 100,
    //                     width: 100,
    //                     child: Image.network(
    //                       data['image'],
    //                       width: double.infinity,
    //                       fit: BoxFit.fitWidth,
    //                     ),
    //                   ),
    //                   Padding(
    //                     padding: const EdgeInsets.all(8.0),
    //                     child: Text(data['categoryName']),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           );
    //         });
    //   },
    // );
  }
}
