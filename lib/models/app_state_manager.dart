// Manage the app's navigation state

import 'dart:async';
import 'package:flutter/material.dart';

class FooderlichTab {
  static const int explore = 0;
  static const int recipes = 1;
  static const int toBuy = 2;
}

class AppStateManager extends ChangeNotifier {
  bool _initialized = false;
  bool _loggedIn = false;
  bool _onboardingComplete = false;
  int _selectedTab = FooderlichTab.explore;

  bool get isInitialized => _initialized;
  bool get isLoggedIn => _loggedIn;
  bool get isOnboardingComplete => _onboardingComplete;
  int get getSelectedTab => _selectedTab;

  // TODO: Add initalizeApp
  // TODO: Add login
  // TODO: Add completeOnboarding
  // TODO: Add goTOTab
  // TODO: Add goToRecipes
  // TODO: Add logout
}
