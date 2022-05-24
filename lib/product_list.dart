import 'dart:convert';

import 'package:cart_app/fruit.dart';
import 'package:cart_app/modal_tile.dart';
import 'package:cart_app/product_tile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cart_app/category_tile.dart';

class ProductPageMain extends StatefulWidget {
  const ProductPageMain({Key? key}) : super(key: key);

  @override
  State<ProductPageMain> createState() => _ProductPageMainState();
}

class _ProductPageMainState extends State<ProductPageMain> {
  Future<List<Fruit>> getObjects() async {
    String data =
        await DefaultAssetBundle.of(context).loadString("assets/input.json");
    final jsonResult = jsonDecode(data);
    List<Fruit> fruitsList = [];
    for (var obj in jsonResult) {
      Fruit e = Fruit.fromJson(obj);
      fruitsList.add(e);
    }

    return fruitsList;
    //latest Dart
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Fruit>>(
        future: getObjects(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ProductListPage(products: snapshot.data ?? []);
          }
          return CircularProgressIndicator(strokeWidth: 1);
        });
  }
}

class ProductListPage extends StatefulWidget {
  List<Fruit> products;
  ProductListPage({required this.products, Key? key}) : super(key: key);

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<String> categories = ['All', 'Tamilnadu', 'Premium'];
  String curCategory = "All";
  List cart = [];
  bool hasInitialized = false;

  void alterCategory(category) {
    setState(() {
      curCategory = category;
    });
  }

  void addToCart(fruit) {
    setState(() {
      cart.add(fruit.id);
    });
    print(cart);
  }

  void removeFromCart(fruit) {
    setState(() {
      cart.remove(fruit.id);
    });
    print(cart);
  }

  void incrementDecrement(id, val) {
    setState(() {
      for (var fruit in widget.products) {
        if (fruit.id == id) {
          if (val) {
            fruit.quantity += 1;
          } else {
            fruit.quantity -= 1;
          }
        }
      }
    });

    for (var fruit in widget.products) {
      print(fruit.quantity);
    }
  }

  showAlertDialog(BuildContext context) {
    String output = "";
    for (final fruit in widget.products) {
      output += jsonEncode(fruit);
    }

    // Create button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Output"),
      content: Text(output),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // CODE FOR THE MODAL BOTTOM SHEET

  void popSheet() {
    List cartFruits = [];
    for (final e in widget.products) {
      if (cart.contains(e.id)) {
        cartFruits.add(e);
      }
    }
    void removeFruitCart(func, id) {
      List newCartFruits = [];
      for (final e in widget.products) {
        if (cart.contains(e.id)) {
          newCartFruits.add(e);
        }
      }
      func(() {
        cartFruits = newCartFruits;
      });
    }

    void increDecre(index, func, incre) {
      if (incre) {
        func(() {
          cartFruits[index].quantity += 1;
        });
      } else {
        func(() {
          cartFruits[index].quantity -= 1;
        });
      }
    }

    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, stateSetter) {
            num totalPrice = 0;
            for (final e in cartFruits) {
              totalPrice += (e.quantity * e.cost);
            }
            return Container(
              height: MediaQuery.of(context).size.height * .9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Text("Cart",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
                  SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: List.generate(
                          cartFruits.length,
                          (index) => ModalTile(
                              fruit: cartFruits[index],
                              cart: cart,
                              index: index,
                              increDecre: increDecre,
                              innerState: stateSetter,
                              innerCart: removeFruitCart,
                              removeFromCart: removeFromCart),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Price",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 15),
                            Text(
                              "${totalPrice}",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        TextButton(
                          child: Text(
                            "Buy now",
                            style: TextStyle(fontSize: 18),
                          ),
                          onPressed: () {},
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(250, 252, 254, 1),
        appBar: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 100),
          child: Container(
            margin: EdgeInsets.fromLTRB(20, 40, 0, 0),
            child: Row(children: [
              Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  child: Icon(Icons.arrow_back, color: Colors.white)),
            ]),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: Center(
                  child: Text(
                    "Fruits",
                    style: GoogleFonts.openSans(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 15),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                      categories.length,
                      (index) => CategoryTile(
                            category: categories[index],
                            changeCategory: alterCategory,
                            isSelected:
                                curCategory == categories[index] ? true : false,
                          )),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    ...List.generate(
                      widget.products.length,
                      (index) => ProductTile(
                        cart: cart,
                        fruit: widget.products[index],
                        curCategory: curCategory,
                        addToCart: addToCart,
                        removeFromCart: removeFromCart,
                        incrementDecrement: incrementDecrement,
                      ),
                    )
                  ],
                ),
              ),
            )
            // child: FutureBuilder<List<Fruit>>(
            //     future: getObjects(),
            //     builder: (context, snapshot) {
            //       if (snapshot.connectionState == ConnectionState.done) {
            //         List<ProductTile> test = [];
            //         snapshot.data?.forEach((element) {
            //           print(element.imageUrl);
            //           var tile = ProductTile(
            //             fruit: element,
            //             curCategory: curCategory,
            //             addToCart: addToCart,
            //             removeFromCart: removeFromCart,
            //             incrementDecrement: incrementDecrement,
            //             cart: cart,
            //           );
            //           test.add(tile);
            //         });

            //         return SingleChildScrollView(
            //           child: Column(
            //             children: test,
            //           ),
            //         );
            //       }
            //       return CircularProgressIndicator(
            //         strokeWidth: 1,
            //       );
            //     })),
            ,
            Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      child: Text(
                        "Output",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      onPressed: () => showAlertDialog(context),
                    ),
                    TextButton(
                      child: Text(
                        "Go to cart",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      onPressed: popSheet,
                    ),
                  ],
                ))
          ],
        ));
  }
}
