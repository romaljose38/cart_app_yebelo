import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryTile extends StatelessWidget {
  String category;
  var changeCategory;
  bool isSelected;
  CategoryTile({
    required this.category,
    required this.changeCategory,
    required this.isSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        this.changeCategory(this.category);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: this.isSelected ? Colors.lightGreen : Colors.grey,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        height: 35,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              this.category,
              style: GoogleFonts.openSans(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
