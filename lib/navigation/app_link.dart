/// AppLink is the navigation state object.
/// It is the intermediary object between a URL string and the app state.
/// The objective of this class is to parse the navigation configuration to and
/// from a URL string
class AppLink {
  static const String kHomePath = '/home';
  static const String kOnboardingPath = '/onboarding';
  static const String kLoginPath = '/login';
  static const String kProfilePath = '/profile';
  static const String kItemPath = '/item';

  static const String kTabParam = 'tab';
  static const String kIdParam = 'id';

  // Store the path of the URL
  String? location;

  // Store the tab you want to redirect the user to.
  int? currentTab;

  // Store the ID of the item you want to view
  String? itemId;

  AppLink({
    this.location,
    this.currentTab,
    this.itemId,
  });

  // Convert a URL string to an AppLink
  static AppLink fromLocation(String? location) {
    location = Uri.decodeFull(location ?? '');
    final uri = Uri.parse(location);
    final params = uri.queryParameters;
    final currentTab = int.tryParse(params[AppLink.kTabParam] ?? '');
    final itemId = params[AppLink.kIdParam];
    final link = AppLink(
      location: uri.path,
      currentTab: currentTab,
      itemId: itemId,
    );

    return link;
  }

  // Convert an AppLink to a URL string
  String toLocation() {
    String addKeyValPair({
      required String key,
      String? value,
    }) =>
        value == null ? '' : '$key=$value&';

    switch (location) {
      case kLoginPath:
        return kLoginPath;
      case kOnboardingPath:
        return kOnboardingPath;
      case kProfilePath:
        return kProfilePath;
      case kItemPath:
        var loc = '$kItemPath?';
        loc += addKeyValPair(
          key: kIdParam,
          value: itemId,
        );
        return Uri.encodeFull(loc);
      default:
        var loc = '$kHomePath?';
        loc += addKeyValPair(
          key: kTabParam,
          value: currentTab.toString(),
        );
        return Uri.encodeFull(loc);
    }
  }
}
