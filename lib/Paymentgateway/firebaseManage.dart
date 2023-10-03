import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class FirebaseManage {
  Future<void> subcriptionSuccessSave(
      {required String gSignClientId,
      required DateTime subscriptionDate,
      required String subscriptionPlanCategory,
      required DateTime subscriptionExpireDate,
      required String orderId,
      required String paymentId,
      required int price}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(gSignClientId)
        .collection('subscription')
        .doc(gSignClientId)
        .set({
      'price': price,
      'subscriptionPlanCategory': subscriptionPlanCategory,
      'subscriptionDate': subscriptionDate,
      'subscriptionExpireDate': subscriptionExpireDate,
      'paymentId': paymentId,
      'orderId': orderId,
      'subscription_id': ''
    });
  }




  //get pay here ids for recurring payments
  Future<String?> getPayHereRecurringAPPID() async {
    try {

      DocumentSnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance
          .collection('payHere')
          .doc('appID') // testAppID // liveAppID
          .get();

      if (snapshot.exists) {
        String? sAppID = snapshot.get('sAppID');

        return sAppID;
      }

    } catch (e) {
      EasyLoading.dismiss();
      return null;
    }

    return null; // Return null if the document or the nested fields do not exist
  }
// Get PayHere secret key
  Future<String?> getPayHereRecurringSKey() async {
    try {

      DocumentSnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance
          .collection('payHere')
          .doc('payhere_skey') // payhere_skey // payhere_skeyLive
          .get();

      if (snapshot.exists) {
        String? skey = snapshot.get('skey');
        print(" payhere_skeyLive = $skey" );
        return skey;
      }

    } catch (e) {
      EasyLoading.dismiss();
      return null;
    }

    return null; // Return null if the document or the nested fields do not exist
  }
}
