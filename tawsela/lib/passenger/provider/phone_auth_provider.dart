// import 'dart:convert';
// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../models/user_model.dart';
// import '../screens/otp_screen.dart';
// import '../utils/utils.dart';
//
// class AuthProvider extends ChangeNotifier {
//   bool _isSignedIn = false;
//   bool get isSignedIn => _isSignedIn;
//   bool _isLoading = false;
//   bool get isLoading => _isLoading;
//   String? _uid;
//   String get uid => _uid!;
//   UserModel? _userModel;
//   UserModel get userModel => _userModel!;
//
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
//   final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
//
//   AuthProvider() {
//     checkSign();
//   }
//
//   void checkSign() async {
//     final SharedPreferences s = await SharedPreferences.getInstance();
//     _isSignedIn = s.getBool("is_signedin") ?? false;
//     notifyListeners();
//   }
//
//   Future setSignIn() async {
//     final SharedPreferences s = await SharedPreferences.getInstance();
//     s.setBool("is_signedin", true);
//     _isSignedIn = true;
//     notifyListeners();
//   }
//
//   // signin
//   void signInWithPhone(BuildContext context, String phoneNumber) async {
//     try {
//       await _firebaseAuth.verifyPhoneNumber(
//           phoneNumber: phoneNumber,
//           verificationCompleted:
//               (PhoneAuthCredential phoneAuthCredential) async {
//             await _firebaseAuth.signInWithCredential(phoneAuthCredential);
//           },
//           verificationFailed: (error) {
//             throw Exception(error.message);
//           },
//           codeSent: (verificationId, forceResendingToken) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => OtpScreen(verificationId: verificationId),
//               ),
//             );
//           },
//           codeAutoRetrievalTimeout: (verificationId) {});
//     } on FirebaseAuthException catch (e) {
//       showSnackBar(context, e.message.toString());
//     }
//   }
//
//   // verify otp
//   void verifyOtp({
//     required BuildContext context,
//     required String verificationId,
//     required String userOtp,
//     required Function onSuccess,
//   }) async {
//     _isLoading = true;
//     notifyListeners();
//
//     try {
//       PhoneAuthCredential creds = AuthProvider.credential(
//           verificationId: verificationId, smsCode: userOtp);
//
//       User? user = (await _firebaseAuth.signInWithCredential(creds)).user;
//
//       if (user != null) {
//         // carry our logic
//         _uid = user.uid;
//         onSuccess();
//       }
//       _isLoading = false;
//       notifyListeners();
//     } on FirebaseAuthException catch (e) {
//       showSnackBar(context, e.message.toString());
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   // DATABASE OPERTAIONS
//   Future<bool> checkExistingUser() async {
//     DocumentSnapshot snapshot =
//         await _firebaseFirestore.collection("users").doc(_uid).get();
//     if (snapshot.exists) {
//       print("USER EXISTS");
//       return true;
//     } else {
//       print("NEW USER");
//       return false;
//     }
//   }
//
//   void saveUserDataToFirebase({
//     required BuildContext context,
//     required UserModel userModel,
//     required File profilePic,
//     required Function onSuccess,
//   }) async {
//     _isLoading = true;
//     notifyListeners();
//     try {
//       // uploading image to firebase storage.
//       await storeFileToStorage("profilePic/$_uid", profilePic).then((value) {
//         userModel.profilePic = value;
//         userModel.phone = _firebaseAuth.currentUser!.phoneNumber!;
//         userModel.id = _firebaseAuth.currentUser!.phoneNumber!;
//       });
//       _userModel = userModel;
//
//       // uploading to database
//       await _firebaseFirestore
//           .collection("users")
//           .doc(_uid)
//           .set(userModel.toMap())
//           .then((value) {
//         onSuccess();
//         _isLoading = false;
//         notifyListeners();
//       });
//     } on FirebaseAuthException catch (e) {
//       showSnackBar(context, e.message.toString());
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   Future<String> storeFileToStorage(String ref, File file) async {
//     UploadTask uploadTask = _firebaseStorage.ref().child(ref).putFile(file);
//     TaskSnapshot snapshot = await uploadTask;
//     String downloadUrl = await snapshot.ref.getDownloadURL();
//     return downloadUrl;
//   }
//
//   Future getDataFromFirestore() async {
//     await _firebaseFirestore
//         .collection("users")
//         .doc(_firebaseAuth.currentUser!.uid)
//         .get()
//         .then((DocumentSnapshot snapshot) {
//       _userModel = UserModel(
//         name: snapshot['name'],
//         email: snapshot['email'],
//         id: snapshot['id'],
//         profilePic: snapshot['profilePic'],
//         phone: snapshot['phoneNumber'],
//         address: snapshot['address'],
//         nationalid:snapshot['nationalid']
//       );
//       _uid = userModel.id;
//     });
//   }
//
//   // STORING DATA LOCALLY
//   Future saveUserDataToSP() async {
//     SharedPreferences s = await SharedPreferences.getInstance();
//     await s.setString("user_model", jsonEncode(userModel.toMap()));
//   }
//
//   Future getDataFromSP() async {
//     SharedPreferences s = await SharedPreferences.getInstance();
//     String data = s.getString("user_model") ?? '';
//     _userModel = UserModel.fromMap(jsonDecode(data));
//     _uid = _userModel!.id;
//     notifyListeners();
//   }
//
//   Future userSignOut() async {
//     SharedPreferences s = await SharedPreferences.getInstance();
//     await _firebaseAuth.signOut();
//     _isSignedIn = false;
//     notifyListeners();
//     s.clear();
//   }
// }
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import '../screens/otp_screen.dart';
import '../utils/utils.dart';

class AuthProvide extends ChangeNotifier {
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _uid;
  String get uid => _uid!;
  UserModel? _userModel;
  UserModel get userModel => _userModel!;

  // User currentUser;
  // UserModel? userModelCurrentInfo;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  AuthProvide() {
    checkSign();
  }

  void checkSign() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("is_signedin") ?? false;
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool("is_signedin", true);
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
    required String userOtp,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOtp);

      User? user = (await _firebaseAuth.signInWithCredential(creds)).user;

      if (user != null) {
        // carry our logic
        _uid = user.uid;
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
  Future<bool> checkExistingUser() async {
    DocumentSnapshot snapshot =
    await _firebaseFirestore.collection("users").doc(_uid).get();
    if (snapshot.exists) {
      print("USER EXISTS");
      return true;
    } else {
      print("NEW USER");
      return false;
    }
  }

  void saveUserDataToFirebase({
    required BuildContext context,
    required UserModel userModel,
    required File profilePic,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      // uploading image to firebase storage.
      await storeFileToStorage("profilePic/$_uid", profilePic).then((value) {
        userModel.profilePic = value;
        userModel.phone = _firebaseAuth.currentUser!.phoneNumber!;
        userModel.id = _firebaseAuth.currentUser!.uid;
      });
      _userModel = userModel;

      // uploading to database
      await _firebaseFirestore
          .collection("users")
          .doc(_uid)
          .set(userModel.toMap())
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
        .collection("users")
        .doc(_firebaseAuth.currentUser!.uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      _userModel = UserModel(
        firstname: snapshot['firstname'],
        secondname: snapshot['secondname'],
        email: snapshot['email'],
        nationalid: snapshot['nationalid'],
        profilePic: snapshot['profilePic'],
        phone: snapshot['phone'],
        id: snapshot['id'] ,
        address: snapshot['address'],
        rid: snapshot['rid'],
        rVehicleType: snapshot['rVehicleType'],
        password: snapshot["password"],
        gender: snapshot["gender"]
      );
      _uid = userModel.id;
    });
  }

  // STORING DATA LOCALLY
  Future saveUserDataToSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await s.setString("user_model", jsonEncode(userModel.toMap()));
  }

  Future getDataFromSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    String data = s.getString("user_model") ?? '';
    _userModel = UserModel.fromMap(jsonDecode(data));
    _uid = _userModel!.id;
    notifyListeners();
  }

  Future userSignOut() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await _firebaseAuth.signOut();
    _isSignedIn = false;
    notifyListeners();
    s.clear();
  }
}
