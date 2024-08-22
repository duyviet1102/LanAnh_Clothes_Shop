import 'package:flutter/material.dart';

class Yellowbutton extends StatelessWidget {
  final String label; 
  final Function() onPressed; 
  final double width;
  const Yellowbutton({Key? key, required this.label,required this.onPressed,required this.width}): super(key: key);
  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 35,
      width: MediaQuery.of(context).size.width * 0.28 ,
      decoration: BoxDecoration(
        color: Colors.yellow,borderRadius: BorderRadius.circular(26),
      ),
      child: MaterialButton(onPressed: onPressed,
      child: Text(
        label,
      ),),
    );
  }
}