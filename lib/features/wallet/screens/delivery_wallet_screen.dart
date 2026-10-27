import 'package:flutter/material.dart';
import 'package:jebnah_delivery/features/wallet/providers/delivery_wallet_provider.dart';
import 'package:jebnah_delivery/features/wallet/widgets/custody_card_widget.dart';
import 'package:jebnah_delivery/features/wallet/widgets/custody_transaction_widget.dart';
import 'package:jebnah_delivery/localization/language_constrants.dart';
import 'package:jebnah_delivery/utill/dimensions.dart';
import 'package:jebnah_delivery/utill/styles.dart';
import 'package:provider/provider.dart';

class DeliveryWalletScreen extends StatefulWidget {
  const DeliveryWalletScreen({super.key});

  @override
  State<DeliveryWalletScreen> createState() => _DeliveryWalletScreenState();
}

class _DeliveryWalletScreenState extends State<DeliveryWalletScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<DeliveryWalletProvider>(context, listen: false);
      provider.getWallet(reload: true);
      provider.getWalletTransactions(offset: 1, type: 'all', reload: true);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        Provider.of<DeliveryWalletProvider>(context, listen: false).loadMoreTransactions();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).textTheme.bodyLarge?.color, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          getTranslated('delivery_wallet_title', context),
          style: rubikMedium.copyWith(
            fontSize: Dimensions.fontSizeLarge,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<DeliveryWalletProvider>(
        builder: (context, walletProvider, child) {
          if (walletProvider.isLoading && walletProvider.walletModel == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () async {
              await walletProvider.getWallet(reload: true);
              await walletProvider.getWalletTransactions(offset: 1, reload: true);
            },
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // Top Wallet Card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    child: walletProvider.walletModel != null
                        ? CustodyCardWidget(wallet: walletProvider.walletModel!)
                        : const SizedBox.shrink(),
                  ),
                ),

                // Filter Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getTranslated('transactions_history', context),
                          style: rubikSemiBold.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                        _buildFilterChips(context, walletProvider),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                      ],
                    ),
                  ),
                ),

                // Transactions List
                if (walletProvider.isTransactionLoading && (walletProvider.transactionList == null || walletProvider.transactionList!.isEmpty)) ...[
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ] else if (walletProvider.transactionList == null || walletProvider.transactionList!.isEmpty) ...[
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.receipt_long_outlined, size: 64, color: Theme.of(context).hintColor.withOpacity(0.4)),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          Text(
                            getTranslated('no_transactions_found', context),
                            style: rubikRegular.copyWith(
                              color: Theme.of(context).hintColor,
                              fontSize: Dimensions.fontSizeDefault,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final tx = walletProvider.transactionList![index];
                          return CustodyTransactionWidget(transaction: tx);
                        },
                        childCount: walletProvider.transactionList!.length,
                      ),
                    ),
                  ),
                  if (walletProvider.isTransactionLoading) ...[
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                  ],
                ],

                const SliverToBoxAdapter(
                  child: SizedBox(height: Dimensions.paddingSizeExtraLarge),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context, DeliveryWalletProvider provider) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _chipItem(
            context,
            title: getTranslated('all_transactions', context),
            filterKey: 'all',
            isSelected: provider.selectedFilter == 'all',
            onTap: () => provider.setFilterType('all'),
          ),
          const SizedBox(width: 8),
          _chipItem(
            context,
            title: getTranslated('collections_only', context),
            filterKey: 'cash_collection',
            isSelected: provider.selectedFilter == 'cash_collection',
            onTap: () => provider.setFilterType('cash_collection'),
          ),
          const SizedBox(width: 8),
          _chipItem(
            context,
            title: getTranslated('settlements_only', context),
            filterKey: 'custody_settlement',
            isSelected: provider.selectedFilter == 'custody_settlement',
            onTap: () => provider.setFilterType('custody_settlement'),
          ),
        ],
      ),
    );
  }

  Widget _chipItem(
    BuildContext context, {
    required String title,
    required String filterKey,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Theme.of(context).dividerColor.withOpacity(0.2),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          title,
          style: rubikMedium.copyWith(
            color: isSelected
                ? Colors.white
                : Theme.of(context).textTheme.bodyLarge?.color,
            fontSize: Dimensions.fontSizeSmall,
          ),
        ),
      ),
    );
  }
}
