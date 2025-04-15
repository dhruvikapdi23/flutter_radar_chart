import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GeometryType extends StatelessWidget {
  final String type1,type2;
  const GeometryType({super.key,  required this.type1, required this.type2});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15,right: 15),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Color(0XFFECF5FD),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withValues(alpha: .10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              text: "$type1:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0XFF3C6080),
              ),
              children: [
                TextSpan(
                  text: "Geometry",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Color(0XFF3C6080),
                  ),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: "$type2:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0XFF3C6080),
              ),
              children: [
                TextSpan(
                  text: "Geometry",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Color(0XFF3C6080),
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
