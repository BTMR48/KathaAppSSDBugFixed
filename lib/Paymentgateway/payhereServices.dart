import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:katha/Paymentgateway/subscriptionPlanScreen.dart';

import 'package:payhere_mobilesdk_flutter/payhere_mobilesdk_flutter.dart';


import '../Screens/ScreenTest/HomeScreen.dart';
import 'firebaseManage.dart';

class SubscriptionPayment {

  void premiumPetPurchasePayment({


    required String country,
    required String skey,

    required String sAppID,
    required String gSignClientId,
    required String phone,
    required String email,
    required String name,
    required DateTime subscriptionDate,
    required String subscriptionPlanCategory,
    required DateTime subscriptionExpireDate,

    required String recurrence,
    required String duration,
    required int price, required mainContext,
  }) async {
    // Generating an order ID kathaapp.tbmr@gmail.com
    final orderId = 'kathaApp${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}';
    // 4916217501611292
    // Creating a payment object
    Map paymentObject = {
      "sandbox": true,                 // true if using Sandbox Merchant ID
      "merchant_id": "1223095",        // Replace your Merchant ID
      "merchant_secret": "MzM2NTk5NjI4NDM4NDk1MDQ5MzYxNjIxMTg0MTAzMjEyMjc4MjE0OQ==",        // See step 4e
      "notify_url": "",//
      "order_id": orderId,      //payment no
      "items": subscriptionPlanCategory, //package number //plan
      "amount": price,               // Recurring amount
      "recurrence": recurrence,         // Recurring payment frequency
      "duration": duration,            // Recurring payment duration
      "startup_fee": "0.00",          // Extra amount for first payment
      "currency": "LKR",
      "first_name": ' ',
      "last_name": '',
      "email": email,
      "phone": "",
      "address": "",
      "city": "",
      "country": country,
      "delivery_address": "",
      "delivery_city": "",
      "delivery_country": country,
      "custom_1": gSignClientId,
      "custom_2": ""
    };

    // Initiating the payment process
    PayHere.startPayment(paymentObject, (paymentId) async {
      EasyLoading.showToast(
          "Payment Success! Payment Id: $paymentId\nOrder Id: $orderId  ",
          toastPosition: EasyLoadingToastPosition.bottom);

      // Updating premium status in Firebase and restarting the app
      await FirebaseManage().subcriptionSuccessSave(gSignClientId:gSignClientId,subscriptionDate:subscriptionDate,subscriptionPlanCategory:subscriptionPlanCategory,subscriptionExpireDate:subscriptionExpireDate, orderId: orderId, paymentId: paymentId,price:price).then((value) {


        });

      navigate(mainContext);



      // // You can delay the navigation if you wish



    }, (error) {
      EasyLoading.showToast("Payment Failed",
          toastPosition: EasyLoadingToastPosition.bottom);
    }, () {
      EasyLoading.showToast("Payment Dismissed",
          toastPosition: EasyLoadingToastPosition.bottom);
    });

  }

  void navigate(BuildContext context) {
    Navigator.popUntil(
      context,
          (route) =>
      route is MaterialPageRoute && route.builder(context) is SubscriptionPlansScreen,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => HomeScreen(

        ),
      ),
    );
  }


}