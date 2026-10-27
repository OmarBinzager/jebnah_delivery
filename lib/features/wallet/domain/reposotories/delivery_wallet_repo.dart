import 'package:jebnah_delivery/data/datasource/remote/dio/dio_client.dart';
import 'package:jebnah_delivery/data/datasource/remote/exception/api_error_handler.dart';
import 'package:jebnah_delivery/common/models/api_response_model.dart';
import 'package:jebnah_delivery/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeliveryWalletRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  DeliveryWalletRepo({
    required this.dioClient,
    required this.sharedPreferences,
  });

  Future<ApiResponseModel> getWallet() async {
    try {
      final token = sharedPreferences!.getString(AppConstants.token);
      final response = await dioClient!.get('${AppConstants.deliveryWalletUri}$token');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getWalletTransactions(int offset, String type) async {
    try {
      final token = sharedPreferences!.getString(AppConstants.token);
      final response = await dioClient!.get(
        '${AppConstants.deliveryWalletTransactionsUri}$token&offset=$offset&limit=10&type=$type',
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
