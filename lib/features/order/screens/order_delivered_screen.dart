import 'package:flutter/material.dart';
import 'package:jebnah_delivery/localization/language_constrants.dart';
import 'package:jebnah_delivery/utill/dimensions.dart';
import 'package:jebnah_delivery/utill/images.dart';
import 'package:jebnah_delivery/utill/styles.dart';
import 'package:jebnah_delivery/common/widgets/custom_button_widget.dart';
import 'package:jebnah_delivery/features/dashboard/screens/dashboard_screen.dart';

class OrderDeliveredScreen extends StatelessWidget {
  final String? orderID;

  const OrderDeliveredScreen({super.key, this.orderID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                Images.doneWithFullBackground,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Text(
                getTranslated('order_successfully_delivered', context),
                style: rubikRegular.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    getTranslated('order_id', context),
                    style: rubikRegular.copyWith(),
                  ),

                  Text(' #$orderID', style: rubikRegular.copyWith()),
                ],
              ),
              const SizedBox(height: 30),

              CustomButtonWidget(
                btnTxt: getTranslated('back_home', context),
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const DashboardScreen()),
                    (route) => false,
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
