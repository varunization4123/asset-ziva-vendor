import 'package:asset_ziva_vendor/provider/auth_provider.dart';
// import 'package:asset_ziva_vendor/screens/navigation_screen.dart';
import 'package:asset_ziva_vendor/screens/profile_screen.dart';
import 'package:asset_ziva_vendor/screens/vendor_information_screen.dart';
import 'package:asset_ziva_vendor/utils/colors.dart';
import 'package:asset_ziva_vendor/utils/constants.dart';
import 'package:asset_ziva_vendor/utils/utils.dart';
import 'package:asset_ziva_vendor/widgets/custom_button.dart';
import 'package:asset_ziva_vendor/widgets/login_button.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  const OtpScreen({super.key, required this.verificationId});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String? otpCode;
  bool isLoading = false;

  @override
  void initState() {
    _listenOtp();
    super.initState();
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    print("Unregistered Listener");
    super.dispose();
  }

  void _listenOtp() async {
    await SmsAutoFill().listenForCode();
    print("OTP Listen is called");
  }

  @override
  Widget build(BuildContext context) {
    var isLoading = Provider.of<AuthProvider>(context, listen: true).isLoading;
    return Scaffold(
      body: SafeArea(
        child: isLoading == true
            ? const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              )
            : Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Icon(Icons.arrow_back),
                        ),
                      ),
                      // Container(
                      //   width: 200,
                      //   height: 200,
                      //   padding: const EdgeInsets.all(20.0),
                      //   decoration: BoxDecoration(
                      //     shape: BoxShape.circle,
                      //     color: Colors.purple.shade50,
                      //   ),
                      //   child: Image.asset(
                      //     "assets/image2.png",
                      //   ),
                      // ),
                      const SizedBox(height: 20),
                      const Text(
                        "Verification",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Enter the OTP send to your phone number",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black38,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),

                      PinFieldAutoFill(
                        currentCode: otpCode,
                        decoration: BoxLooseDecoration(
                            radius: const Radius.circular(10),
                            strokeColorBuilder:
                                const FixedColorBuilder(primaryColor)),
                        codeLength: 6,
                        onCodeChanged: (code) {
                          print("OnCodeChanged : $code");
                          otpCode = code.toString();
                        },
                        onCodeSubmitted: (val) {
                          print("OnCodeSubmitted : $val");
                        },
                      ),

                      // Pinput(
                      //   length: 6,
                      //   showCursor: true,
                      //   defaultPinTheme: PinTheme(
                      //     width: 60,
                      //     height: 60,
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(10),
                      //       border: Border.all(
                      //         color: primaryColor,
                      //       ),
                      //     ),
                      //     textStyle: const TextStyle(
                      //       fontSize: 20,
                      //       fontWeight: FontWeight.w600,
                      //     ),
                      //   ),
                      //   onCompleted: (value) {
                      //     setState(() {
                      //       otpCode = value;
                      //     });
                      //   },
                      // ),

                      const SizedBox(height: 25),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: LoginButton(
                          widget: isLoading == true
                              ? const SizedBox(
                                  height: gap,
                                  width: gap,
                                  child: CircularProgressIndicator(
                                      color: whiteColor),
                                )
                              : const Text("Verify",
                                  style: TextStyle(fontSize: 16)),
                          onPressed: () {
                            if (otpCode != null) {
                              setState(() {
                                isLoading = true;
                              });
                              verifyOtp(context, otpCode!);
                            } else {
                              showSnackBar(context, "Enter 6-Digit code");
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Didn't receive any code?",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black38,
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "Resend New Code",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  // verify otp
  void verifyOtp(BuildContext context, String vendorOtp) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    ap.verifyOtp(
      context: context,
      verificationId: widget.verificationId,
      vendorOtp: vendorOtp,
      onSuccess: () {
        // checking whether vendor exists in the db
        ap.checkExistingVendor().then(
          (value) async {
            if (value == true) {
              // vendor exists in our app
              ap.getDataFromFirestore().then(
                    (value) => ap.saveVendorDataToSP().then(
                          (value) => ap.setSignIn().then(
                                (value) => Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ProfileScreen(),
                                    ),
                                    (route) => false),
                              ),
                        ),
                  );
            } else {
              // new vendor
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const VendorInfromationScreen()),
                  (route) => false);
            }
          },
        );
      },
    );
  }
}
