import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  RemoteConfigService._();

  static final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  static const String _promoTitleKey = 'promo_title';
  static const String _promoSubtitleKey = 'promo_subtitle';

  static Future<void> init() async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(seconds: 0),
      ),
    );

    await _remoteConfig.setDefaults(const {
      _promoTitleKey: 'Happy Than Ever',
      _promoSubtitleKey: 'New Album',
    });

    try {
      await _remoteConfig.fetchAndActivate();
    } catch (_) {

    }
  }

  static Future<bool> refresh() async {
    try {
      return await _remoteConfig.fetchAndActivate();
    } catch (_) {
      return false;
    }
  }

  static String get promoTitle => _remoteConfig.getString(_promoTitleKey);

  static String get promoSubtitle => _remoteConfig.getString(_promoSubtitleKey);
}