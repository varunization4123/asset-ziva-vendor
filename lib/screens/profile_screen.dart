import 'package:asset_ziva_vendor/provider/auth_provider.dart';
import 'package:asset_ziva_vendor/screens/welcome_screen.dart';
import 'package:asset_ziva_vendor/utils/colors.dart';
import 'package:asset_ziva_vendor/utils/constants.dart';
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
            ],
          ),
        ),
      ),
    );
  }
}
