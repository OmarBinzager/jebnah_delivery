import 'package:flutter/material.dart';
import 'package:jebnah_delivery/features/wallet/domain/models/delivery_wallet_model.dart';
import 'package:jebnah_delivery/localization/language_constrants.dart';
import 'package:jebnah_delivery/utill/dimensions.dart';
import 'package:jebnah_delivery/utill/styles.dart';

class CustodyCardWidget extends StatelessWidget {
  final DeliveryWalletModel wallet;

  const CustodyCardWidget({super.key, required this.wallet});

  @override
  Widget build(BuildContext context) {
    final double cashInHand = wallet.cashInHand ?? 0.0;
    final double totalCollected = wallet.totalCollectedCash ?? 0.0;
    final double totalSettled = wallet.totalSettledAmount ?? 0.0;
    final int ordersCount = wallet.collectedOrdersCount ?? 0;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
              : [Theme.of(context).primaryColor, const Color(0xFF0A2568)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.25),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Title & Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),
                  Text(
                    getTranslated('cash_in_hand_title', context),
                    style: rubikMedium.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: Dimensions.fontSizeDefault,
                    ),
                  ),
                ],
              ),
              _buildStatusBadge(context, cashInHand, totalSettled),
            ],
          ),

          const SizedBox(height: Dimensions.paddingSizeDefault),

          // Main Big Amount
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                cashInHand.toStringAsFixed(2),
                style: rubikBold.copyWith(
                  color: Colors.white,
                  fontSize: 32,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                getTranslated('currency', context),
                style: rubikMedium.copyWith(
                  color: Colors.white.withOpacity(0.85),
                  fontSize: Dimensions.fontSizeLarge,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),
          Text(
            getTranslated('cash_in_hand_hint', context),
            style: rubikRegular.copyWith(
              color: Colors.white.withOpacity(0.7),
              fontSize: Dimensions.fontSizeSmall,
            ),
          ),

          const SizedBox(height: Dimensions.paddingSizeLarge),
          Divider(color: Colors.white.withOpacity(0.15), height: 1),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          // Sub-metrics row
          Row(
            children: [
              Expanded(
                child: _buildMetricItem(
                  context,
                  title: getTranslated('total_collected', context),
                  value: totalCollected.toStringAsFixed(2),
                  icon: Icons.trending_up,
                  color: const Color(0xFF4ADE80),
                ),
              ),
              Container(
                height: 35,
                width: 1,
                color: Colors.white.withOpacity(0.15),
              ),
              Expanded(
                child: _buildMetricItem(
                  context,
                  title: getTranslated('total_settled', context),
                  value: totalSettled.toStringAsFixed(2),
                  icon: Icons.check_circle_outline,
                  color: const Color(0xFF60A5FA),
                ),
              ),
              Container(
                height: 35,
                width: 1,
                color: Colors.white.withOpacity(0.15),
              ),
              Expanded(
                child: _buildMetricItem(
                  context,
                  title: getTranslated('cash_orders_count', context),
                  value: ordersCount.toString(),
                  icon: Icons.inventory_2_outlined,
                  color: const Color(0xFFFBBF24),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, double cashInHand, double totalSettled) {
    String text;
    Color bgColor;
    Color textColor;

    if (cashInHand <= 0) {
      text = getTranslated('settled_status', context);
      bgColor = const Color(0xFF22C55E).withOpacity(0.2);
      textColor = const Color(0xFF4ADE80);
    } else if (totalSettled > 0 && cashInHand > 0) {
      text = getTranslated('partially_settled_status', context);
      bgColor = const Color(0xFFF59E0B).withOpacity(0.2);
      textColor = const Color(0xFFFBBF24);
    } else {
      text = getTranslated('pending_custody_status', context);
      bgColor = const Color(0xFFEF4444).withOpacity(0.2);
      textColor = const Color(0xFFF87171);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: textColor.withOpacity(0.4), width: 1),
      ),
      child: Text(
        text,
        style: rubikMedium.copyWith(
          color: textColor,
          fontSize: Dimensions.fontSizeExtraSmall,
        ),
      ),
    );
  }

  Widget _buildMetricItem(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: rubikRegular.copyWith(
                  color: Colors.white.withOpacity(0.75),
                  fontSize: Dimensions.fontSizeExtraSmall,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: rubikSemiBold.copyWith(
            color: Colors.white,
            fontSize: Dimensions.fontSizeDefault,
          ),
        ),
      ],
    );
  }
}
