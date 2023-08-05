import 'package:asset_ziva_vendor/utils/colors.dart';
import 'package:asset_ziva_vendor/utils/constants.dart';
import 'package:asset_ziva_vendor/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class DashboardCard extends StatefulWidget {
  final Map<String, dynamic> snap;
  const DashboardCard({super.key, required this.snap});

  @override
  State<DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          if (isExpanded == false) {
            isExpanded = true;
          } else {
            isExpanded = false;
          }
        });
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 10),
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
              child: isExpanded == false
                  ? Text('Property ${widget.snap['service']}')
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Property ${widget.snap['service']}'),
                        const SizedBox(height: gap * 2),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Address: ${widget.snap['address']}',
                              style: const TextStyle(color: primaryColor),
                            ),
                            const SizedBox(height: gap),
                            Text(
                              'Contact: ${widget.snap['contact number']}',
                              style: const TextStyle(color: primaryColor),
                            ),
                            // const SizedBox(height: gap * 2),
                            // CustomButton(text: 'Completed', onPressed: () {})
                          ],
                        ),
                      ],
                    )),
        ),
      ),
    );
  }
}
