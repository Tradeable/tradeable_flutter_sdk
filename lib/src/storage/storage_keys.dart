/// Storage keys used throughout the package
class StorageKeys {
  static const String _prefix = 'tradeable_flutter_sdk_';

  // UI State
  static const String isDrawerDialogueShown =
      '${_prefix}is_drawer_dialogue_shown';
  static const String isSideDrawerOpenedOnce =
      '${_prefix}is_side_drawer_opened_once';

  // Don't allow instantiation
  StorageKeys._();
}
