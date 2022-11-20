import 'package:flutter/material.dart';

class AppBanner extends StatelessWidget {
  const AppBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 80.0,
      ),
      
      //transform: Matrix4.rotationZ(-5 * pi / 360)..translate(-20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(80),
        color: Colors.white54,
        boxShadow: const [
          BoxShadow(
            blurRadius: 80,
            color: Color.fromARGB(255, 215, 210, 210),
            offset: Offset(0, 8),
          )
        ],
      ),
      
      child: Text(
        'Eight Shop',
        style: TextStyle(
          color: Colors.red.shade900,
          fontSize: 50,
          fontFamily: 'Anton',
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}