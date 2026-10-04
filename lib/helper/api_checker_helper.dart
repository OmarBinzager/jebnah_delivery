import 'package:flutter/material.dart';
import 'package:jebnah_delivery/common/models/error_response_model.dart';
import 'package:jebnah_delivery/localization/language_constrants.dart';
import 'package:jebnah_delivery/main.dart';
import 'package:provider/provider.dart';
import 'package:jebnah_delivery/common/models/api_response_model.dart';
import 'package:jebnah_delivery/features/splash/providers/splash_provider.dart';
import 'package:jebnah_delivery/features/auth/screens/login_screen.dart';

class ApiCheckerHelper {
  static void checkApi(ApiResponseModel apiResponse) {
    ErrorResponseModel error = getError(apiResponse);

    if (error.errors != null &&
        error.errors!.isNotEmpty &&
        (error.errors![0].code == '401' || error.errors![0].code == 'auth-001')) {
      Provider.of<SplashProvider>(
        Get.context!,
        listen: false,
      ).removeSharedData();
      Navigator.pushAndRemoveUntil(
        Get.context!,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } else {
      String? errorMessage;
      if (error.errors != null && error.errors!.isNotEmpty) {
        errorMessage = error.errors![0].message;
      }
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage ?? getTranslated('not_found', Get.context!),
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  static ErrorResponseModel getError(ApiResponseModel apiResponse) {
    ErrorResponseModel error;

    try {
      if (apiResponse.response != null && apiResponse.response?.data != null) {
        error = ErrorResponseModel.fromJson(apiResponse.response?.data);
      } else if (apiResponse.error != null) {
        error = ErrorResponseModel.fromJson(apiResponse.error);
      } else {
        error = ErrorResponseModel(
          errors: [Errors(code: '', message: 'something_went_wrong')],
        );
      }
    } catch (e) {
      error = ErrorResponseModel(
        errors: [
          Errors(
            code: '',
            message: apiResponse.error?.toString() ?? 'something_went_wrong',
          ),
        ],
      );
    }

    if (error.errors == null || error.errors!.isEmpty) {
      error = ErrorResponseModel(
        errors: [
          Errors(
            code: '',
            message: apiResponse.error?.toString() ?? 'something_went_wrong',
          ),
        ],
      );
    }

    return error;
  }
}
