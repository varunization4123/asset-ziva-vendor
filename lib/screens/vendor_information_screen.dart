import 'dart:io';
import 'package:asset_ziva_vendor/model/vendor_model.dart';
import 'package:asset_ziva_vendor/provider/auth_provider.dart';
import 'package:asset_ziva_vendor/screens/navigation_screen.dart';
import 'package:asset_ziva_vendor/screens/profile_screen.dart';
import 'package:asset_ziva_vendor/utils/colors.dart';
import 'package:asset_ziva_vendor/utils/utils.dart';
import 'package:asset_ziva_vendor/widgets/custom_button.dart';
import 'package:asset_ziva_vendor/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class VendorInfromationScreen extends StatefulWidget {
  const VendorInfromationScreen({super.key});

  @override
  State<VendorInfromationScreen> createState() =>
      _VendorInfromationScreenState();
}

class _VendorInfromationScreenState extends State<VendorInfromationScreen> {
  File? image;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final pincodeController = TextEditingController();
  late String service = 'Painting';
  late String city = 'Bangalore';
  // final bioController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    pincodeController.dispose();
    // bioController.dispose();
  }

  // for selecting image
  void selectImage() async {
    image = await pickImage(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;
    return Scaffold(
      body: SafeArea(
        child: isLoading == true
            ? const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              )
            : SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(vertical: 25.0, horizontal: 5.0),
                child: Center(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () => selectImage(),
                        child: image == null
                            ? const CircleAvatar(
                                backgroundColor: primaryColor,
                                radius: 50,
                                child: Icon(
                                  Icons.account_circle,
                                  size: 50,
                                  color: Colors.white,
                                ),
                              )
                            : CircleAvatar(
                                backgroundImage: FileImage(image!),
                                radius: 50,
                              ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 15),
                        margin: const EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            // name field
                            customTextField(
                              hintText: "John Smith",
                              // icon: Icons.account_circle,
                              inputType: TextInputType.name,
                              maxLines: 1,
                              controller: nameController,
                            ),

                            // email
                            customTextField(
                              hintText: "abc@example.com",
                              // icon: Icons.email,
                              inputType: TextInputType.emailAddress,
                              maxLines: 1,
                              controller: emailController,
                            ),

                            CustomDropdownButton<String>(
                              hintText: "Service",
                              options: const [
                                "Painting",
                                "Fencing",
                                "Plumbing",
                                "Civil Work",
                                "Electrician",
                                "Pest Control",
                                "Cleaning",
                                "Carpenter"
                              ],
                              value: service,
                              onChanged: (String? value) {
                                setState(() {
                                  service = value!;
                                  // state.didChange(newValue);
                                });
                              },
                              getLabel: (String? value) => value!,
                            ),

                            CustomDropdownButton<String>(
                              hintText: "City",
                              options: const [
                                "Bangalore",
                                "Hyderabad",
                                "Delhi",
                                "Chennai",
                                "Mumbai",
                                "Kolkata",
                                "Pune",
                              ],
                              value: city,
                              onChanged: (String? value) {
                                setState(() {
                                  city = value!;
                                  // state.didChange(newValue);
                                });
                              },
                              getLabel: (String? value) => value!,
                            ),

                            customTextField(
                              hintText: "100356",
                              // icon: Icons.email,
                              inputType: TextInputType.number,
                              maxLines: 1,
                              controller: pincodeController,
                            ),

                            // bio
                            // customTextField(
                            //   hintText: "Enter your bio here...",
                            //   // icon: Icons.edit,
                            //   inputType: TextInputType.name,
                            //   maxLines: 2,
                            //   controller: bioController,
                            // ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.90,
                        child: CustomButton(
                          text: "Continue",
                          onPressed: () {
                            if (image != null) {
                              Razorpay razorpay = Razorpay();
                              var options = {
                                'key': 'rzp_live_ILgsfZCZoFIKMb',
                                'amount': 500,
                                'name': 'Asset Ziva',
                                'description': 'Vendor Fees',
                                'retry': {'enabled': true, 'max_count': 1},
                                'send_sms_hash': true,
                                'prefill': {
                                  'contact': nameController.text,
                                  'email': emailController.text,
                                },
                                'external': {
                                  'wallets': ['paytm']
                                }
                              };
                              razorpay.on(
                                Razorpay.EVENT_PAYMENT_ERROR,
                                handlePaymentErrorResponse,
                              );
                              razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
                                  handlePaymentSuccessResponse);
                              razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
                                  handleExternalWalletSelected);
                              razorpay.open(options);
                            } else {
                              showSnackBar(context, "Please choose an image");
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  // Payment Failure
  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */
    showAlertDialog(context, "Payment Failed",
        "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  // Payment Success
  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */
    storeData();
    showAlertDialog(
        context, "Payment Successful", "Payment ID: ${response.paymentId}");
  }

  // External Wallet
  void handleExternalWalletSelected(ExternalWalletResponse response) {
    showAlertDialog(
        context, "External Wallet Selected", "${response.walletName}");
  }

  // Alert Dialogue
  void showAlertDialog(BuildContext context, String title, String message) {
    // set up the buttons
    Widget continueButton = Center(
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            primaryColor,
          ),
        ),
        child: title == 'Payment Successful'
            ? const Text("Continue")
            : const Text("Try Again"),
        onPressed: () {
          if (title == 'Payment Successful') {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const NavigationScreen(),
                ),
                (route) => false);
          } else {
            Navigator.pop(context);
          }
        },
      ),
    );
    // set up the AlertDialog
    Center alert = Center(
      child: AlertDialog(
        title: Text(
          title,
          textAlign: TextAlign.center,
        ),
        // content: Text(message),
        actions: [
          continueButton,
        ],
      ),
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // store vendor data to database
  void storeData() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    VendorModel vendorModel = VendorModel(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      pincode: pincodeController.text.trim(),
      service: service,
      city: city,
      // bio: bioController.text.trim(),
      profilePic: "",
      // createdAt: "",
      phoneNumber: "",
      uid: "",
      services: [],
    );
    if (image != null) {
      ap.saveVendorDataToFirebase(
        context: context,
        vendorModel: vendorModel,
        profilePic: image!,
        onSuccess: () {
          ap.saveVendorDataToSP().then(
                (value) => ap.setSignIn().then(
                      (value) => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileScreen(),
                          ),
                          (route) => false),
                    ),
              );
        },
      );
    } else {
      showSnackBar(context, "Please upload your profile photo");
    }
  }
}
