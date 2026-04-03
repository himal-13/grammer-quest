import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static RewardedAd? _rewardedAd;
  static bool _isAdLoaded = false;

  static String rewardedAdUnitId ="ca-app-pub-3940256099942544/5224354917";

  static void loadRewardedAd({void Function()? onAdLoaded}) {
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isAdLoaded = true;
          onAdLoaded?.call();
          
          _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _isAdLoaded = false;
              loadRewardedAd(); // Load next ad
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _isAdLoaded = false;
              loadRewardedAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          _isAdLoaded = false;
          _rewardedAd = null;
          print('RewardedAd failed to load: $error');
        },
      ),
    );
  }

  static void showRewardedAd({
    required Function(RewardItem reward) onUserEarnedReward,
    Function()? onAdDismissed,
  }) {
    if (_isAdLoaded && _rewardedAd != null) {
      // _rewardedAd!.show(onUserEarnedReward: onUserEarnedReward);
    } else {
      print('Rewarded ad not loaded yet.');
      loadRewardedAd();
    }
  }

  static bool get isAdLoaded => _isAdLoaded;
}
