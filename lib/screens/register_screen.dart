import 'package:asset_ziva_vendor/provider/auth_provider.dart';
import 'package:asset_ziva_vendor/utils/colors.dart';
import 'package:asset_ziva_vendor/utils/constants.dart';
import 'package:asset_ziva_vendor/utils/utils.dart';
import 'package:asset_ziva_vendor/widgets/custom_button.dart';
import 'package:asset_ziva_vendor/widgets/login_button.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController phoneController = TextEditingController();
  bool errorText = true;
  String verifyNumber = 'invalid mobile number';
  bool isLoading = false;

  Country selectedCountry = Country(
    phoneCode: "91",
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: "India",
    displayName: "India",
    displayNameNoCountryCode: "IN",
    e164Key: "",
  );

  @override
  Widget build(BuildContext context) {
    phoneController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: phoneController.text.length,
      ),
    );
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: margin, horizontal: margin),
            child: Column(
              children: [
                // Container(
                //   width: 200,
                //   height: 200,
                //   padding: const EdgeInsets.all(margin),
                //   decoration: BoxDecoration(
                //     shape: BoxShape.circle,
                //     color: Colors.purple.shade50,
                //   ),
                //   child: Image.asset(
                //     "assets/image2.png",
                //   ),
                // ),
                // const SizedBox(height: 20),
                const Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: spacing),
                const Text(
                  "Add your phone number. We'll send you a verification code",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black38,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: gap),
                TextFormField(
                  cursorColor: primaryColor,
                  controller: phoneController,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  onChanged: (value) {
                    setState(() {
                      phoneController.text = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Enter phone number",
                    hintStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: placeholderText,
                      color: placeholderColor,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: borderColor),
                    ),
                    prefixIcon: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 12.0,
                      ),
                      child: InkWell(
                        onTap: () {
                          showCountryPicker(
                              context: context,
                              countryListTheme: CountryListThemeData(
                                borderRadius: BorderRadius.circular(10),
                                bottomSheetHeight: 400,
                              ),
                              onSelect: (value) {
                                setState(() {
                                  selectedCountry = value;
                                });
                              });
                        },
                        child: Text(
                          "${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}",
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    suffixIcon: phoneController.text.length > 9
                        ? Container(
                            height: 30,
                            width: 30,
                            margin: const EdgeInsets.all(10.0),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                            ),
                            child: const Icon(
                              Icons.done,
                              color: Colors.white,
                              size: 20,
                            ),
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: gap),
                Container(
                  child: phoneController.text.length <= 9
                      ? const Text(
                          'Invalid Mobile Number',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        )
                      : null,
                ),
                const SizedBox(height: gap),
                SizedBox(
                  width: double.infinity,
                  height: btnHeight,
                  child: LoginButton(
                    widget: isLoading == true
                        ? const SizedBox(
                            height: gap,
                            width: gap,
                            child: CircularProgressIndicator(color: whiteColor),
                          )
                        : const Text("Login", style: TextStyle(fontSize: 16)),
                    onPressed: () {
                      try {
                        setState(() {
                          isLoading = true;
                        });
                        sendPhoneNumber();
                      } catch (e) {
                        print(e);
                        showSnackBar(context, '$e');
                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
                    // onPressed: () {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => const HomeScreen(),
                    //     ),
                    //   );
                    // },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void sendPhoneNumber() {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    String phoneNumber = phoneController.text.trim();
    ap.signInWithPhone(context, "+${selectedCountry.phoneCode}$phoneNumber");
  }
}
