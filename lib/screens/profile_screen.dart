import 'package:asset_ziva_vendor/provider/auth_provider.dart';
import 'package:asset_ziva_vendor/screens/welcome_screen.dart';
import 'package:asset_ziva_vendor/utils/colors.dart';
import 'package:asset_ziva_vendor/utils/constants.dart';
import 'package:asset_ziva_vendor/widgets/dashboard_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: inputColor,
        elevation: 0,
        centerTitle: true,
        leading: TextButton(
          child: const Text(
            'Settings',
            style: TextStyle(color: inputColor),
          ),
          onPressed: () {},
        ),
        leadingWidth: 80,
        title: const Text(
          "Profile",
          style: TextStyle(color: inputColor, fontSize: h1),
        ),
        actions: [
          TextButton(
            child: const Text(
              "Logout",
              style: TextStyle(color: inputColor),
            ),
            onPressed: () {
              ap.vendorSignOut().then(
                    (value) => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WelcomeScreen(),
                      ),
                    ),
                  );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.width * 0.6,
                decoration: const BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: primaryColor,
                      backgroundImage: NetworkImage(ap.vendorModel.profilePic),
                      radius: 50,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      ap.vendorModel.name,
                      style: const TextStyle(
                        color: whiteColor,
                        fontSize: h1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ap.vendorModel.phoneNumber,
                      style: const TextStyle(color: whiteColor, fontSize: text),
                    ),
                  ],
                ),
              ),
              SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 24, horizontal: 24),
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
                                  .where('vendor',
                                      isEqualTo: ap.vendorModel.name)
                                  .where('status', isEqualTo: 'In Progress')
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<
                                          QuerySnapshot<Map<String, dynamic>>>
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
                                    itemBuilder: (context, index) =>
                                        DashboardCard(
                                          snap:
                                              snapshot.data!.docs[index].data(),
                                        ));
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
            ],
          ),
        ),
      ),
    );
  }
}
