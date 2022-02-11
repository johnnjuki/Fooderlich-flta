// Handle routing requests

import 'package:flutter/material.dart';
import 'package:fooderlich/screens/webview_screen.dart';

import 'app_link.dart';
import '../models/models.dart';
import '../screens/screens.dart';

class AppRouter extends RouterDelegate<AppLink>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  final AppStateManager appStateManager;
  final GroceryManager groceryManager;
  final ProfileManager profileManager;

  AppRouter({
    required this.appStateManager,
    required this.groceryManager,
    required this.profileManager,
  }) : navigatorKey = GlobalKey<NavigatorState>() {
    appStateManager.addListener(notifyListeners);
    groceryManager.addListener(notifyListeners);
    profileManager.addListener(notifyListeners);
  }

  @override
  void dispose() {
    appStateManager.removeListener(notifyListeners);
    groceryManager.removeListener(notifyListeners);
    profileManager.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onPopPage: _handlePopPage,
      pages: [
        if (!appStateManager.isInitialized) SplashScreen.page(),
        if (appStateManager.isInitialized && !appStateManager.isLoggedIn)
          LoginScreen.page(),
        if (appStateManager.isLoggedIn && !appStateManager.isOnboardingComplete)
          OnboardingScreen.page(),
        if (appStateManager.isOnboardingComplete)
          Home.page(appStateManager.getSelectedTab),
        if (groceryManager.isCreatingNewItem)
          GroceryItemScreen.page(
            onCreate: (item) {
              groceryManager.addItem(item);
            },
            onUpdate: (item, index) {},
          ),
        if (groceryManager.selectedIndex != -1)
          GroceryItemScreen.page(
            item: groceryManager.selectedGroceryItem,
            index: groceryManager.selectedIndex,
            onUpdate: (item, index) {
              groceryManager.updateItem(item, index);
            },
            onCreate: (_) {},
          ),
        if (profileManager.didSelectUser)
          ProfileScreen.page(profileManager.getUser),
        if (profileManager.didTapOnRaywenderlich)
          WebViewScreen.page(),
      ],
    );
  }

  // Handle pop events
  bool _handlePopPage(Route<dynamic> route, result) {
    if (!route.didPop(result)) {
      return false;
    }

    // Handle Onboarding and splash
    if (route.settings.name == FooderlichPages.onboardingPath) {
      appStateManager.logout();
    }

    // Handle state when user closes grocery item screen
    if (route.settings.name == FooderlichPages.groceryItemDetails) {
      groceryManager.groceryItemTapped(-1);
    }

    // Handle state when user closes profile screen
    if (route.settings.name == FooderlichPages.profilePath) {
      profileManager.tapOnProfile(false);
    }

    // Handle state when user closes webview screen
    if (route.settings.name == FooderlichPages.raywenderlich) {
      profileManager.tapOnRaywenderlich(false);
    }

    return true;
  }

  /// Convert the app state to a URL
  // Convert app state to applink
  AppLink getCurrentPath() {
    if (!appStateManager.isLoggedIn) {
      return AppLink(location: AppLink.kLoginPath);
    } else if (!appStateManager.isOnboardingComplete) {
      return AppLink(location: AppLink.kOnboardingPath);
    } else if (profileManager.didSelectUser) {
      return AppLink(location: AppLink.kProfilePath);
    } else if (groceryManager.isCreatingNewItem) {
      return AppLink(location: AppLink.kItemPath);
    } else if (groceryManager.selectedGroceryItem != null) {
      final id = groceryManager.selectedGroceryItem?.id;
      return AppLink(location: AppLink.kItemPath, itemId: id);
    } else {
      return AppLink(
        location: AppLink.kHomePath,
        currentTab: appStateManager.getSelectedTab,
      );
    }
  }

  // Apply configuration helper
  @override
  AppLink get currentConfiguration => getCurrentPath();

  // Convert a URL to an app state
  @override
  Future setNewRoutePath(AppLink newLink) async {
    switch (newLink.location) {
      case AppLink.kProfilePath:
        profileManager.tapOnProfile(true);
        break;
      case AppLink.kItemPath:
        final itemId = newLink.itemId;
        if (itemId != null) {
          groceryManager.setSelectedGroceryItem(itemId);
        } else {
          groceryManager.createNewItem();
        }
        profileManager.tapOnProfile(false);
        break;
      case AppLink.kHomePath:
        appStateManager.goToTab(newLink.currentTab ?? 0);
        profileManager.tapOnProfile(false);
        groceryManager.groceryItemTapped(-1);
        break;
      default:
        break;
    }
  }
}
