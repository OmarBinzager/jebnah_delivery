import 'package:flutter/material.dart';
import 'package:jebnah_delivery/common/providers/permission_handler_provider.dart';
import 'package:jebnah_delivery/common/widgets/custom_pop_scope_widget.dart';
import 'package:jebnah_delivery/features/home/widgets/location_permission_widget.dart';
import 'package:jebnah_delivery/features/home/widgets/order_widget.dart';
import 'package:jebnah_delivery/features/language/screens/choose_language_screen.dart';
import 'package:jebnah_delivery/features/order/providers/order_provider.dart';
import 'package:jebnah_delivery/features/profile/providers/profile_provider.dart';
import 'package:jebnah_delivery/features/splash/providers/splash_provider.dart';
import 'package:jebnah_delivery/helper/location_helper.dart';
import 'package:jebnah_delivery/localization/language_constrants.dart';
import 'package:jebnah_delivery/utill/dimensions.dart';
import 'package:jebnah_delivery/utill/images.dart';
import 'package:jebnah_delivery/utill/styles.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return CustomPopScopeWidget(
      isExit: true,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: _buildAppBar(context, isDarkMode),
        body: Consumer<OrderProvider>(
          builder: (context, orderProvider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // شريط إشعارات الأذونات
                _buildPermissionWarning(context),

                const SizedBox(height: Dimensions.paddingSizeSmall),

                // عنوان الطلبات النشطة مع عداد
                _buildActiveOrdersHeader(context, orderProvider),

                const SizedBox(height: Dimensions.paddingSizeSmall),

                // قائمة الطلبات
                Expanded(child: _buildOrdersList(context, orderProvider)),
              ],
            );
          },
        ),
      ),
    );
  }

  // ==================== بناء الـ AppBar ====================
  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDarkMode) {
    return AppBar(
      backgroundColor: Theme.of(context).cardColor,
      elevation: 0,
      leadingWidth: 0,
      toolbarHeight: 70,
      title: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          final user = profileProvider.userInfoModel;
          if (user == null) return const SizedBox.shrink();

          return Row(
            children: [
              // صورة المستخدم مع إطار أنيق
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: FadeInImage.assetNetwork(
                    placeholder: Images.profilePlaceholder,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    imageErrorBuilder: (c, o, s) => Image.asset(
                      Images.profilePlaceholder,
                      height: 48,
                      width: 48,
                      fit: BoxFit.cover,
                    ),
                    image:
                        '${Provider.of<SplashProvider>(context, listen: false).baseUrls?.deliveryManImageUrl}/${user.image}',
                  ),
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeDefault),

              // معلومات المستخدم
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${user.fName ?? ''} ${user.lName ?? ''}',
                      style: rubikSemiBold.copyWith(
                        fontSize: Dimensions.fontSizeLarge,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Icon(Icons.circle, size: 8, color: Colors.green),
                        const SizedBox(width: 4),
                        Text(
                          getTranslated('online', context),
                          style: rubikRegular.copyWith(
                            fontSize: Dimensions.fontSizeExtraSmall,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      actions: [
        // زر التحديث
        Consumer<OrderProvider>(
          builder: (context, orderProvider, child) {
            final hasOrders =
                (orderProvider.currentOrders?.isNotEmpty ?? false);
            return Container(
              margin: const EdgeInsets.only(right: 4),
              child: IconButton(
                icon: Icon(
                  Icons.refresh_rounded,
                  color: hasOrders
                      ? Theme.of(context).textTheme.bodyLarge!.color
                      : Theme.of(context).primaryColor,
                  size: 28,
                ),
                onPressed: () {
                  orderProvider.refresh(context);
                },
                tooltip: getTranslated('refresh', context),
              ),
            );
          },
        ),

        // زر القائمة
        Container(
          margin: const EdgeInsets.only(right: 8),
          child: PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'language':
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          const ChooseLanguageScreen(fromHomeScreen: true),
                    ),
                  );
                  break;
                case 'profile':
                  // يمكن إضافة الانتقال إلى صفحة الملف الشخصي
                  break;
              }
            },
            icon: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Colors.grey.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.more_vert_rounded,
                color: Theme.of(context).textTheme.bodyLarge!.color,
                size: 24,
              ),
            ),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'language',
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.language,
                        color: Theme.of(context).primaryColor,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeDefault),
                    Text(
                      getTranslated('change_language', context),
                      style: rubikMedium.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'profile',
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person_outline,
                        color: Colors.blue,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeDefault),
                    Text(
                      getTranslated('profile', context),
                      style: rubikMedium.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==================== شريط تحذير الأذونات ====================
  Widget _buildPermissionWarning(BuildContext context) {
    return Consumer<PermissionHandlerProvider>(
      builder: (context, permissionProvider, child) {
        final showWarning =
            permissionProvider.isShownLocationWarning ||
            permissionProvider.isShownNotificationWarning;

        if (!showWarning) return const SizedBox.shrink();

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeDefault,
            vertical: Dimensions.paddingSizeExtraSmall,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange.shade700, Colors.orange.shade500],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _handlePermissionTap(context, permissionProvider),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeDefault,
                  vertical: Dimensions.paddingSizeDefault,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.warning_rounded,
                        color: Colors.orange.shade700,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeDefault),

                    Expanded(
                      child: Text(
                        getTranslated(
                          permissionProvider.getWarningText(),
                          context,
                        ),
                        style: rubikMedium.copyWith(
                          color: Colors.white,
                          fontSize: Dimensions.fontSizeSmall,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.black,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ==================== معالجة النقر على تحذير الأذونات ====================
  void _handlePermissionTap(
    BuildContext context,
    PermissionHandlerProvider permissionProvider,
  ) async {
    if (permissionProvider.isShownNotificationWarning) {
      permissionProvider.setOpenSetting(true);
      await Geolocator.openAppSettings();
    } else {
      if (permissionProvider.locationPermission == LocationPermission.always ||
          permissionProvider.locationPermission ==
              LocationPermission.whileInUse) {
        LocationHelper.onLocationShowDialog(
          context,
          dialog: LocationPermissionWidget(
            fromDashboard: true,
            onPressed: () async {
              Navigator.pop(context);
              permissionProvider.setOpenSetting(true);
              await Geolocator.openAppSettings();
            },
          ),
        );
      } else {
        if (context.mounted) {
          await LocationHelper.checkPermission(context);
          final permission = await Geolocator.checkPermission();
          permissionProvider.setLocationPermission(permission);
        }
      }
    }
  }

  // ==================== عنوان الطلبات النشطة ====================
  Widget _buildActiveOrdersHeader(
    BuildContext context,
    OrderProvider orderProvider,
  ) {
    final orderCount = orderProvider.currentOrders?.length ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSizeDefault,
        vertical: Dimensions.paddingSizeExtraSmall,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.delivery_dining,
                  color: Theme.of(context).primaryColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),
              Text(
                getTranslated('active_order', context),
                style: rubikSemiBold.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),

          // عداد الطلبات
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: orderCount > 0
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).disabledColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              orderCount > 0
                  ? '$orderCount ${getTranslated('orders', context)}'
                  : getTranslated('no_orders', context),
              style: rubikMedium.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: orderCount > 0
                    ? Colors.white
                    : Theme.of(context).disabledColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== قائمة الطلبات ====================
  Widget _buildOrdersList(BuildContext context, OrderProvider orderProvider) {
    final orders = orderProvider.currentOrders;

    if (orders == null) {
      return _buildLoadingState(context);
    }

    if (orders.isEmpty) {
      return _buildEmptyState(context);
    }

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      displacement: 20,
      color: Colors.white,
      backgroundColor: Theme.of(context).primaryColor,
      onRefresh: () => orderProvider.refresh(context),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeDefault,
        ),
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(
              bottom: Dimensions.paddingSizeDefault,
            ),
            child: OrderWidget(orderModel: orders[index], index: index),
          );
        },
      ),
    );
  }

  // ==================== حالة التحميل ====================
  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),
          Text(
            getTranslated('loading_orders', context),
            style: rubikRegular.copyWith(
              color: Theme.of(context).disabledColor,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== حالة عدم وجود طلبات ====================
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inbox_outlined,
              size: 60,
              color: Theme.of(context).primaryColor.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),
          Text(
            getTranslated('no_order_found', context),
            style: rubikSemiBold.copyWith(
              fontSize: Dimensions.fontSizeExtraLarge,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          Text(
            getTranslated('no_orders_description', context),
            style: rubikRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              color: Theme.of(context).disabledColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),
          ElevatedButton.icon(
            onPressed: () {
              Provider.of<OrderProvider>(
                context,
                listen: false,
              ).refresh(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            icon: const Icon(Icons.refresh, color: Colors.white),
            label: Text(
              getTranslated('refresh', context),
              style: rubikMedium.copyWith(
                color: Colors.white,
                fontSize: Dimensions.fontSizeDefault,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
