import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jebnah_delivery/features/splash/providers/splash_provider.dart';

class PriceConverterHelper {
  static String convertPrice(
    BuildContext context,
    double? price, {
    String? discount,
    String? discountType,
  }) {
    if (price == null) return '';

    if (discount != null && discountType != null) {
      if (discountType == 'amount') {
        price = price - double.parse(discount);
      } else if (discountType == 'percent') {
        price = price - ((double.parse(discount) / 100) * price);
      }
    }

    final config = Provider.of<SplashProvider>(context, listen: false).configModel;
    String symbol = config?.currencySymbol ?? '﷼';
    symbol = symbol.replaceAll(RegExp(r'[\u200E\u200F\u202A-\u202E]'), '').trim();

    String symbolPosition = (config?.currencySymbolPosition != null && config!.currencySymbolPosition!.trim().isNotEmpty)
        ? config.currencySymbolPosition!.trim().toLowerCase()
        : 'right';
    bool isLeft = symbolPosition == 'left';
    int decimalDigits = config?.decimalPointSettings ?? 2;

    String formattedNumber = price
        .toStringAsFixed(decimalDigits)
        .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');

    return isLeft ? '$symbol $formattedNumber' : '$formattedNumber $symbol';
  }

  static double convertWithDiscount(
    BuildContext context,
    double price,
    String discount,
    String discountType,
  ) {
    if (discountType == 'amount') {
      price = price - double.parse(discount);
    } else if (discountType == 'percent') {
      price = price - ((double.parse(discount) / 100) * price);
    }
    return price;
  }

  static double calculation(
    double amount,
    double discount,
    String type,
    int quantity,
  ) {
    double calculatedAmount = 0;
    if (type == 'amount') {
      calculatedAmount = discount * quantity;
    } else if (type == 'percent') {
      calculatedAmount = (discount / 100) * (amount * quantity);
    }
    return calculatedAmount;
  }

  static String percentageCalculation(
    BuildContext context,
    String price,
    String discount,
    String discountType,
  ) {
    return '$discount${discountType == 'percent' ? '%' : Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol} OFF';
  }
}
