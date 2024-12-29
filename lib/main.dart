import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sqflite_crud/customer_model.dart';
import 'package:sqflite_crud/database_helper.dart';


void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) { 
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController fNameEditingController;
  late TextEditingController lNameEditingController;
  late TextEditingController emailEditingController;

  Random random = Random();

  int customerId = 0;

  @override
  void initState() {
    fNameEditingController = TextEditingController();
    lNameEditingController = TextEditingController();
    emailEditingController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Customer Management"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Add Customer",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
              ),
              SizedBox(height: 20),
              TextField(
                controller: fNameEditingController,
                decoration: InputDecoration(
                  labelText: "First Name",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: lNameEditingController,
                decoration: InputDecoration(
                  labelText: "Last Name",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: emailEditingController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final customer = CustomerModel(
                        id: random.nextInt(100),
                        firstName: fNameEditingController.text,
                        lastName: lNameEditingController.text,
                        email: emailEditingController.text,
                      );

                      await DatabaseHelper.instance.addCustomer(customer);
                      setState(() {});
                    },
                    child: Text("Save"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final customer = CustomerModel(
                        id: customerId,
                        firstName: fNameEditingController.text,
                        lastName: lNameEditingController.text,
                        email: emailEditingController.text,
                      );
                      await DatabaseHelper.instance.updateCustomer(customer);
                      fNameEditingController.clear();
                      setState(() {});
                    },
                    child: Text("Update"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Text(
                "Customer List",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
              ),
              SizedBox(height: 10),
              Container(
                height: 400,
                child: FutureBuilder(
                  future: DatabaseHelper.instance.getCustomer(),
                  builder: (BuildContext context, AsyncSnapshot<List<CustomerModel>> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return ListView(
                      children: snapshot.data!.map((customer) {
                        return Card(
                          elevation: 5,
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            title: Text(
                              "${customer.firstName} ${customer.lastName}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(customer.email!),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    await DatabaseHelper.instance.deleteCustomer(customer.id);
                                    setState(() {});
                                  },
                                  icon: Icon(Icons.delete, color: Colors.red),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      fNameEditingController.text = customer.firstName!;
                                      lNameEditingController.text = customer.lastName!;
                                      emailEditingController.text = customer.email!;
                                      customerId = customer.id!;
                                    });
                                  },
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}
