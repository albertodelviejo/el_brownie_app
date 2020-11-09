import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_brownie_app/ui/utils/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:stripe_payment/stripe_payment.dart';

class StripeTransaction {
  String message;
  bool success;
  String paymentId;
  StripeTransaction({this.message, this.success, this.paymentId});
}

class StripeService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  static String apiBase = 'https://api.stripe.com/v1';
  static String paymentApiUrl = '${StripeService.apiBase}/payment_intents';
  static String _secret =
      'sk_test_51HUbVjAVe6Y71mtiopEpVNo8VX8jteZFpIn3yxJRNqHWWmGke1EwyQ6Dv7cgJ05gqdmnbsuK5d6UlzCctzxIyvHp00UIHeVkwh';
  static String getSecretKey() {
    return _secret;
  }

  static Map<String, String> headers = {
    'Authorization': 'Bearer ${StripeService.getSecretKey()}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };
  static init() {
    StripePayment.setOptions(StripeOptions(
        publishableKey:
            "pk_test_51HUbVjAVe6Y71mtiMXyUuV8ESXwOuw8rmLDI1o9jhjkB9JsTmO3DTyyGvXBxTjoptCsYeat4rh1NVj0sb0B3TklJ00BTctjATw",
        merchantId: "Test",
        androidPayMode: 'test'));
  }

  static Future<StripeTransaction> payWithNewCard(
      {String amount, String currency}) async {
    try {
      var paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest());
      var paymentIntent =
          await StripeService.createPaymentIntent(amount, currency);
      var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
          clientSecret: paymentIntent['client_secret'],
          paymentMethodId: paymentMethod.id));
      if (response.status == 'succeeded') {
        return new StripeTransaction(
            message: 'Transaction successful',
            success: true,
            paymentId: response.paymentIntentId);
      } else {
        return new StripeTransaction(
          message: 'Transaction failed',
          success: false,
        );
      }
    } on PlatformException catch (err) {
      return StripeService.getPlatformExceptionErrorResult(err);
    } catch (err) {
      String error = 'Transaction failed: ${err.toString()}';
      return new StripeTransaction(message: error, success: false);
    }
  }

  static getPlatformExceptionErrorResult(err) {
    String message = 'Something went wrong';
    if (err.code == 'cancelled') {
      message = 'Transaction cancelled';
    }

    return new StripeTransaction(message: message, success: false);
  }

  static Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(StripeService.paymentApiUrl,
          body: body, headers: StripeService.headers);
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
      return null;
    }
  }

  Future<void> createClaim(String amount, String idPost, String cif, String reason,
      String paymentMethod, String paymentIntentId) async {
    var postQuery = await _firestore
        .collection('posts')
        .where('id_post', isEqualTo: idPost)
        .get();
    await _firestore.collection('claims').add({
      'id_payer': _auth.currentUser.uid,
      'id_poster': postQuery.docs[0].data()['id_user'],
      'id_payment': paymentIntentId,
      'id_post': idPost,
      'price': amount,
      'reason': reason,
      'status': 'requested',
      'paymentMethod': paymentMethod,
      'paid_at': DateFormat('dd-MM-yyyy').format(DateTime.now()),
    });
<<<<<<< HEAD

    if (reason == 'owner') {
=======
    if (reason == claim_opt_1) {
>>>>>>> 7b0b8441707ee0776bc85c709b935dba7c37c2ee
      DocumentReference ownerQuery =
          _firestore.collection('users').doc(_auth.currentUser.uid);
      ownerQuery.get().then((value) async {
        await ownerQuery.update({'type': 'owner', 'cif': cif});
      });
    }
  }
}
