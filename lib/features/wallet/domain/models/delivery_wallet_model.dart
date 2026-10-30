class DeliveryWalletModel {
  double? cashInHand;
  double? totalCollectedCash;
  double? totalSettledAmount;
  int? collectedOrdersCount;
  String? settlementStatus;
  String? lastSettlementAt;
  List<CustodyTransactionModel>? recentTransactions;

  DeliveryWalletModel({
    this.cashInHand,
    this.totalCollectedCash,
    this.totalSettledAmount,
    this.collectedOrdersCount,
    this.settlementStatus,
    this.lastSettlementAt,
    this.recentTransactions,
  });

  DeliveryWalletModel.fromJson(Map<String, dynamic> json) {
    cashInHand = (json['cash_in_hand'] != null)
        ? double.tryParse(json['cash_in_hand'].toString()) ?? 0.0
        : 0.0;
    totalCollectedCash = (json['total_collected_cash'] != null)
        ? double.tryParse(json['total_collected_cash'].toString()) ?? 0.0
        : 0.0;
    totalSettledAmount = (json['total_settled_amount'] != null)
        ? double.tryParse(json['total_settled_amount'].toString()) ?? 0.0
        : 0.0;
    collectedOrdersCount = (json['collected_orders_count'] != null)
        ? int.tryParse(json['collected_orders_count'].toString()) ?? 0
        : 0;
    settlementStatus = json['settlement_status'];
    lastSettlementAt = json['last_settlement_at'];

    if (json['recent_transactions'] != null) {
      recentTransactions = <CustodyTransactionModel>[];
      json['recent_transactions'].forEach((v) {
        recentTransactions!.add(CustodyTransactionModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cash_in_hand'] = cashInHand;
    data['total_collected_cash'] = totalCollectedCash;
    data['total_settled_amount'] = totalSettledAmount;
    data['collected_orders_count'] = collectedOrdersCount;
    data['settlement_status'] = settlementStatus;
    data['last_settlement_at'] = lastSettlementAt;
    if (recentTransactions != null) {
      data['recent_transactions'] =
          recentTransactions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustodyTransactionModel {
  int? id;
  String? transactionId;
  int? deliveryManId;
  String? transactionType; // 'cash_collection' or 'custody_settlement'
  int? orderId;
  double? amount;
  double? balanceBefore;
  double? balanceAfter;
  int? customerId;
  String? customerName;
  String? customerPhone;
  String? settlementType;
  String? paymentMethod;
  String? reference;
  String? notes;
  String? adminName;
  String? createdAt;
  String? updatedAt;

  CustodyTransactionModel({
    this.id,
    this.transactionId,
    this.deliveryManId,
    this.transactionType,
    this.orderId,
    this.amount,
    this.balanceBefore,
    this.balanceAfter,
    this.customerId,
    this.customerName,
    this.customerPhone,
    this.settlementType,
    this.paymentMethod,
    this.reference,
    this.notes,
    this.adminName,
    this.createdAt,
    this.updatedAt,
  });

  CustodyTransactionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    transactionId = json['transaction_id'];
    deliveryManId = json['delivery_man_id'];
    transactionType = json['transaction_type'];
    orderId = json['order_id'];
    amount = (json['amount'] != null)
        ? double.tryParse(json['amount'].toString()) ?? 0.0
        : 0.0;
    balanceBefore = (json['balance_before'] != null)
        ? double.tryParse(json['balance_before'].toString()) ?? 0.0
        : 0.0;
    balanceAfter = (json['balance_after'] != null)
        ? double.tryParse(json['balance_after'].toString()) ?? 0.0
        : 0.0;
    customerId = json['customer_id'];
    customerName = json['customer_name'];
    customerPhone = json['customer_phone'];
    settlementType = json['settlement_type'];
    paymentMethod = json['payment_method'];
    reference = json['reference'];
    notes = json['notes'];
    adminName = json['admin_name'] ?? (json['admin'] != null ? '${json['admin']['f_name'] ?? ''} ${json['admin']['l_name'] ?? ''}'.trim() : null);
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['transaction_id'] = transactionId;
    data['delivery_man_id'] = deliveryManId;
    data['transaction_type'] = transactionType;
    data['order_id'] = orderId;
    data['amount'] = amount;
    data['balance_before'] = balanceBefore;
    data['balance_after'] = balanceAfter;
    data['customer_id'] = customerId;
    data['customer_name'] = customerName;
    data['customer_phone'] = customerPhone;
    data['settlement_type'] = settlementType;
    data['payment_method'] = paymentMethod;
    data['reference'] = reference;
    data['notes'] = notes;
    data['admin_name'] = adminName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
