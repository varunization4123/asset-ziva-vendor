import 'package:asset_ziva_vendor/provider/auth_provider.dart';
// import 'package:asset_ziva_vendor/screens/navigation_screen.dart';
import 'package:asset_ziva_vendor/screens/profile_screen.dart';
import 'package:asset_ziva_vendor/screens/register_screen.dart';
import 'package:asset_ziva_vendor/utils/colors.dart';
import 'package:asset_ziva_vendor/utils/constants.dart';
import 'package:asset_ziva_vendor/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: margin, horizontal: margin),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 24.0,
                  ),
                  child: Image.asset(
                    "assets/assetziva_logo.png",
                    height: 80,
                  ),
                ),
                const SizedBox(height: gap),
                const Text(
                  "Manage you property with us.",
                  style: TextStyle(
                    fontSize: 14,
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: gap),
                // custom button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: CustomButton(
                    onPressed: () async {
                      if (ap.isSignedIn == true) {
                        await ap.getDataFromSP().whenComplete(
                              () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProfileScreen(),
                                ),
                              ),
                            );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      }
                    },
                    text: "Get started",
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
