import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop/providers/order.dart';

class OrderItemCard extends StatefulWidget {
  final OrderItem order;

  const OrderItemCard(this.order, {super.key});

  @override
  State<OrderItemCard> createState() => _OrderItemCardState();
}

class _OrderItemCardState extends State<OrderItemCard> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.totalAmount}'),
            subtitle:
                Text(DateFormat('dd/MM/yyyy HH:mm').format(widget.order.date)),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: (() {
                setState(() {
                  _expanded = !_expanded;
                });
              }),
            ),
          ),
          // if (_expanded)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            constraints: BoxConstraints(
                minHeight: _expanded
                    ? min(widget.order.products.length * 30.0 + 50, 150)
                    : 0),
            child: Column(
              children: [
                const Divider(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  height: _expanded
                      ? min(widget.order.products.length * 30.0 + 50, 150)
                      : 0,
                  child: ListView(
                    children: [
                      ...widget.order.products.map((prod) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(prod.title),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('${prod.quantity}x \$${prod.price}'),
                            ),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
