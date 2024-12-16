import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:simz_academy/views/UIHelper/home_ui_helper.dart';
import 'package:simz_academy/models/providers/remaining_payments.dart';

class RemainingPaymentConsumer extends ConsumerWidget {
  const RemainingPaymentConsumer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feeAsyncValue = ref.watch(feeProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: HomeUiHelper().customText(
          'Remaining Payments',
          20,
          FontWeight.w600,
          Color.fromRGBO(56, 15, 67, 1),
        ),
      ),
      body: Center(
        child: feeAsyncValue.when(
          data: (fees) {
            if (fees.isEmpty) {
              return Text(
                "No fee due",
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromRGBO(56, 15, 67, 1),
                ),
              );
            }

            // Assuming we want to show the first (and only) fee
            final fee = fees.first;

            return Padding(
              padding: const EdgeInsets.only(
                  top: 4.0,
                  bottom: 4.0,
                  left: 12,
                  right: 12
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(129, 50, 153, 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: HomeUiHelper().customText(
                      '₹ $fee',
                      32,
                      FontWeight.w700,
                      Color.fromRGBO(251, 246, 253, 1)
                  ),
                  trailing: Icon(
                    IconsaxPlusBold.money_send,
                    size: 50,
                    color: Color.fromRGBO(255, 205, 97, 1),
                  ),
                ),
              ),
            );
          },
          loading: () => CircularProgressIndicator(),
          error: (error, stack) => Text('Error: $error'),
        ),
      ),
    );
  }
}