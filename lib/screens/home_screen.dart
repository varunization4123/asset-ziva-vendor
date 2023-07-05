import 'package:asset_ziva_vendor/utils/colors.dart';
import 'package:asset_ziva_vendor/utils/constants.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 1,
        toolbarHeight: 72.0,
        title: const Row(
          children: [
            Icon(
              Icons.location_on,
              color: primaryColor,
              size: 24.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selected Location',
                  style: TextStyle(color: secondaryColor, fontSize: p),
                ),
                Text(
                  '560061, Bangalore',
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: subP,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Container(),
    ));
  }
}
