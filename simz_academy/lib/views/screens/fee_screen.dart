import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:simz_academy/models/fee_model/fee_due_model.dart';
import 'package:simz_academy/views/UIHelper/home_ui_helper.dart';
import 'package:simz_academy/views/screens/bottom_nav.dart';
import 'package:simz_academy/models/fee_model/payment_history_model.dart';

class FeeScreen extends StatefulWidget {
  const FeeScreen({super.key});

  @override
  State<FeeScreen> createState() => _FeeScreenState();
}

class _FeeScreenState extends State<FeeScreen> {
  bool isLoading = true;
  final FeeDueModel _feeDueModel = FeeDueModel();
  final PaymentHistoryModel _paymentHistoryModel = PaymentHistoryModel();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    await _feeDueModel.getFeeDue();
    await _paymentHistoryModel.getPaymentHistory();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Center(
            child: HomeUiHelper().customText('Fee Payment', 24, FontWeight.w400,
                const Color.fromRGBO(56, 15, 67, 1))),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (context) {
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
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 12.0, right: 12.0),
          child: Column(
            children: [
              SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: HomeUiHelper().customText(
                  'Remaining Payments',
                  20,
                  FontWeight.w600,
                  Color.fromRGBO(56, 15, 67, 1),
                ),
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(129, 50, 153, 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: (isLoading)
                      ? HomeUiHelper().customText(
                          'Loading...',
                          32,
                          FontWeight.w700,
                          Color.fromRGBO(251, 246, 253, 1),
                        )
                      : HomeUiHelper().customText(
                          '₹ ${FeeDueModel.cachedFeeDue}',
                          32,
                          FontWeight.w700,
                          Color.fromRGBO(251, 246, 253, 1),
                        ),
                  trailing: Icon(
                    IconsaxPlusBold.money_send,
                    size: 50,
                    color: Color.fromRGBO(255, 205, 97, 1),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Divider(
                color: Color.fromRGBO(56, 15, 67, 1),
                thickness: 2,
                indent: 100,
                endIndent: 100,
              ),
              SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: HomeUiHelper().customText(
                  'Payment History',
                  20,
                  FontWeight.w600,
                  Color.fromRGBO(56, 15, 67, 1),
                ),
              ),
              SizedBox(height: 8),

              // Payment History ListView
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _paymentHistoryModel.amounts.isEmpty
                      ? Center(
                          child: Text(
                            'No payment history found',
                            style: TextStyle(
                              color: Color.fromRGBO(56, 15, 67, 1),
                              fontSize: 16,
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _paymentHistoryModel.amounts.length,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 2,
                              margin: EdgeInsets.symmetric(vertical: 4),
                              child: ListTile(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  leading: Icon(
                                    IconsaxPlusBold.wallet_1,
                                    color: Color.fromRGBO(201, 144, 20, 1),
                                    size: 40,
                                  ),
                                  tileColor: Color.fromRGBO(196, 220, 243, 1),
                                  title: SizedBox(
                                    width: 200,
                                    child: HomeUiHelper().customText(
                                      _paymentHistoryModel.courseNames[index],
                                      20,
                                      FontWeight.w600,
                                      Color(0xFF1B4771),
                                    ),
                                  ),
                                  subtitle: HomeUiHelper().customText(
                                    'Paid on ${_paymentHistoryModel.createdAtDates[index]}',
                                    15,
                                    FontWeight.w300,
                                    Color(0xFF1B4771),
                                  ),
                                  trailing: HomeUiHelper().customText(
                                    '₹${_paymentHistoryModel.amounts[index]}',
                                    32,
                                    FontWeight.w700,
                                    Color(0xFF1B4771),
                                  )),
                            );
                          },
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
