import 'package:flutter/material.dart';
import 'package:jebnah_delivery/features/wallet/domain/models/delivery_wallet_model.dart';
import 'package:jebnah_delivery/localization/language_constrants.dart';
import 'package:jebnah_delivery/utill/dimensions.dart';
import 'package:jebnah_delivery/utill/styles.dart';

class CustodyTransactionWidget extends StatelessWidget {
  final CustodyTransactionModel transaction;

  const CustodyTransactionWidget({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final bool isCollection = transaction.transactionType == 'cash_collection';
    final double amount = transaction.amount ?? 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Circle
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isCollection
                      ? const Color(0xFF22C55E).withOpacity(0.12)
                      : const Color(0xFF3B82F6).withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCollection
                      ? Icons.arrow_downward_rounded
                      : Icons.arrow_upward_rounded,
                  color: isCollection
                      ? const Color(0xFF16A34A)
                      : const Color(0xFF2563EB),
                  size: 22,
                ),
              ),

              const SizedBox(width: Dimensions.paddingSizeDefault),

              // Transaction Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isCollection
                              ? (getTranslated('cash_collection', context))
                              : (getTranslated('custody_settlement', context)),
                          style: rubikMedium.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        // Amount
                        Text(
                          '${isCollection ? '+' : '-'} ${amount.toStringAsFixed(2)} ${getTranslated('currency', context)}',
                          style: rubikBold.copyWith(
                            fontSize: Dimensions.fontSizeLarge,
                            color: isCollection
                                ? const Color(0xFF16A34A)
                                : const Color(0xFFDC2626),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Order ID or Reference
                    if (isCollection && transaction.orderId != null) ...[
                      Row(
                        children: [
                          Icon(Icons.tag, size: 14, color: Theme.of(context).hintColor),
                          const SizedBox(width: 4),
                          Text(
                            '${getTranslated('order', context)} #${transaction.orderId}',
                            style: rubikRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ] else if (!isCollection && transaction.reference != null && transaction.reference!.isNotEmpty) ...[
                      Row(
                        children: [
                          Icon(Icons.receipt_long, size: 14, color: Theme.of(context).hintColor),
                          const SizedBox(width: 4),
                          Text(
                            '${getTranslated('reference_no', context)}: ${transaction.reference}',
                            style: rubikRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 6),

                    // Related Party (Customer name or Admin)
                    if (isCollection && transaction.customerName != null) ...[
                      Row(
                        children: [
                          Icon(Icons.person_outline, size: 14, color: Theme.of(context).hintColor),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${transaction.customerName} ${transaction.customerPhone != null && transaction.customerPhone!.isNotEmpty ? '(${transaction.customerPhone})' : ''}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: rubikRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else if (!isCollection) ...[
                      if (transaction.adminName != null && transaction.adminName!.isNotEmpty) ...[
                        Row(
                          children: [
                            Icon(Icons.badge_outlined, size: 14, color: Theme.of(context).primaryColor),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                '${getTranslated('receiving_accountant', context)}: ${transaction.adminName}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: rubikMedium.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                      ],
                      Row(
                        children: [
                          Icon(Icons.verified_user_outlined, size: 14, color: Theme.of(context).hintColor),
                          const SizedBox(width: 4),
                          Text(
                            transaction.notes ?? (getTranslated('settled_with_admin', context)),
                            style: rubikRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: Dimensions.paddingSizeSmall),
          Divider(color: Theme.of(context).dividerColor.withOpacity(0.08), height: 1),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

          // Footer Row: Date & Balance After
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDate(transaction.createdAt),
                style: rubikRegular.copyWith(
                  fontSize: Dimensions.fontSizeExtraSmall,
                  color: Theme.of(context).hintColor,
                ),
              ),
              Row(
                children: [
                  Text(
                    '${getTranslated('balance_after', context)}: ',
                    style: rubikRegular.copyWith(
                      fontSize: Dimensions.fontSizeExtraSmall,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  Text(
                    '${(transaction.balanceAfter ?? 0.0).toStringAsFixed(2)} ${getTranslated('currency', context)}',
                    style: rubikMedium.copyWith(
                      fontSize: Dimensions.fontSizeExtraSmall,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return '';
    try {
      final date = DateTime.parse(rawDate).toLocal();
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return rawDate;
    }
  }
}
