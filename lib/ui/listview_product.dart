import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'product_screen.dart';
import 'product_information.dart';
import 'package:crud/model/product.dart';

class ListViewProduct extends StatefulWidget {
  @override
  _ListViewProductState createState() => _ListViewProductState();
}

final productReference = FirebaseDatabase.instance.reference().child('product');

class _ListViewProductState extends State<ListViewProduct> {

  List<Product> items;
  StreamSubscription<Event> _onProductAddedSubscription;
  StreamSubscription<Event> _onProductChangedSubscription;

  //The framework will call this method exactly once for each State object it creates.
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    items = new List();
    _onProductAddedSubscription = productReference.onChildAdded.listen(_onProductAdded);
    _onProductChangedSubscription = productReference.onChildAdded.listen(_onProductChanged);

  }

  //The framework calls this method when this State object will never build again
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _onProductAddedSubscription.cancel();
    _onProductChangedSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product DB',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Product Information'),
          centerTitle: true,
          backgroundColor: Colors.deepPurpleAccent,
        ),
        body: Center(
          child: ListView.builder(
              itemCount: items.length,
            padding: EdgeInsets.only(top:12.0),
            itemBuilder: (context, position){
                return Column(
                  children: <Widget>[
                    Divider(height: 7.0,),
                    Row(
                      children: <Widget>[
                        Expanded(child: ListTile(title: Text('${items[position].name}',
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 21.0,
                          ),
                        ),
                    leading: Column(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.amberAccent,
                          radius: 17.0,
                          child: Text('${items[position].description}',
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 21.0,
                            )
                        )
                      ],
                    ),
                onTap: ()=> _navigateToProductInformation(context, items[position]),
                        ),),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red,),
                          onPressed: () => _deleteProduct(context, items[position], position)),
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blueAccent,),
                          onPressed: () => _navigateToProduct(context, items[position], position)),
                        ],
                      ),
                  ],
                );
            },
          ),
        ),

      )
    );


  }
}
