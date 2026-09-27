import 'package:flutter/material.dart';
import 'package:jebnah_delivery/common/models/api_response_model.dart';
import 'package:jebnah_delivery/features/profile/domain/models/userinfo_model.dart';
import 'package:jebnah_delivery/features/profile/domain/reposotories/profile_repo.dart';
import 'package:jebnah_delivery/helper/api_checker_helper.dart';

class ProfileProvider with ChangeNotifier {
  final ProfileRepo profileRepo;

  ProfileProvider({required this.profileRepo});

  UserInfoModel? _userInfoModel;

  UserInfoModel? get userInfoModel => _userInfoModel;

  Future<void> getUserInfo(BuildContext context) async {
    ApiResponseModel apiResponse = await profileRepo.getUserInfo();
    if (apiResponse.response?.statusCode == 200) {
      _userInfoModel = UserInfoModel.fromJson(apiResponse.response?.data);
    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }
    notifyListeners();
  }
}
