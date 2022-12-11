import 'dart:math';
import 'package:flutter/material.dart';
import '../providers/orders.dart' as ord;
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget{
  final ord.OrderItem order;

  const OrderItem({super.key, required this.order,});

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('Total: \$ ${widget.order.amount.toStringAsFixed(2)}'),
            subtitle: Text(
                DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)
            ),
            trailing: IconButton(
              tooltip: _expanded ? 'Less Details' : 'More Details',
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: min(widget.order.products.length * 45.0 + 30, 150),
              child: ListView(
                children: widget.order.products.map((prod) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //ListTile for each product in the order
                    SizedBox(
                      //width to be as much as the screen
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: ListTile(
                        //circle avatar for the image
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(prod.imageUrl),
                        ),
                        title: Text(prod.title),
                        subtitle: Text('Price: \$${prod.price}'),
                        trailing: Text('x${prod.quantity}'),
                      ),
                    )
                  ],
                )).toList(),
              ),
            ),
        ],
        ),
    );
  }
}