import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:jebnah_delivery/common/widgets/custom_button_widget.dart';
import 'package:jebnah_delivery/common/widgets/custom_text_field_widget.dart';
import 'package:jebnah_delivery/features/auth/providers/auth_provider.dart';
import 'package:jebnah_delivery/features/auth/screens/delivery_man_registration_screen.dart';
import 'package:jebnah_delivery/features/auth/widgets/remember_widget.dart';
import 'package:jebnah_delivery/features/dashboard/screens/dashboard_screen.dart';
import 'package:jebnah_delivery/features/splash/providers/splash_provider.dart';
import 'package:jebnah_delivery/helper/email_checker_helper.dart';
import 'package:jebnah_delivery/helper/show_custom_snackbar_helper.dart';
import 'package:jebnah_delivery/localization/language_constrants.dart';
import 'package:jebnah_delivery/utill/dimensions.dart';
import 'package:jebnah_delivery/utill/images.dart';
import 'package:jebnah_delivery/utill/styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final GlobalKey<FormState> _formKeyLogin;

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _formKeyLogin = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    // جلب البيانات المسجلة مسبقاً بطريقة آمنة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      _emailController.text = authProvider.getUserEmail();
      _passwordController.text = authProvider.getUserPassword();
    });

    _requestNotificationPermission();

    // تثبيت الاتجاه الرأسي للشاشة (أفضل لتطبيقات التوصيل أثناء القيادة)
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(
            context,
          ).unfocus(), // إغلاق لوحة المفاتيح عند النقر خارج الحقول
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeLarge,
              vertical: Dimensions.paddingSizeDefault,
            ),
            child: Consumer<AuthProvider>(
              builder: (context, authProvider, child) => Form(
                key: _formKeyLogin,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    // ================= 1. قسم الشعار والهوية =================
                    Center(child: _buildHeaderLogo(primaryColor)),

                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                    // ================= 2. النصوص الترحيبية =================
                    _buildWelcomeHeader(),

                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    // ================= 3. حقل البريد الإلكتروني =================
                    _buildLabel(getTranslated('email', context)),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    CustomTextFieldWidget(
                      hintText: getTranslated('demo_gmail', context),
                      isShowBorder: true,
                      focusNode: _emailFocus,
                      nextFocus: _passwordFocus,
                      controller: _emailController,
                      inputType: TextInputType.emailAddress,
                      prefixIconUrl: Images.emailIcon,
                      borderRadius: Dimensions.paddingSizeSmall,
                      isShowPrefixIcon: true,
                      inputAction: TextInputAction.next,
                      onTap: () => setState(() {}),
                    ),

                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    // ================= 4. حقل كلمة المرور =================
                    _buildLabel(getTranslated('password', context)),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    CustomTextFieldWidget(
                      hintText: getTranslated('password_hint', context),
                      isShowBorder: true,
                      isPassword: _obscurePassword,
                      isShowSuffixIcon: true,
                      focusNode: _passwordFocus,
                      controller: _passwordController,
                      inputAction: TextInputAction.done,
                      prefixIconUrl: Images.passwordIcon,
                      isShowPrefixIcon: true,
                      borderRadius: Dimensions.paddingSizeSmall,

                      onTap: () => setState(() {}),
                    ),

                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    // ================= 5. تذكرني =================
                    const RememberWidget(),

                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    // ================= 6. رسالة الخطأ =================
                    if (authProvider.loginErrorMessage != null &&
                        authProvider.loginErrorMessage!.isNotEmpty)
                      _buildErrorMessage(authProvider.loginErrorMessage!),

                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    // ================= 7. زر تسجيل الدخول =================
                    CustomButtonWidget(
                      isLoading: authProvider.isLoading,
                      btnTxt: getTranslated('login', context),
                      onTap: () => _handleLogin(authProvider),
                    ),

                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    // ================= 8. رابط الانضمام كعامل توصيل =================
                    if (splashProvider.configModel?.toggleDmRegistration ??
                        false)
                      _buildRegisterLink(),

                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    // ================= 9. رقم الإصدار =================
                    Center(
                      child: Text(
                        'v1.0.0 • Driver Edition',
                        style: rubikRegular.copyWith(
                          fontSize: 11,
                          color: Theme.of(context).disabledColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // === عناصر الواجهة الفرعية (Sub-Widgets) ===

  Widget _buildHeaderLogo(Color primaryColor) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // هالة ضوئية خلف الشعار
            Container(
              width: 115,
              height: 115,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withOpacity(0.08),
              ),
            ),
            // إطار الشعار
            Container(
              width: 95,
              height: 95,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.12),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Image.asset(
                Images.logo,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.delivery_dining_rounded,
                  size: 50,
                  color: primaryColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // شارة تطبيق العامل (Driver Badge)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: primaryColor.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.two_wheeler, size: 16, color: primaryColor),
              const SizedBox(width: 6),
              Text(
                getTranslated('delivery_man', context).toUpperCase(),
                style: rubikMedium.copyWith(
                  fontSize: 12,
                  color: primaryColor,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getTranslated('login_to_your_account', context),
          style: rubikBold.copyWith(
            fontSize: 22,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          getTranslated(
            'login_to_your_account_to_view_all_deliveries',
            context,
          ),
          style: rubikRegular.copyWith(
            fontSize: 13,
            color: Theme.of(context).hintColor,
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String title) {
    return Text(
      title,
      style: rubikMedium.copyWith(
        fontSize: 13,
        color: Theme.of(context).textTheme.bodyLarge?.color,
      ),
    );
  }

  Widget _buildErrorMessage(String message) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: Theme.of(context).colorScheme.error,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: rubikRegular.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterLink() {
    return Center(
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const DeliveryManRegistrationScreen(),
            ),
          );
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${getTranslated('join_as_a', context)} ',
                style: rubikRegular.copyWith(
                  color: Theme.of(context).disabledColor,
                  fontSize: 14,
                ),
              ),
              Text(
                getTranslated('delivery_man', context),
                style: rubikMedium.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // === منطق تسجيل الدخول (Logic Layer) ===

  void _handleLogin(AuthProvider authProvider) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty) {
      showCustomSnackBarHelper(getTranslated('enter_email_address', context));
      return;
    }
    if (EmailCheckerHelper.isNotValid(email)) {
      showCustomSnackBarHelper(getTranslated('enter_valid_email', context));
      return;
    }
    if (password.isEmpty) {
      showCustomSnackBarHelper(getTranslated('enter_password', context));
      return;
    }
    if (password.length < 6) {
      showCustomSnackBarHelper(getTranslated('password_should_be', context));
      return;
    }

    final status = await authProvider.login(
      emailAddress: email,
      password: password,
    );

    if (status.isSuccess && mounted) {
      if (authProvider.isActiveRememberMe) {
        authProvider.saveUserNumberAndPassword(email, password);
      } else {
        authProvider.clearUserEmailAndPassword();
      }

      // الانتقال باستخدام BuildContext الحالية بأمان بدلاً من Get.context!
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    }
  }

  void _requestNotificationPermission() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      try {
        await Future.delayed(const Duration(seconds: 1));
        await FirebaseMessaging.instance.requestPermission();
      } catch (_) {}
    }
  }
}
