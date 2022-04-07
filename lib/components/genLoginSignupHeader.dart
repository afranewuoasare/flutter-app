import 'package:flutter/material.dart';

class genLoginSignupHeader extends StatelessWidget {
  String headerName;

  genLoginSignupHeader(this.headerName);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 100.0),
          Text(
            headerName,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 40.0),
          ),
          SizedBox(height: 10.0),
          Image.network(
            "https://i.pinimg.com/originals/a0/0c/0b/a00c0bf76f84fd7c9d5f7ec3cd2a6ecd.jpg",
            height: 150.0,
            width: 150.0,
          ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
