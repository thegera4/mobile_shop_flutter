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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _expanded ?
      min(widget.order.products.length * 20.0 + 150, 200) : 95,
      child: Card(
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
            //if (_expanded)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                height: _expanded ?
                  min(widget.order.products.length * 25.0 + 30, 180) : 0,
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
      ),
    );
  }
}