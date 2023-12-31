import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class DashboardScreen extends StatefulWidget {
   static const String id = '\dashboardScreen';
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int totalSales = 0;
  int totalCustomers = 0;
  int totalVendors = 0;

  @override
  void initState() {
    super.initState();
    fetchTotalSales();
    fetchTotalCustomers();
    fetchTotalVendors();
  }

  Future<void> fetchTotalSales() async {
    QuerySnapshot ordersSnapshot = await FirebaseFirestore.instance.collection('orders').get();

    int total = 0;
    for (QueryDocumentSnapshot doc in ordersSnapshot.docs) {
      total += int.parse(doc['total']) ?? 0;
    }

    setState(() {
      totalSales = total;
    });
  }

  Future<void> fetchTotalCustomers() async {
    QuerySnapshot buyersSnapshot = await FirebaseFirestore.instance
        .collection('buyers')
        .where('role', isEqualTo: 'customer')
        .get();

    setState(() {
      totalCustomers = buyersSnapshot.size;
    });
  }

  Future<void> fetchTotalVendors() async {
    QuerySnapshot sellersSnapshot = await FirebaseFirestore.instance
        .collection('buyers')
        .where('role', isEqualTo: 'seller')
        .get();

    setState(() {
      totalVendors = sellersSnapshot.size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Sales',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\$$totalSales',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Customers',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '$totalCustomers',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Vendors',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '$totalVendors',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
