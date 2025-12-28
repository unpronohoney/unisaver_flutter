import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:unisaver_flutter/constants/admob_ids.dart';
import 'package:unisaver_flutter/constants/background2.dart';
import 'package:unisaver_flutter/constants/colors.dart';
import 'package:unisaver_flutter/utils/loc.dart';
import 'package:unisaver_flutter/widgets/texts/description_text.dart';
import 'package:unisaver_flutter/widgets/texts/head_text.dart';
import 'package:unisaver_flutter/widgets/texts/second_head_text.dart';
import 'package:unisaver_flutter/widgets/unisaver_upside_bar.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});
  @override
  State<StatefulWidget> createState() => _StateInfoPage();
}

class _StateInfoPage extends State<InfoPage> {
  late BannerAd _banner;
  bool _isBannerLoaded = false;

  bool _isExpanded1 = false;
  bool _isExpanded2 = false;
  bool _isExpanded3 = false;
  bool _isExpanded4 = false;
  @override
  void initState() {
    super.initState();
    _banner = BannerAd(
      adUnitId: AdMobIds.infoContactBanner,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() => _isBannerLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Stack(
        children: [
          const BlobBackground2(),
          SafeArea(
            child: Column(
              children: [
                UnisaverUpsideBar(
                  icon: Icons.home_filled,
                  onHomePressed: () {
                    Navigator.pop(context);
                  },
                  onRefreshPressed: () {},
                  isrightbuttonappear: false,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              HeadText(text: t(context).giveAdvise),
                              const SizedBox(height: 24),
                              DescriptionText(text: t(context).aimOfProject),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        ExpansionTile(
                          iconColor: Theme.of(
                            context,
                          ).colorScheme.secondaryFixed,
                          collapsedIconColor: AppColors.grayishBlue,
                          trailing: AnimatedRotation(
                            turns: _isExpanded1 ? 0.5 : 0,
                            duration: Duration(milliseconds: 200),
                            child: Icon(Icons.expand_more, size: 30),
                          ),
                          onExpansionChanged: (value) {
                            setState(() => _isExpanded1 = value);
                          },
                          title: SecondHeadText(text: t(context).info_head1),
                          childrenPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          children: [
                            const SizedBox(height: 12),
                            DescriptionText(text: t(context).head1_exp),
                            const SizedBox(height: 16),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ExpansionTile(
                          iconColor: Theme.of(
                            context,
                          ).colorScheme.secondaryFixed,
                          collapsedIconColor: AppColors.grayishBlue,
                          trailing: AnimatedRotation(
                            turns: _isExpanded2 ? 0.5 : 0,
                            duration: Duration(milliseconds: 200),
                            child: Icon(Icons.expand_more, size: 30),
                          ),
                          onExpansionChanged: (value) {
                            setState(() => _isExpanded2 = value);
                          },
                          title: SecondHeadText(text: t(context).info_head2),
                          childrenPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          children: [
                            const SizedBox(height: 12),
                            DescriptionText(text: t(context).head2_exp),
                            const SizedBox(height: 16),
                          ],
                        ),
                        const SizedBox(height: 8),

                        ExpansionTile(
                          iconColor: Theme.of(
                            context,
                          ).colorScheme.secondaryFixed,
                          collapsedIconColor: AppColors.grayishBlue,
                          trailing: AnimatedRotation(
                            turns: _isExpanded3 ? 0.5 : 0,
                            duration: Duration(milliseconds: 200),
                            child: Icon(Icons.expand_more, size: 30),
                          ),
                          onExpansionChanged: (value) {
                            setState(() => _isExpanded3 = value);
                          },
                          title: SecondHeadText(text: t(context).info_head3),
                          childrenPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          children: [
                            const SizedBox(height: 12),
                            DescriptionText(text: t(context).head3_exp),
                            const SizedBox(height: 16),
                          ],
                        ),
                        const SizedBox(height: 8),

                        ExpansionTile(
                          iconColor: Theme.of(
                            context,
                          ).colorScheme.secondaryFixed,
                          collapsedIconColor: AppColors.grayishBlue,
                          trailing: AnimatedRotation(
                            turns: _isExpanded4 ? 0.5 : 0,
                            duration: Duration(milliseconds: 200),
                            child: Icon(Icons.expand_more, size: 30),
                          ),
                          onExpansionChanged: (value) {
                            setState(() => _isExpanded4 = value);
                          },
                          title: SecondHeadText(text: t(context).info_head4),
                          childrenPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          children: [
                            const SizedBox(height: 12),
                            DescriptionText(text: t(context).head4_exp),
                            const SizedBox(height: 16),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                if (_isBannerLoaded)
                  SizedBox(
                    width: _banner.size.width.toDouble(),
                    height: _banner.size.height.toDouble(),
                    child: AdWidget(ad: _banner),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
