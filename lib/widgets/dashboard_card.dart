import 'package:asset_ziva_vendor/utils/colors.dart';
import 'package:asset_ziva_vendor/utils/constants.dart';
import 'package:asset_ziva_vendor/widgets/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class DashboardCard extends StatefulWidget {
  final Map<String, dynamic> snap;
  final String docId;
  final bool isComplete;
  const DashboardCard(
      {super.key,
      required this.snap,
      required this.docId,
      required this.isComplete});

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
        elevation: widget.isComplete == false ? 10 : 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
              child: isExpanded == false
                  ? Text(
                      'Property ${widget.snap['service']}',
                      style: TextStyle(
                        color: widget.isComplete == false
                            ? secondaryColor
                            : disabledColor,
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Property ${widget.snap['service']}',
                          style: TextStyle(
                            color: widget.isComplete == false
                                ? secondaryColor
                                : disabledColor,
                          ),
                        ),
                        const SizedBox(height: gap * 2),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Client: ${widget.snap['contact name']}',
                              style: TextStyle(
                                color: widget.isComplete == false
                                    ? primaryColor
                                    : disabledColor,
                              ),
                            ),
                            const SizedBox(height: gap),
                            Text(
                              'Contact: ${widget.snap['contact number']}',
                              style: TextStyle(
                                color: widget.isComplete == false
                                    ? primaryColor
                                    : disabledColor,
                              ),
                            ),
                            const SizedBox(height: gap),
                            Text(
                              'Address: ${widget.snap['address']}',
                              style: TextStyle(
                                color: widget.isComplete == false
                                    ? primaryColor
                                    : disabledColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: gap * 2),
                        CustomButton(
                          isDisabled: widget.isComplete,
                          text: 'Completed',
                          onPressed: () async {
                            setState(() {
                              isExpanded = false;
                            });
                            try {
                              await _firestore
                                  .collection('services')
                                  .doc(widget.docId)
                                  .update({
                                'status': 'Complete',
                              });
                            } catch (error) {
                              print('Error updating data: $error');
                            }
                          },
                        )
                      ],
                    )),
        ),
      ),
    );
  }
}
