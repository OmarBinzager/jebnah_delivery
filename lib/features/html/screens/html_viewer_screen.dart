import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:jebnah_delivery/common/models/config_model.dart';
import 'package:jebnah_delivery/common/widgets/custom_image_widget.dart';
import 'package:jebnah_delivery/localization/language_constrants.dart';
import 'package:jebnah_delivery/features/splash/providers/splash_provider.dart';
import 'package:jebnah_delivery/utill/dimensions.dart';
import 'package:jebnah_delivery/common/widgets/custom_app_bar_widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HtmlViewerScreen extends StatelessWidget {
  final bool isPrivacyPolicy;
  const HtmlViewerScreen({super.key, required this.isPrivacyPolicy});

  @override
  Widget build(BuildContext context) {
    final ConfigModel? configModel = Provider.of<SplashProvider>(
      context,
      listen: false,
    ).configModel;

    String data = 'no_result_found';
    String imageUrl = '';
    if (isPrivacyPolicy) {
      data = configModel?.privacyPolicy?.description ?? '';
      imageUrl = configModel?.privacyPolicy?.backgroundImageUrl ?? '';
    } else {
      data = configModel?.termsAndConditions?.description ?? '';
      imageUrl = configModel?.termsAndConditions?.backgroundImageUrl ?? '';
    }

    return Scaffold(
      appBar: CustomAppBarWidget(
        title: getTranslated(
          isPrivacyPolicy ? 'privacy_policy' : 'terms_and_condition',
          context,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              width: 1000,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  Dimensions.paddingSizeSmall,
                ),
                child: CustomImageWidget(image: imageUrl),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            HtmlWidget(
              data,
              key: Key(data.toString()),
              onTapUrl: (String url) {
                return launchUrlString(
                  url,
                  mode: LaunchMode.externalApplication,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
