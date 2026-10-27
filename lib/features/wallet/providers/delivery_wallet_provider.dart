import 'package:flutter/material.dart';
import 'package:jebnah_delivery/common/models/api_response_model.dart';
import 'package:jebnah_delivery/features/wallet/domain/models/delivery_wallet_model.dart';
import 'package:jebnah_delivery/features/wallet/domain/reposotories/delivery_wallet_repo.dart';
import 'package:jebnah_delivery/helper/show_custom_snackbar_helper.dart';

class DeliveryWalletProvider extends ChangeNotifier {
  final DeliveryWalletRepo walletRepo;

  DeliveryWalletProvider({required this.walletRepo});

  DeliveryWalletModel? _walletModel;
  DeliveryWalletModel? get walletModel => _walletModel;

  List<CustodyTransactionModel>? _transactionList;
  List<CustodyTransactionModel>? get transactionList => _transactionList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isTransactionLoading = false;
  bool get isTransactionLoading => _isTransactionLoading;

  String _selectedFilter = 'all'; // 'all', 'cash_collection', 'custody_settlement'
  String get selectedFilter => _selectedFilter;

  int _offset = 1;
  int get offset => _offset;

  int? _totalSize;
  int? get totalSize => _totalSize;

  Future<void> getWallet({bool reload = false}) async {
    if (reload || _walletModel == null) {
      _isLoading = true;
      notifyListeners();
    }

    ApiResponseModel apiResponse = await walletRepo.getWallet();

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _walletModel = DeliveryWalletModel.fromJson(apiResponse.response!.data);
    } else {
      showCustomSnackBarHelper(apiResponse.error.toString());
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getWalletTransactions({
    required int offset,
    String? type,
    bool reload = false,
  }) async {
    if (type != null) {
      _selectedFilter = type;
    }

    if (reload) {
      _offset = 1;
      _transactionList = null;
      _isTransactionLoading = true;
      notifyListeners();
    }

    ApiResponseModel apiResponse = await walletRepo.getWalletTransactions(
      _offset,
      _selectedFilter,
    );

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _totalSize = apiResponse.response!.data['total_size'];
      final List<dynamic> list = apiResponse.response!.data['transactions'];

      if (_offset == 1) {
        _transactionList = [];
      }

      for (var element in list) {
        _transactionList!.add(CustodyTransactionModel.fromJson(element));
      }
    } else {
      showCustomSnackBarHelper(apiResponse.error.toString());
    }

    _isTransactionLoading = false;
    notifyListeners();
  }

  void setFilterType(String type) {
    if (_selectedFilter != type) {
      _selectedFilter = type;
      _offset = 1;
      getWalletTransactions(offset: 1, type: type, reload: true);
    }
  }

  void loadMoreTransactions() {
    if (_transactionList != null && _totalSize != null && _transactionList!.length < _totalSize!) {
      _offset++;
      getWalletTransactions(offset: _offset, type: _selectedFilter);
    }
  }
}
