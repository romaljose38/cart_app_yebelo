// ignore_for_file: prefer_const_constructors
import 'package:google_fonts/google_fonts.dart';
import 'package:cart_app/fruit.dart';
import 'package:flutter/material.dart';

class ProductTile extends StatefulWidget {
  Fruit fruit;
  String curCategory;
  List cart;
  Function addToCart;
  Function incrementDecrement;

  Function removeFromCart;

  ProductTile({
    required this.fruit,
    required this.addToCart,
    required this.incrementDecrement,
    required this.removeFromCart,
    required this.cart,
    required this.curCategory,
    Key? key,
  }) : super(key: key);

  @override
  State<ProductTile> createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  bool isSelected = false;

  void alterCart() {
    print(widget.fruit.availability);
    var inStockSnackBar = SnackBar(
      duration: Duration(milliseconds: 800),
      content: Text('${widget.fruit.name} added to cart.'),
    );

    var outOfStockSnackBar = SnackBar(
      duration: Duration(milliseconds: 800),
      content: Text('${widget.fruit.name} is out of stock.'),
    );

    var removedFromCartSnackBar = SnackBar(
        duration: Duration(milliseconds: 800),
        content: Text('${widget.fruit.name} removed from cart.'));

    if (widget.cart.contains(widget.fruit.id)) {
      ScaffoldMessenger.of(context).showSnackBar(removedFromCartSnackBar);
      // setState(() {
      //   isSelected = false;
      // });
      widget.removeFromCart(widget.fruit);
    } else {
      if (widget.fruit.availability != 1) {
        ScaffoldMessenger.of(context).showSnackBar(outOfStockSnackBar);
      } else {
// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
        widget.addToCart(widget.fruit);
        ScaffoldMessenger.of(context).showSnackBar(inStockSnackBar);
        // setState(() {
        //   isSelected = true;
        // });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ((widget.curCategory != "All") &&
            (widget.curCategory != widget.fruit.category))
        ? Container()
        : Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            width: MediaQuery.of(context).size.width,
            height: 170,
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
                              style: GoogleFonts.raleway(
                                fontWeight: FontWeight.w800,
                                fontSize: 17,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              (widget.fruit.details != ""
                                      ? "${widget.fruit.details} | "
                                      : widget.fruit.details) +
                                  (widget.fruit.availability == 1
                                      ? "In stock"
                                      : "Out of stock"),
                              style: GoogleFonts.openSans(
                                  color: Colors.grey.withOpacity(.7),
                                  fontSize: 10),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Rs. ${widget.fruit.cost}',
                              style: GoogleFonts.raleway(
                                  color: Colors.lightGreen,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      widget.incrementDecrement(
                                          widget.fruit.id, false);
                                    },
                                    icon: Icon(Icons.remove, size: 30)),
                                Text("${widget.fruit.quantity}"),
                                IconButton(
                                    onPressed: () {
                                      widget.incrementDecrement(
                                          widget.fruit.id, true);
                                    },
                                    icon: Icon(Icons.add, size: 30))
                              ],
                            ),
                          ]),
                    ),
                  ),
                  GestureDetector(
                    onTap: alterCart,
                    child: Container(
                      margin: const EdgeInsets.only(right: 15),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.lightGreen),
                      child: Icon(
                          (widget.cart.contains(widget.fruit.id))
                              ? Icons.delete
                              : Icons.shopping_cart,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
