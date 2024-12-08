import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:simz_academy/views/UIHelper/home_ui_helper.dart';
import 'package:simz_academy/models/consumers/payment_history_consumer.dart';
import 'package:simz_academy/models/consumers/remaining_payment_consumer.dart';
import 'package:simz_academy/views/screens/bottom_nav.dart';

class FeeScreen extends StatelessWidget {
  const FeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: HomeUiHelper().customText('Fee Payment', 24, FontWeight.w400,
                const Color.fromRGBO(56, 15, 67, 1))),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
              return BottomNav();
            }));
          },
          icon: const Icon(
            (Iconsax.arrow_square_left),
            color: Color.fromRGBO(56, 15, 67, 1),
          ),
        ),
        actions: const [
          SizedBox(
            width: 60,
            height: 40,
            //child: Image.asset('lib/assets/images/person.png'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: const Column(
          children: [
            SizedBox(height: 280, child: RemainingPaymentConsumer()),
            Divider(
              indent: 125,
              endIndent: 125,
              thickness: 3,
              color: Color.fromRGBO(181, 95, 214, 1),
            ),
            SizedBox(
              height: double.maxFinite,
              child: PaymentHistoryConsumer(),
            )
          ],
        ),
      ),
    );
  }
}
