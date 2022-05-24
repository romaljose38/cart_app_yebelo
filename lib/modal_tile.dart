// ignore_for_file: prefer_const_constructors

import 'package:cart_app/fruit.dart';
import 'package:flutter/material.dart';

class ModalTile extends StatefulWidget {
  Fruit fruit;
  List cart;
  Function removeFromCart;
  int index;
  Function increDecre;
  Function innerState;
  Function innerCart;
  ModalTile({
    required this.fruit,
    required this.cart,
    required this.index,
    required this.increDecre,
    required this.removeFromCart,
    required this.innerState,
    required this.innerCart,
    Key? key,
  }) : super(key: key);

  @override
  State<ModalTile> createState() => _ModalTileState();
}

class _ModalTileState extends State<ModalTile> {
  bool isSelected = false;

  void alterCart() {
    var removedFromCartSnackBar = SnackBar(
        duration: Duration(milliseconds: 800),
        content: Text('${widget.fruit.name} removed from cart.'));

    if (widget.cart.contains(widget.fruit.id)) {
      ScaffoldMessenger.of(context).showSnackBar(removedFromCartSnackBar);
      // setState(() {
      //   isSelected = false;
      // });
      widget.removeFromCart(widget.fruit);
      widget.innerCart(widget.innerState, widget.fruit.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      width: MediaQuery.of(context).size.width,
      height: 120,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(.5),
                blurRadius: 10,
                spreadRadius: 1,
                offset: const Offset(0, 3),
              ),
            ]),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: 15,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(widget.fruit.imageUrl),
                      fit: BoxFit.fitWidth),
                ),
                // margin: EdgeInsets.only(left: 15),
                child: Container(),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 25),
                      Text(
                        widget.fruit.name,
                        textAlign: TextAlign.left,
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Rs. ${widget.fruit.cost}',
                        style: TextStyle(
                            color: Colors.lightGreen,
                            fontSize: 15,
                            fontWeight: FontWeight.w700),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                              onPressed: () {
                                widget.increDecre(
                                    widget.index, widget.innerState, false);
                              },
                              icon: Icon(Icons.remove, size: 30)),
                          Text("${widget.fruit.quantity}"),
                          IconButton(
                              onPressed: () {
                                widget.increDecre(
                                    widget.index, widget.innerState, true);
                              },
                              icon: Icon(Icons.add, size: 30))
                        ],
                      ),
                    ]),
              ),
            ),
            SizedBox(width: 25),
            GestureDetector(
              onTap: alterCart,
              child: Container(
                margin: const EdgeInsets.only(right: 15),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.lightGreen),
                child: Icon(Icons.delete, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
