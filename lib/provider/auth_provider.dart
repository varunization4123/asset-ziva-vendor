import 'dart:convert';
import 'dart:io';

import 'package:asset_ziva_vendor/model/vendor_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:asset_ziva_vendor/screens/otp_screen.dart';
import 'package:asset_ziva_vendor/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _uid;
  String get uid => _uid!;
  VendorModel? _vendorModel;
  VendorModel get vendorModel => _vendorModel!;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  AuthProvider() {
    checkSignIn();
  }

  void checkSignIn() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    _isSignedIn = sharedPreferences.getBool("is_signedin") ?? false;
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setBool("is_signedin", true);
    _isSignedIn = true;
    notifyListeners();
  }

  // signin
  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            await _firebaseAuth.signInWithCredential(phoneAuthCredential);
          },
          verificationFailed: (error) {
            throw Exception(error.message);
          },
          codeSent: (verificationId, forceResendingToken) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpScreen(verificationId: verificationId),
              ),
            );
          },
          codeAutoRetrievalTimeout: (verificationId) {});
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
    }
  }

  // verify otp
  void verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String vendorOtp,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: vendorOtp);

      User? vendor = (await _firebaseAuth.signInWithCredential(creds)).user;

      if (vendor != null) {
        // carry our logic
        _uid = vendor.uid;
        onSuccess();
      }
      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  // DATABASE OPERTAIONS
  Future<bool> checkExistingVendor() async {
    DocumentSnapshot snapshot =
        await _firebaseFirestore.collection("vendors").doc(_uid).get();
    if (snapshot.exists) {
      print("VENDOR EXISTS");
      return true;
    } else {
      print("NEW VENDOR");
      return false;
    }
  }

  void saveVendorDataToFirebase({
    required BuildContext context,
    required VendorModel vendorModel,
    required File profilePic,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      // uploading image to firebase storage.
      await storeFileToStorage("profilePic/$_uid", profilePic).then((value) {
        vendorModel.profilePic = value;
        // vendorModel.createdAt = DateTime.now().millisecondsSinceEpoch.toString();
        vendorModel.phoneNumber = _firebaseAuth.currentUser!.phoneNumber!;
        vendorModel.uid = _firebaseAuth.currentUser!.phoneNumber!;
      });
      _vendorModel = vendorModel;

      // uploading to database
      await _firebaseFirestore
          .collection("vendors")
          .doc(_uid)
          .set(vendorModel.toMap())
          .then((value) {
        onSuccess();
        _isLoading = false;
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> storeFileToStorage(String ref, File file) async {
    UploadTask uploadTask = _firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future getDataFromFirestore() async {
    await _firebaseFirestore
        .collection("vendors")
        .doc(_firebaseAuth.currentUser!.uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      _vendorModel = VendorModel(
        name: snapshot['name'],
        email: snapshot['email'],
        // createdAt: snapshot['createdAt'],
        // bio: snapshot['bio'],
        uid: snapshot['uid'],
        profilePic: snapshot['profilePic'],
        phoneNumber: snapshot['phoneNumber'],
        pincode: snapshot['pincode'],
        service: snapshot['service'],
        city: snapshot['city'],
        services: snapshot['services'],
      );
      _uid = vendorModel.uid;
      print(_uid);
    });
  }

  // DATABASE OPERTAIONS (Property Service)

  Future<String> storeDocumentToStorage(String ref, File file) async {
    UploadTask uploadTask = _firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  // STORING DATA LOCALLY
  Future saveVendorDataToSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await s.setString("vendor_model", jsonEncode(vendorModel.toMap()));
  }

  Future getDataFromSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    String data = s.getString("vendor_model") ?? '';
    _vendorModel = VendorModel.fromMap(jsonDecode(data));
    _uid = _vendorModel!.uid;
    notifyListeners();
  }

  Future vendorSignOut() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await _firebaseAuth.signOut();
    _isSignedIn = false;
    notifyListeners();
    s.clear();
  }
}
