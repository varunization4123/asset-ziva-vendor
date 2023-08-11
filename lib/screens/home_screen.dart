import 'package:asset_ziva_vendor/provider/auth_provider.dart';
import 'package:asset_ziva_vendor/utils/colors.dart';
import 'package:asset_ziva_vendor/utils/constants.dart';
import 'package:asset_ziva_vendor/widgets/dashboard_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 1,
        toolbarHeight: 72.0,
        title: const Text(
          "Dashboard",
          style: TextStyle(
            color: whiteColor,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Requests',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: gap),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('services')
                          .where('vendor', isEqualTo: ap.vendorModel.name)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator(
                            color: primaryColor,
                          );
                        }
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final status =
                                  snapshot.data!.docs[index]['status'];
                              bool isComplete = status == 'complete';
                              DashboardCard(
                                snap: snapshot.data!.docs[index].data(),
                                docId: snapshot.data!.docs[index].id,
                                isComplete: isComplete,
                              );
                              return null;
                            });
                      },
                    ),
                    const SizedBox(height: gap),
                  ],
                ),
                // const SizedBox(height: gap * 2),
                // const Text(
                //   'Other Services',
                //   style: TextStyle(
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                // GridView.builder(
                //   physics: const ScrollPhysics(),
                //   scrollDirection: Axis.vertical,
                //   shrinkWrap: true,
                //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //     crossAxisCount: 2,
                //     mainAxisSpacing: 0.2,
                //     crossAxisSpacing: 0.2,
                //   ),
                //   itemCount: services.length,
                //   itemBuilder: (context, index) {
                //     return PropertyServicesCard(
                //         service: services[index]['service'],
                //         amount: services[index]['amount']);
                //   },
                // )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
